#include "tls.h"
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <stdbool.h>
#include <unistd.h>

#define MAX_THREAD_COUNT 128
/*
 * This is a good place to define any data structures you will use in this file.
 * For example:
 *  - struct TLS: may indicate information about a thread's local storage
 *    (which thread, how much storage, where is the storage in memory)
 *  - struct page: May indicate a shareable unit of memory (we specified in
 *    homework prompt that you don't need to offer fine-grain cloning and CoW,
 *    and that page granularity is sufficient). Relevant information for sharing
 *    could be: where is the shared page's data, and how many threads are sharing it
 *  - Some kind of data structure to help find a TLS, searching by thread ID.
 *    E.g., a list of thread IDs and their related TLS structs, or a hash table.
 */
struct page {
 unsigned long int address; /* start address of page */
 int ref_count; /* counter for shared pages */
};


typedef struct thread_local_storage
{
 pthread_t tid;
 unsigned int size; /* size in bytes */
 unsigned int page_num; /* number of pages */
 struct page **pages; /* array of pointers to pages */
} TLS;


struct tid_tls_pair
{
 pthread_t tid;
 TLS *tls;
};
static struct tid_tls_pair *tid_tls_pairs[MAX_THREAD_COUNT];
unsigned int page_size = 0;
static int index = 0;
pthread_mutex_t lock;
/*
 * Now that data structures are defined, here's a good place to declare any
 * global variables.
 */

/*
 * With global data declared, this is a good point to start defining your
 * static helper functions.
 */

void tls_handle_page_fault(int sig, siginfo_t *si, void *context){
	
	bool fault = false;

	unsigned long int p_fault = ( (unsigned long int) si->si_addr) & ~(page_size - 1);
	
	for (int i = 0; i < MAX_THREAD_COUNT; i++){
		
		if (tid_tls_pairs[i] == NULL){
			continue;
		}
		
		for (int k = 0; k < tid_tls_pairs[i]->tls->page_num; k++){

			if ( tid_tls_pairs[i]->tls->pages[k]->address == p_fault){
					fault = true;
					pthread_exit(NULL);
					return;
			}
		}
		
	}

	if (!fault){

		signal(SIGSEGV, SIG_DFL);
 		signal(SIGBUS, SIG_DFL);
 		raise(sig);
	}
}

void tls_init()
{
 	struct sigaction sigact;
 	page_size = getpagesize();
 	/* Handle page faults (SIGSEGV, SIGBUS) */
 	sigemptyset(&sigact.sa_mask);
 	/* Give context to handler */
 	sigact.sa_flags = SA_SIGINFO;
 	sigact.sa_sigaction = tls_handle_page_fault;
 	sigaction(SIGBUS, &sigact, NULL);
 	sigaction(SIGSEGV, &sigact, NULL);
	pthread_mutex_init(&lock, NULL);
}

void tls_protect(struct page *p)
{
 	if (mprotect((void *) p->address, page_size, 0)) {
 		fprintf(stderr, "tls_protect: could not protect page\n");
 		exit(1);
 	}
}

void tls_unprotect(struct page *p)
{
 	if (mprotect((void *) p->address, page_size, PROT_READ| PROT_WRITE)) {
 		fprintf(stderr, "tls_unprotect: could not unprotect page\n");
 		exit(1);
 	}
}



/*
 * Lastly, here is a good place to add your externally-callable functions.
 */ 

int tls_create(unsigned int size)
{
	static bool isFirst = true;

	if (isFirst){
		tls_init();
		isFirst = false;
	}

	pthread_t id = pthread_self();
	bool exist = false;
	for (int i = 0; i < MAX_THREAD_COUNT; i++){

		if (tid_tls_pairs[i] == NULL){
			continue;
		}

		if (tid_tls_pairs[i]->tid == id){
			exist = true;
			break;
		}
	}

	if (exist || size <= 0){
		// pthread_mutex_unlock(&lock);
		return -1;
	}

	// create

	TLS* Tls = (TLS*) calloc (1, sizeof(TLS));
	struct tid_tls_pair *new_pair = (struct tid_tls_pair*) calloc (1, sizeof(struct tid_tls_pair));
	Tls->tid = pthread_self();
	Tls->size = size;

	int p_num = 0;

	if (size % page_size != 0){
		p_num = ( size / page_size ) + 1;
	}else {
		p_num = size / page_size;
	}

	Tls->page_num = p_num;

	Tls->pages = (struct page**) calloc (p_num, sizeof(struct page*));
	for (int i = 0; i < p_num; i++){
		struct page* P = (struct page*) calloc (1, sizeof (struct page));
		P->address = (unsigned long int) mmap (0, page_size, 0, MAP_ANON | MAP_PRIVATE, 0, 0);
		P->ref_count = 1;
		Tls->pages[i] = P;
	}

	new_pair->tid = pthread_self();
	new_pair->tls = Tls;
	tid_tls_pairs[index++] = new_pair;
 
	return 0;
}

int tls_destroy()
{
	pthread_mutex_lock (&lock);
	pthread_t id = pthread_self();
	int Index = 0;

	struct tid_tls_pair* current;
	bool find = false;
	for (int i = 0; i < MAX_THREAD_COUNT; i++){

		if (tid_tls_pairs[i] == NULL){
			continue;
		}
		
		if (tid_tls_pairs[i]->tid == id){
			current = tid_tls_pairs[i];
			Index = i;
			find = true;
			break;
		}
	}

	if (!find) {
		pthread_mutex_unlock(&lock);
		return -1;
	}

	for (int i = 0; i < current->tls->page_num; i++){
		if (current->tls->pages[i]->ref_count <= 1){
			free (current->tls->pages[i]);
		}else {
			current->tls->pages[i]->ref_count--;
		}
	}

	free (current->tls);
	tid_tls_pairs[Index] = NULL;

	pthread_mutex_unlock(&lock);
	return 0;
}

