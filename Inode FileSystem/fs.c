#include <sys/types.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include "disk.h"

#define DISK_BLOCKS  8192      /* number of blocks on the disk                */
#define BLOCK_SIZE   4096      /* block size on "disk"                        */
#define UINT8_SIZE 8
#define MAX_FILE 64

struct dir_entry {
    int is_used;
    uint8_t inode_number;
    uint8_t s_indirect_inode;
    int f_size;
    char* fname ;
};

struct inode {
    
    bool super_init;
    uint16_t direct_offset [16]; // index of blocks  of files
    uint16_t single_indirect;
    uint16_t double_indirect;
 
};


struct super_block {
    uint16_t bitmap [DISK_BLOCKS / UINT8_SIZE];
    // struct dir_entry *dir;
    struct dir_entry dir[MAX_FILE];
    struct inode inode;

};

struct file_descriptor {
    int is_used;
    int entry_index;
    int offset;
    char* name;
};









static struct file_descriptor fd[32];
static struct super_block* sup ;




void MapClear (uint16_t i){
    int x = i / UINT8_SIZE;
    int y = i % UINT8_SIZE;

    sup->bitmap [ x ] &= ~ (128 >> y);
}

void MapSet (uint16_t i){
    int x = i / UINT8_SIZE;
    int y = i % UINT8_SIZE;

    sup->bitmap [x] |= 128 >> y;
}

int make_fs(const char *disk_name){

    
    
    if (make_disk (disk_name) < 0){
        return -1;
    }

    if (open_disk (disk_name) < 0){
        return -1;
    }

    sup =  (struct super_block*) malloc (sizeof (struct super_block));
     

    for (int i = 0; i < 16; i++){
       
        sup->inode.direct_offset[i] = BLOCK_SIZE + 1;
    }

    for (int i = 0; i < 32; i++){
        
        fd[i].is_used = 0;
        fd[i].offset = 0;
        fd[i].name = (char*) malloc (sizeof(char*));
        fd[i].entry_index = BLOCK_SIZE + 1;

    }

    for (int i = 0; i < MAX_FILE; i++){
        sup -> dir[i] . is_used = 0;
        sup -> dir[i] . fname = (char*) malloc (sizeof(char*));
    }

    for (int i = 0; i < DISK_BLOCKS / UINT8_SIZE; i++){
        sup->bitmap[i] = 0;  //  0 -> not used
    }

    
    for (int i = 0; i < UINT8_SIZE; i++){
        MapSet(i);
    }

    sup -> inode . super_init = true;
    sup -> inode. single_indirect = BLOCK_SIZE + 1;
    sup -> inode . double_indirect = BLOCK_SIZE + 1;


    uint8_t* temp = (uint8_t*) malloc (BLOCK_SIZE);

    memcpy ((void*) temp, (void*) sup, sizeof (struct super_block));

    if (block_write (0, temp) < 0){
        return -1;
    }

    if (close_disk() < 0){
        return -1;
    }

    free (temp);
    return 0;






}
int mount_fs(const char *disk_name){
    if (open_disk (disk_name) < 0){
        return -1;
    }

   

    if (sup->inode.super_init != true){
        return -1;
    }

    uint8_t* temp = (uint8_t*) malloc (BLOCK_SIZE);

    if (block_read (0, temp) < 0){
        return -1;
    }

    memcpy ((void*) sup, (void*) temp, sizeof (struct super_block));

    free (temp);
    return 0;


}
int umount_fs(const char *disk_name){
   

 
    
    uint8_t* temp = (uint8_t*) malloc (BLOCK_SIZE);
    memcpy ((void*) temp, (void*) sup, sizeof (struct super_block));


    if (block_write (0, temp) < 0){
        return -1;
    }

    if (close_disk() < 0){
        return -1;
    }

    free (temp);

 
  
    return 0;

}

