#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>
#include <stdlib.h>
#include <sys/types.h>
#include <errno.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdbool.h>




#define _SVID_SOURCE
#define STD_INPUT 0   
#define STD_OUTPUT 1



char get_command(char command[], char* param[]) {
	char input[512] = "";
	char input_2[512] = "";
	char* pch;
	

	int index = 0;
	char result = '0';;
	

	
	 
	int err = 1;
	while (err) {
		fgets(input_2, 512, stdin);
		if (feof(stdin)) {

			return '5';
		}
		// input[strlen(input_2) - 1] = '\0';
		int j = 0;
		int check1 = 0;
		int check2 = 0;
		for (int i = 0; i < strlen(input_2); i++) {
			if (input_2[i] == '<' || input_2[i] == '>' || input_2[i] == '|') {
				input[j] = ' ';
				input[j + 1] = input_2[i];
				input[j + 2] = ' ';
				
				/*
				if (check1) {
					check2 = 1;
				}*/

				if ((input_2[i] == input_2[i + 1]) || (input_2[i] == input_2[i + 2])){
				    check1 = 1;
				}
				j = j + 3;
				
			}
			else {

				input[j] = input_2[i];
				j++;
			}
						

		}
		if (!check2) {
			err = 0;
		}
		else {
			printf("Input Error! Retry!\n");
		}
	}
	
	//	input[strlen(input) -1] = '\0';
	

	
	
	for (int i = 0; i < strlen(input); i++) {
		if (input[i] == '<') {
			result = '1';
		}
		else if (input[i] == '>') {

			result = '2';
		}
		else if (input[i] == '|') {
			result = '3';


		}
		else if (input[i] == '&') {
			result = '4';
		}


	}

	pch = strtok(input, " \n");
	memset(param, 0, 512);
	while (pch != NULL) {


		param[index] = (char*)malloc(sizeof(*pch));
		strcpy(param[index++], pch);
		pch = strtok(NULL, " \n");
	}

	strcpy(command, param[0]);

  
	

	return result;

}





int main (int argc, char** argv) {

    bool n = false;
	for (int i = 0; i < 32;i++){
		if (argv[i] == NULL){
			break;
		}
		if (!strcmp(argv[i], "-n")){
			
			n = true;
			break;
		}
	}


	while (1) {
		
	  char state;
	  char command[32];
	  char* param[32];
	  memset(command, 0, 32);
	  memset(param, 0, 32);

      if (!n){
	  printf("my_shell$");
	  }
		state = get_command(command, param);




		if (state == '5') {
		  printf("\n");
			break;
		}

		if (state == '0') {
			if (fork() > 0) {
				wait(NULL);
			}
			else {

				execvp(command, param);
				
			}
		}
		 else if (state == '1') {   // < read in

		    FILE* f;
			int err;
			
			char file_name[32];
			char content[1024];
			strcpy(file_name, param[2]);
						f = fopen(file_name, "r");
			if (f == NULL){

				
				perror("ERROR");
				//fprintf (stderr, "Error opening file: %s\n", strerror(err));
				continue;

			}




			int fd = open(file_name, O_RDONLY|O_CREAT);
			read(fd, content, sizeof(content));
			content[strlen(content) - 1] = '\0';

			
			char* para[1024];

			for (int i = 0; i < 32; i++) {
				if (i == 1) {
					para[i] = (char*)malloc(1024);
					strcpy(para[i], content);
					i++;
					break;
				}
				close(fd);
				para[i] = (char*)malloc(32);
				strcpy(para[i], param[i]);
			}
			if (fork() > 0) {
				wait(NULL);
			}
			else {


				execvp(command, para);



			}


		}
		else if (state == '2') {   // > write to

			int index = 0;
			for (int i = 0; i < 32; i++) {
				if (!strcmp(param[i], ">")) {
					index = i;
					break;
				}
			}

			
			char* sub_param[32];
			for (int i = 0; i < index; i++) {
			  sub_param[i] = (char*) malloc (1024);
				strcpy(sub_param[i], param[i]);
			}

			char file[1024];
			strcpy(file, param[index + 1]);
			int count;
			int fd[2];

			if (fork() > 0){
			  wait(NULL);
			}else {
			  fd[1] = open (file, O_WRONLY|O_CREAT);
			  close (STD_OUTPUT);
			  dup(fd[1]);
			  close(fd[1]);
			  execvp (command, sub_param);
			}		

			



		}
		
		else if (state == '3') {   // pipe
			pid_t pid;
			int p_num = 0;
            
			for (int i = 0; i < 32; i++){
				if (param[i] == NULL){
					break;
				}

				if (!strcmp(param[i], "|")){			
			    	p_num++;			
		        }
		       
			}



			int pfd[2];
			int index = 0;
			int k = 0;
	        char* new_param[32];
	        int pp_i [p_num + 1]; pp_i[0] = 0;          
			int trav = 0;
			int next = 1;
			
            

		    int Index = 1;
			int J = 0;
	

	        for (int i = 0; i < 32; i++){	
				if (param[i] == NULL){
					break;
				}

				if (!strcmp(param[i], "|")){			
			    	pp_i[Index++] = i;			
		        }
		       continue;
	        }
   

			for (int i = 0; i < 32; i++){

				if (param[i] == NULL){
					break;
				}

				if (!strcmp(param[i], "|")){
					continue;
				}else {
					new_param[J] = (char*) malloc (1024);
					strcpy( new_param[J++],param[i]);
					
				}
			}

			bool tail = false;

			while (command){
                int length = 0;
                int s_index = 0; 
				char* sub_param[32];
				memset(sub_param, 0 ,32);

				if (trav == p_num){

					tail = true;

					for (int i = pp_i[trav]; i < 32; i++){
						if (param[i] == NULL){
							break;
						}else if (!strcmp(param[i], "|")){
		              		continue;
	               		} else {
							sub_param[s_index] = (char*) malloc (1024);
					    	strcpy(sub_param[s_index++], param[i]);
							length++; 
						}

					}

				}else {

				for (int i = pp_i[trav]; i < pp_i[next]; i++){

					if (!strcmp(param[i], "|")){
		              continue;
	                } else {
						sub_param[s_index] = (char*) malloc (1024);
					    strcpy(sub_param[s_index++], param[i]);
						length++;
					}
				}
                trav++; next++;

				}
/*
					printf("%s\n", command);
					for (int i = 0; i < 32; i++){
						printf("%s ", sub_param[i]);
					}
					printf("\n");
*/

                pipe(pfd);
				pid = fork();
				if (pid == 0) {

					dup2(k,0);
					if (!tail){
						dup2(pfd[1],1);
					}
					close(pfd[0]);


					execvp (command, sub_param);

				

				} else{
					wait(NULL);
					close(pfd[1]);
					k = pfd[0];
				}

				if (tail) break;
                    index += length;
					memset(command, 0 ,32);
					strcpy(command, new_param[index]);

				
			}





	

		}
				
		else if (state == '4') {   // &

		for (int i = 0; i < 32; i++){
			if (!strcmp(param[i], "&")){
              param[i] = NULL;
              break;
			}
		}
        bool s = true;
		int pid = fork();
		if (pid  > 0) {
			if (!s){
				wait (pid);
			}
			}
			else {

				execvp(command, param);
				
			}

		}
		
		
	}

	return 0;
}