int tls_read(unsigned int offset, unsigned int length, char *buffer)
{
	pthread_mutex_lock (&lock);
	pthread_t id = pthread_self();

	struct tid_tls_pair* current;
	bool find = false;
	for (int i = 0; i < MAX_THREAD_COUNT; i++){

		if (tid_tls_pairs[i] == NULL){
			continue;
		}

		if (tid_tls_pairs[i]->tid == id){
			current = tid_tls_pairs[i];
			find = true;
			break;
		}
	}

	if (!find) {
		pthread_mutex_unlock(&lock);
		return -1;
	}

	if (current->tls->size < length + offset){
		pthread_mutex_unlock(&lock);
		return -1;
	}

	//unprotect
	for (int i = 0; i < current->tls->page_num; i++){
		tls_unprotect (current->tls->pages[i]);
	}

	//read
	for (int i = 0, j = offset; j < ( offset + length ); i++, j++) {

 		struct page *p;
 		unsigned int Pn, Poff;
 		
		Pn = j / page_size;
 		Poff = j % page_size;
 		p = current->tls->pages[Pn];
 		
		char* content = ((char *) p->address) + Poff;
 		buffer[i] = *content;
 	}

	//protect
	for (int i = 0; i < current->tls->page_num; i++){
		tls_protect (current->tls->pages[i]);
	}

	pthread_mutex_unlock(&lock);
	return 0;
}

int tls_write(unsigned int offset, unsigned int length, const char *buffer)
{
	pthread_mutex_lock (&lock);
	pthread_t id = pthread_self();
	struct tid_tls_pair* current;
	bool find = false;

	for (int i = 0; i < MAX_THREAD_COUNT; i++){

		if (tid_tls_pairs[i] == NULL){
			continue;
		}

		if (tid_tls_pairs[i]->tid == id){
			current = tid_tls_pairs[i];
			find = true;
			break;
		}
	}

	if (!find) {
		pthread_mutex_unlock(&lock);
		return -1;
	}
	if (current->tls->size < length + offset){
		pthread_mutex_unlock(&lock);
		return -1;
	}

	//unprotect
	for (int i = 0; i < current->tls->page_num; i++){
		tls_unprotect (current->tls->pages[i]);
	}

	//write
	for (int i = 0, j = offset; j < ( offset + length ); i++, j++) {
 		struct page *p; 
 		unsigned int pn, poff;

 		pn = j / page_size;
 		poff = j % page_size;
 		p = current->tls->pages[pn];

		struct page* copy;

 		if (p->ref_count > 1) {
 

		copy = ( struct page* ) calloc ( 1, sizeof (struct page) );
 		copy->address = (unsigned long int) mmap (0, page_size, PROT_WRITE, MAP_ANON | MAP_PRIVATE, 0, 0);
 
 		copy->ref_count = 1;
 		current->tls->pages[pn] = copy;
 
 		p->ref_count--;
 		tls_protect(p);
 		p = copy;

 		}
 		char* content = ((char *) p->address) + poff;
 		*content = buffer[i];
	}
	//protect
	for (int i = 0; i < current->tls->page_num; i++){
		tls_protect (current->tls->pages[i]);
	}


	pthread_mutex_unlock(&lock);
	return 0;
}

int tls_clone(pthread_t tid)
{
	pthread_mutex_lock (&lock);
	struct tid_tls_pair* target;
	bool find = false;
	for (int i = 0; i < MAX_THREAD_COUNT; i++){

		if (tid_tls_pairs[i] == NULL){
			continue;
		}

		if (tid_tls_pairs[i]->tid == tid){
			target = tid_tls_pairs[i];
			find = true;
			break;
		}
	}

	if (!find){
		pthread_mutex_unlock(&lock);
		return -1;
	}

	
	find = false;
	pthread_t id = pthread_self();
	for (int i = 0; i < MAX_THREAD_COUNT; i++){

		if (tid_tls_pairs[i] == NULL){
			continue;
		}

		if (tid_tls_pairs[i]->tid == id){
			find = true;
			break;
		}
	}

	if (find){
		pthread_mutex_unlock(&lock);
		return -1;
	}


	for (int i = 0; i < target->tls->page_num; i++){

		target->tls->pages[i]->ref_count++;

	}

	TLS* copyer_tls = (TLS*) calloc (1, sizeof(TLS));
	copyer_tls->tid = id;
	copyer_tls->size = target->tls->size;
	copyer_tls->page_num = target->tls->page_num;
	copyer_tls->pages = (struct page**) calloc (copyer_tls->page_num, sizeof (struct page*));

	for (int i = 0; i < copyer_tls->page_num; i++){
		copyer_tls->pages[i] = target->tls->pages[i];
	}

	struct tid_tls_pair* new_pair = (struct tid_tls_pair*) calloc (1, sizeof(struct tid_tls_pair));
	new_pair->tid = id;
	new_pair->tls = copyer_tls;

	tid_tls_pairs[index++] = new_pair;

	pthread_mutex_unlock(&lock);
	return 0;
}