int fs_open(const char *name){
    bool find = false;
    int idx = 0;
    // empty space
    for (int i = 0; i < 32; i++){
        if (fd[i] .is_used == 0){
            idx = i;
            find = true;
            break;
        }
    }

    if (!find){
        return -1;
    }

    // find in dir
    find = false;
    int dir_idx = 0;
    int inode_idx = 0;
    for (int i = 0; i < MAX_FILE; i++){
        if (sup->dir[i].is_used && strcmp (name, sup->dir[i].fname) == 0){
            dir_idx = i;
            find =  true;
            break;
        }
    }

    if (!find){
        return -1;
    }

    bool opened = false;
    int opened_idx = 0;
    for (int i = 0; i < 32; i++){
        if (fd[i].is_used && strcmp (fd[i].name, name) == 0){
            opened = true;
            opened_idx = i;
            break;
        }
    }

    if (opened){
        fd[opened_idx].is_used = 0;
        fd[opened_idx].entry_index = BLOCK_SIZE + 1;
    }

    fd[idx]. is_used = 1;
    fd[idx] . entry_index = dir_idx;
    fd[idx].offset = 0;
    fd[idx].name = (char*) malloc (sizeof(char*));
    strcpy (fd[idx].name, name);

    // printf ("file name %s. fd name %s\n", name, fd[idx].name);
    return idx;

}
int fs_close(int fildes){

    if (fildes >= 32 || fildes < 0 || fd[fildes].is_used == 0){
        return -1;
    }
    fd[fildes] . is_used = 0;
    fd[fildes] . entry_index = BLOCK_SIZE + 1; // no data 

    return 0;

}
int fs_create(const char *name){
    
    int length = sizeof(name) / sizeof (name[0]);
    if (length > 16) {
        return -1;
    }

    bool find = false;
    for (int i = 0; i < MAX_FILE; i++){
        if (sup->dir[i].is_used && strcmp (sup->dir[i].fname, name) == 0){
            find = true;
            break;
        }
    }

    if (find){
        return -1;
    }

    bool space = false;
    int idx = 0;
    for (int i = 0; i < MAX_FILE; i++){
        if (sup->dir[i].is_used == 0){
            idx = i;
            space = true;
            break;
        }
    }

    if (!space){
        return -1;
    }


    sup->dir[idx].is_used = 1;

    sup->dir[idx].fname = (char*) malloc (sizeof (char*)); 
    
    strcpy (sup->dir[idx].fname, name);
    // printf ("file name %s. fd name %s\n", name, sup->dir[idx].fname);
    return 0;

}

int fs_delete(const char *name){

    // open or not
    bool find = false;
    for (int i = 0; i < 32; i++){
        if (fd[i].is_used && strcmp (fd[i].name, name) == 0){
            return -1;
        }
    }

    // exist or not
    int dir_idx = 0;
    for (int i = 0; i < 32; i++){
        if (sup->dir[i].is_used && strcmp (sup->dir[i].fname, name) == 0){
            find  = true;
            dir_idx = i;
            break;
        }
    }

    if (!find){
        return -1;
    }

    // find -> delete
    int size = 1 + sup -> dir[dir_idx] .f_size / BLOCK_SIZE;

    int inode_idx = sup -> dir[dir_idx]. inode_number;

    for (int i = sup->inode.direct_offset[inode_idx]; i < size; i++){
        MapClear(i);
    }

    sup -> dir[dir_idx] . is_used = 0;
    sup->inode . direct_offset [inode_idx] = BLOCK_SIZE + 1;
    sup -> dir[dir_idx].inode_number = BLOCK_SIZE + 1;

    return 0;
    
}

int fs_read(int fildes, void *buf, size_t nbyte){
     if (fildes >= 32 || fildes < 0 || fd[fildes].is_used == 0){
        return -1;
    }

    int dir_idx = 0;
    dir_idx = fd[fildes].entry_index;

    if (fd[fildes].offset == sup -> dir[dir_idx] . f_size){
        return 0;
    }

    
    return 0;

}
int fs_write(int fildes, void *buf, size_t nbyte){
    if (fildes >= 32 || fildes < 0 || fd[fildes].is_used == 0){
        return -1;
    }

    return 0;
}

int fs_get_filesize(int fildes){

    if (fildes >= 32 || fildes < 0 || fd[fildes].is_used == 0){
        return -1;
    }

    int idx = 0;
    idx = fd[fildes].entry_index;

    int result = sup -> dir[idx] . f_size;

    return result;
}
int fs_listfiles(char ***files){
    bool find = false;

    for (int i = 0; i < 32; i++){
        if (sup->dir[i].is_used){
            find = true;
            break;
        }
    }
    if (find){
        return -1;
    }

    int idx = 0;
    for (int i = 0; i < 32; i++){
        if (sup->dir[i].is_used){
            strcpy(*files[idx++], sup->dir[i].fname);
        }
    }

    files[idx] = NULL;

    return 0;
}

int fs_lseek(int fildes, off_t offset) {

    int idx = fd[fildes].entry_index;
    int file_size = sup->dir[idx].f_size;
    if(offset > file_size || offset < 0){
        return -1;
    }

    if (fildes >= 32 || fildes < 0 || fd[fildes].is_used == 0){
        return -1;
    }

    fd[fildes].offset = offset;
    
    return 0;
    
}

int fs_truncate(int fildes, off_t length){
    if (fildes >= 32 || fildes < 0 || fd[fildes].is_used == 0){
        return -1;
    }

    return 0;
}



/////////////////////////////////////////////////////////





