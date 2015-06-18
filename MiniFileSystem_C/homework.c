/*
 * file:        homework.c
 * description: skeleton file for CS 5600 homework 4
 *
 * CS 5600, Computer Systems, Northeastern CCIS
 * Peter Desnoyers, updated April 2012
 * $Id: homework.c 452 2011-11-28 22:25:31Z pjd $
 */

#define FUSE_USE_VERSION 27

#include <stdlib.h>
#include <stddef.h>
#include <unistd.h>
#include <fuse.h>
#include <fcntl.h>
#include <string.h>
#include <stdio.h>
#include <errno.h>

#include "cs5600fs.h"
#include "blkdev.h"
#define BLOCKSIZE 1024 
/* 
 * disk access - the global variable 'disk' points to a blkdev
 * structure which has been initialized to access the image file.
 *
 * NOTE - blkdev access is in terms of 512-byte SECTORS, while the
 * file system uses 1024-byte BLOCKS. Remember to multiply everything
 * by 2.
 */

extern struct blkdev *disk;
struct cs5600fs_super super;
struct cs5600fs_dirent root_dir;
struct cs5600fs_dirent current_dir;
struct cs5600fs_dirent parent_dir;
struct cs5600fs_entry *fat_pointer= NULL;
/* init - this is called once by the FUSE framework at startup.
 * This might be a good place to read in the super-block and set up
 * any global variables you need. You don't need to worry about the
 * argument or the return value.
 */
void* hw4_init(struct fuse_conn_info *conn) {
    int read_superblock, read_fat;
   // disk=image_create("disk1.img");  
    read_superblock = disk->ops->read(disk, 0, 2, (void*)&super);
    if (read_superblock != SUCCESS)
    {
        return NULL;
    }
    root_dir = super.root_dirent;
    fat_pointer=(struct cs5600fs_entry *)malloc(super.blk_size*super.fat_len);
    read_fat = disk->ops->read(disk, 2, super.fat_len * 2, (void*)fat_pointer);
    
    if (read_fat != SUCCESS)
    {
      //  printf("Could not read FAT table\n");
        return NULL;
    }
    return NULL;
}
int get_parent_path(const char * path,char *temp_path)
{
    int i;
    strcpy(temp_path, path);
    for (i = strlen(path) - 1; i >=0; i--) {
        if (path[i] == '/') {
            temp_path[i + 1] = '\0';
            break;
        }
    }
   return 0;
}

void get_last_token_path(const char * path,char *temp_path)
{
    int i;
    strcpy(temp_path, path);
    char *last_slash = (char *) malloc((strlen(path)*sizeof(char))+1);
    last_slash = strrchr(path, (int) '/');
    last_slash++;
    char dict_name[44];
    for (i = 0; i<strlen(last_slash); i++)
        dict_name[i] = last_slash[i];
    
    dict_name[i] = '\0';
    strcpy(temp_path, dict_name);
}

int hw4_path_translator(const char * path) {
    char *token = NULL;
    const char s[2] = "/";
    char *temp_path = (char *) malloc((strlen(path)*sizeof(char))+1);
    strcpy(temp_path, path);
    token = strtok((char *)temp_path, s);
    int flag = 0, i;
    struct cs5600fs_dirent directory[16];
    current_dir = root_dir;
    parent_dir = root_dir;
    while( token != NULL ) {
        if (current_dir.isDir != 1) 
        {
            free(temp_path);
            return -ENOTDIR;
        }
        
        parent_dir = current_dir;
        disk->ops->read(disk, current_dir.start * 2, 2, (void*) directory);
        flag = 0;       
        
        for (i=0; i<16; i++) {
            if (directory[i].valid && (strcmp(directory[i].name, token) == 0)) {
                current_dir = directory[i];
                flag = 1;
                break;
            }
        }
        if (!flag) {
            free(temp_path);
            return -ENOENT;
        }
    	token = strtok(NULL, s);
    }
   free(temp_path);
    return SUCCESS;
}

static void hw4_getattr_helper (struct stat *sb) {
    sb->st_dev = 0;
    sb->st_ino = 0;
    sb->st_rdev = 0;
    sb->st_blksize=0;
    sb->st_nlink = 1;
    sb->st_uid = current_dir.uid;
    sb->st_gid = current_dir.gid;
    sb->st_size = current_dir.length;
    sb->st_mtime = current_dir.mtime;
    sb->st_ctime = current_dir.mtime;
    sb->st_atime = current_dir.mtime;
    sb->st_mode = current_dir.mode | (current_dir.isDir? S_IFDIR : S_IFREG);
    if(current_dir.length%BLOCKSIZE != 0)
        sb->st_blocks = ((current_dir.length - 1)/BLOCKSIZE) + 1;
    else
        sb->st_blocks = 0;
}
/* Note on path translation errors:
 * In addition to the method-specific errors listed below, almost
 * every method can return one of the following errors if it fails to
 * locate a file or directory corresponding to a specified path.
 *
 * ENOENT - a component of the path is not present.
 * ENOTDIR - an intermediate component of the path (e.g. 'b' in
 *           /a/b/c) is not a directory
 */

/* getattr - get file or directory attributes. For a description of
 *  the fields in 'struct stat', see 'man lstat'.
 *
 * Note - fields not provided in CS5600fs are:
 *    st_nlink - always set to 1
 *    st_atime, st_ctime - set to same value as st_mtime
 *
 * errors - path translation, ENOENT
 */
 
static int hw4_getattr(const char *path, struct stat *sb) {
    int path_validate = hw4_path_translator(path);
    /* walk through other tokens */
    if (path_validate != SUCCESS)
        return path_validate;    

    hw4_getattr_helper(sb);
    return SUCCESS;
}   
    


/* readdir - get directory contents.
 *
 * for each entry in the directory, invoke the 'filler' function,
 * which is passed as a function pointer, as follows:
 *     filler(buf, <name>, <statbuf>, 0)
 * where <statbuf> is a struct stat, just like in getattr.
 *
 * Errors - path resolution, ENOTDIR, ENOENT
 */
static int hw4_readdir(const char *path, void *buf, fuse_fill_dir_t filler,
		       off_t offset, struct fuse_file_info *fi)
{
    char *name;
    struct stat sb;
    
    int path_validate = hw4_path_translator(path), i;
    /* walk through other tokens */
    if (path_validate != SUCCESS)
        return path_validate;
        
    if (current_dir.isDir != 1)
        return -ENOTDIR;
    
    struct cs5600fs_dirent directory[16];
    disk->ops->read(disk, current_dir.start*2, 2, (void*)directory);

    /* Example code - you have to iterate over all the files in a
     * directory and invoke the 'filler' function for each.
     */
    memset(&sb, 0, sizeof(sb));
    
    for (i=0; i<16; i++) {
        if (directory[i].valid) {
            current_dir = directory[i];
            name = current_dir.name;
            hw4_getattr_helper(&sb);
	        filler(buf, name, &sb, 0); /* invoke callback function */
	        }
    }
    return SUCCESS;
}
int find_free_fat_block() {
    int i = super.fat_len + 1, disk_write;
    for ( ; i<super.fat_len * 256; i++) {
        if (fat_pointer[i].inUse == 0) {
            fat_pointer[i].inUse = 1;
            disk_write = disk->ops->write(disk, 2, super.fat_len * 2, (void *) fat_pointer);
            
            if (disk_write != SUCCESS) {
                return disk_write;
            }
            return i;
        } 
    }
    return -1;
}
/* create - create a new file with permissions (mode & 01777)
 *
 * Errors - path resolution, EEXIST
 *
 * If a file or directory of this name already exists, return -EEXIST.
 */
static int hw4_create(const char *path, mode_t mode,
			 struct fuse_file_info *fi)
{
    char *temp_path = (char *) malloc((strlen(path)*sizeof(char))+1);
    strcpy(temp_path, path);
    int path_validate = hw4_path_translator(path), i;
    if (path_validate == SUCCESS) {
        return -EEXIST;
    }
    char *last_slash = (char *) malloc((strlen(path)*sizeof(char))+1);
    last_slash = strrchr(path, (int) '/');
    last_slash++;
    char file_name[44];
    
    for (i = 0; i<strlen(last_slash); i++)
        file_name[i] = last_slash[i];
    
    file_name[i] = '\0';
    
    for (i = strlen(path) - 1; i >=0; i--) {
        if (path[i] == '/') {
            temp_path[i + 1] = '\0';
            break;
        }
    }
    path_validate = hw4_path_translator(temp_path);
    
    if (path_validate != SUCCESS) {
        return -ENOENT;
    }
    
    if (current_dir.isDir != 1) {
        return -ENOTDIR;
    }
    
    struct cs5600fs_dirent directory[16];
    disk->ops->read(disk, current_dir.start*2, 2, (void*)directory);
    
    int free_fat_block = find_free_fat_block();    
    
    if (free_fat_block < 0) {
        return free_fat_block;
    }
    for (i=0; i<16; i++) {
        if (directory[i].valid == 0) {
            directory[i].valid = 1;
            directory[i].isDir = 0;
            directory[i].uid = getuid();
            directory[i].gid = getgid();
            directory[i].mode = mode;
            directory[i].mtime = time(NULL);
            directory[i].start = free_fat_block;
            directory[i].length = 0;
            strcpy(directory[i].name, file_name);
            break;
        }
    }
    
    int disk_write=disk->ops->write(disk, current_dir.start * 2, 2, (void*) directory);
    if( disk_write != SUCCESS)
    {
        return disk_write;
    }
    return SUCCESS;
}

/* mkdir - create a directory with the given mode.
 * Errors - path resolution, EEXIST
 * Conditions for EEXIST are the same as for create.
 */ 
static int hw4_mkdir(const char *path, mode_t mode)
{
    char *temp_path = (char *) malloc((strlen(path)*sizeof(char))+1);
    strcpy(temp_path, path);
    int path_validate = hw4_path_translator(path), i;
    if (path_validate == SUCCESS) {
        return -EEXIST;
    }
    char *last_slash = (char *) malloc((strlen(path)*sizeof(char))+1);
    last_slash = strrchr(path, (int) '/');
    last_slash++;
    char dict_name[44];
    
    for (i = 0; i<strlen(last_slash); i++)
        dict_name[i] = last_slash[i];
    
    dict_name[i] = '\0';
    
    for (i = strlen(path) - 1; i >=0; i--) {
        if (path[i] == '/') {
            temp_path[i + 1] = '\0';
            break;
        }
    }
    
    path_validate = hw4_path_translator(temp_path);
    if (path_validate != SUCCESS) {
        return -ENOENT;
    }
    
    if (current_dir.isDir != 1) {
        return -ENOTDIR;
    }
    
    struct cs5600fs_dirent directory[16];
    disk->ops->read(disk, current_dir.start*2, 2, (void*)directory);
    
    int free_fat_block = find_free_fat_block();    
    
    if (free_fat_block < 0) {
        return free_fat_block;
    }
    for (i=0; i<16; i++) {
        if (directory[i].valid == 0) {
            directory[i].valid = 1;
            directory[i].isDir = 1;
            directory[i].uid = 0;
            directory[i].gid = 0;
            directory[i].mode = mode;
            directory[i].mtime = time(NULL);
            directory[i].start = free_fat_block;
            directory[i].length = 0;
            strcpy(directory[i].name, dict_name);
            break;
        }
    }
    
    int disk_write=disk->ops->write(disk, current_dir.start * 2, 2, (void*) directory);
    if( disk_write != SUCCESS)
    {
        return disk_write;
    }
    return SUCCESS;
}

/* unlink - delete a file
 *  Errors - path resolution, ENOENT, EISDIR
 */
static int hw4_unlink(const char *path)
{
    int path_validate = hw4_path_translator(path),i,flag,disk_read,disk_write;
    if(path_validate != SUCCESS)
    {
        return path_validate;
    }
    
    if (current_dir.isDir == 1) {
        return -EISDIR;
    }
    
    int block_num = current_dir.start;
    do{
        fat_pointer[block_num].inUse = 0;
        block_num = fat_pointer[block_num].next;
    }while (fat_pointer[block_num].eof != 1);
    
    disk_write = disk->ops->write(disk, 2, super.fat_len * 2, (void *) fat_pointer);
            
    if (disk_write != SUCCESS) {
        return disk_write;
    }
    struct cs5600fs_dirent directory[16];
    
    disk_read=disk->ops->read(disk, parent_dir.start * 2, 2, (void*) directory);
    if(disk_read != SUCCESS)
    {
        return disk_read;
    }
    flag = 0;
    for (i=0; i<16; i++) {
        if (directory[i].valid && strcmp(directory[i].name, current_dir.name) == 0) {
            directory[i].valid = 0;
            flag = 1;
            break;
        }
     }  
     if(flag == 0)
     {
        return -ENOENT;
     }
    
    disk_write=disk->ops->write(disk, parent_dir.start * 2, 2, (void*) directory);
    if( disk_write != SUCCESS)
    {
        return disk_write;
    }
    return SUCCESS;    

}

/* rmdir - remove a directory
 *  Errors - path resolution, ENOENT, ENOTDIR, ENOTEMPTY
 */
static int hw4_rmdir(const char *path)
{
   int path_validate = hw4_path_translator(path),i,flag,disk_read,disk_write;
    if(path_validate != SUCCESS)
    {
        return path_validate;
    }
    
    if (current_dir.isDir == 0) {
        return -ENOTDIR;
    }
    /*Check for directory empty*/
    struct cs5600fs_dirent directory_empty_check[16];
    
    disk_read=disk->ops->read(disk, current_dir.start * 2, 2, (void*) directory_empty_check);
    if(disk_read != SUCCESS)
    {
        return disk_read;
    }

    for (i=0; i<16; i++) {
        if (directory_empty_check[i].valid) {
            return -ENOTEMPTY;
        }
     }
    
    int block_num = current_dir.start;  
    fat_pointer[block_num].inUse = 0;
    disk_write = disk->ops->write(disk, 2, super.fat_len * 2, (void *) fat_pointer);
            
    if (disk_write != SUCCESS) {
        return disk_write;
    }
    
    struct cs5600fs_dirent directory[16];
    
    disk_read=disk->ops->read(disk, parent_dir.start * 2, 2, (void*) directory);
    if(disk_read != SUCCESS)
    {
        return disk_read;
    }
    flag = 0;
    for (i=0; i<16; i++) {
        if (directory[i].valid && strcmp(directory[i].name, current_dir.name) == 0) {
            directory[i].valid = 0;
            flag = 1;
            break;
        }
     }
     
     if(flag == 0)
     {
        return -ENOENT;
     }
    
    disk_write=disk->ops->write(disk, parent_dir.start * 2, 2, (void*) directory);
    if( disk_write != SUCCESS)
    {
        return disk_write;
    }
    return SUCCESS;    
}

/* rename - rename a file or directory
 * Errors - path resolution, ENOENT, EINVAL, EEXIST
 *
 * ENOENT - source does not exist
 * EEXIST - destination already exists
 * EINVAL - source and destination are not in the same directory
 *
 * Note that this is a simplified version of the UNIX rename
 * functionality - see 'man 2 rename' for full semantics. In
 * particular, the full version can move across directories, replace a
 * destination file, and replace an empty directory with a full one.
 */
static int hw4_rename(const char *src_path, const char *dst_path)
{
    int path_validate ,i,flag,disk_read,disk_write;
    path_validate = hw4_path_translator(dst_path);
    if(path_validate == SUCCESS)
    {
        return -EEXIST;
    }
    path_validate= hw4_path_translator(src_path);
    if(path_validate != SUCCESS)
    {
       // printf("Source does not exist\n");
        return -ENOENT;
    }
    char * src_base_path = (char *) malloc((strlen(src_path)*sizeof(char))+1);
    char * src_dst_path = (char *) malloc((strlen(dst_path)*sizeof(char))+1);
    char * new_name = (char *) malloc(44*sizeof(char));
    get_parent_path(src_path, src_base_path);
    get_parent_path(dst_path, src_dst_path);
    if(strcmp(src_base_path, src_dst_path) != 0)
    {
      //  printf("Source and destination are not in the same directory");
        return -EINVAL;
    }
  
    get_last_token_path(dst_path, new_name);
    struct cs5600fs_dirent directory[16]; 
    disk_read=disk->ops->read(disk, parent_dir.start * 2, 2, (void*) directory);
    if(disk_read != SUCCESS)
    {
      //  printf("Error in disk reading");
        return disk_read;
    }
    flag = 0;
    for (i=0; i<16; i++) {
        //printf("Directory name = %s, curr_dir name = %s", directory[i].name, current_dir.name);
        if (directory[i].valid && strcmp(directory[i].name, current_dir.name) == 0) {
            strcpy(directory[i].name,new_name);
            flag = 1;
            break;
        }
     }
     
     if(flag == 0)
     {
      //  printf("Directory/File %s not present\n", current_dir.name);
        return -ENOENT;
     }
    
    disk_write=disk->ops->write(disk, parent_dir.start * 2, 2, (void*) directory);
    if( disk_write != SUCCESS)
    {
     //   printf("Error in disk writing");
        return disk_write;
    }
    return SUCCESS;
}

/* chmod - change file permissions
 * utime - change access and modification times
 *         (for definition of 'struct utimebuf', see 'man utime')
 *
 * Errors - path resolution, ENOENT.
 */
static int hw4_chmod(const char *path, mode_t mode)
{
   // printf("Path = %s\n", path);
    int path_validate = hw4_path_translator(path), disk_read, disk_write, flag=0, i;
    struct cs5600fs_dirent directory[16];
    if(path_validate != SUCCESS)
    {
        //printf("No such file or directory");
        return -ENOENT;
    }
    
   // printf("Parent name = %s, curr_dir name = %s", parent_dir.name, current_dir.name);
    
    disk_read=disk->ops->read(disk, parent_dir.start * 2, 2, (void*) directory);
    if(disk_read != SUCCESS)
    {
       // printf("Error in disk reading");
        return disk_read;
    }
    flag = 0;
    for (i=0; i<16; i++) {
        //printf("Directory name = %s, curr_dir name = %s", directory[i].name, current_dir.name);
        if (directory[i].valid && strcmp(directory[i].name, current_dir.name) == 0) {
            directory[i].mode = mode;
            flag = 1;
            break;
        }
     }
     
     if(flag == 0)
     {
       // printf("Directory/File %s not present\n", current_dir.name);
        return -ENOENT;
     }
    
    disk_write=disk->ops->write(disk, parent_dir.start * 2, 2, (void*) directory);
    if( disk_write != SUCCESS)
    {
       // printf("Error in disk writing");
        return disk_write;
    }
    return SUCCESS;
}

int hw4_utime(const char *path, struct utimbuf *ut)
{
   int path_validate = hw4_path_translator(path), disk_read, disk_write, flag=0, i;
    struct cs5600fs_dirent directory[16];
    if(path_validate != SUCCESS)
    {
       // printf("No such file or directory");
        return -ENOENT;
    }
    
    disk_read=disk->ops->read(disk, parent_dir.start * 2, 2, (void*) directory);
    if(disk_read != SUCCESS)
    {
       // printf("Error in disk reading");
        return disk_read;
    }
    flag = 0;
    for (i=0; i<16; i++) {
        if (directory[i].valid && strcmp(directory[i].name, current_dir.name) == 0) {
            if (ut == NULL)
                directory[i].mtime = time(NULL);
            else
                directory[i].mtime = ut->modtime;
            flag = 1;
            break;
        }
     }
     if(!flag)
     {
       // printf("Directory/File %s not present\n", current_dir.name);
        return -ENOENT;
     }
    
    disk_write=disk->ops->write(disk, parent_dir.start * 2, 2, (void*) directory);
    if( disk_write != SUCCESS)
    {
     //   printf("Error in disk writing");
        return disk_write;
    }
    return SUCCESS;
}

/* truncate - truncate file to exactly 'len' bytes
 * Errors - path resolution, ENOENT, EISDIR, EINVAL
 *    return EINVAL if len > 0.
 */
static int hw4_truncate(const char *path, off_t len)
{
    /* you can cheat by only implementing this for the case of len==0,
     * and an error otherwise.
     */
    if (len != 0)
	    return -EINVAL;		/* invalid argument */
    
    int path_validate = hw4_path_translator(path), i, flag, disk_read, disk_write;
    if(path_validate != SUCCESS)
    {
      //  printf("File not present to delete\n");
        return path_validate;
    }
    
    if (current_dir.isDir == 1) {
       // printf("Given path is not a file\n");
        return -EISDIR;
    }
    
    int block_num = current_dir.start;
    if (fat_pointer[block_num].eof != 1) {
        fat_pointer[block_num].eof = 1;
        do{
            block_num = fat_pointer[block_num].next;
            fat_pointer[block_num].inUse = 0;
        }while (fat_pointer[block_num].eof != 1);
    }
        
    disk_write = disk->ops->write(disk, 2, super.fat_len * 2, (void *) fat_pointer);
    if (disk_write != SUCCESS) {
       // printf("Error in allocating fat block\n");
        return disk_write;
    }
    struct cs5600fs_dirent directory[16];
    
    disk_read=disk->ops->read(disk, parent_dir.start * 2, 2, (void*) directory);
    if(disk_read != SUCCESS)
    {
        //printf("Error in disk reading");
        return disk_read;
    }
    flag = 0;
    for (i=0; i<16; i++) {
        //printf("Directory name = %s, curr_dir name = %s", directory[i].name, current_dir.name);
        if (directory[i].valid && strcmp(directory[i].name, current_dir.name) == 0) {
            directory[i].length = 0;
            flag = 1;
            break;
        }
     }  
     if(flag == 0)
     {
       // printf("Directory/File %s not present\n", current_dir.name);
        return -ENOENT;
     }
    
    disk_write=disk->ops->write(disk, parent_dir.start * 2, 2, (void*) directory);
    if( disk_write != SUCCESS)
    {
        //printf("Error in disk writing");
        return disk_write;
    }
    return SUCCESS;
    
    //return -EOPNOTSUPP;
}

/* read - read data from an open file.
 * should return exactly the number of bytes requested, except:
 *   - if offset >= len, return 0
 *   - on error, return <0
 * Errors - path resolution, ENOENT, EISDIR
 */
static int hw4_read(const char *path, char *buf, size_t len, off_t offset,
		    struct fuse_file_info *fi)
{
    int path_validate = hw4_path_translator(path);
    char * temp_buf = (char *) malloc(1024*sizeof(char));
    struct cs5600fs_entry *current_block = NULL;
    if (path_validate != SUCCESS)
        return path_validate;    
    
    /*If current is dir then return EISDIR*/
    /*If cu */
    if (current_dir.isDir == 1) {
       // printf("Trying to perform read operation on directory\n");
        return -EISDIR;
    }
    //printf("Inside Read\n");
    int block_num = current_dir.start;
    int file_length = current_dir.length;
    int bytes_read = 0;
    int possible_byte_read = len;
    int i;
    
    current_block = (struct cs5600fs_entry *) malloc(sizeof(struct cs5600fs_entry));
   /* if (offset >= file_length) {
        printf("Offset is greater than file length\n");
        return 0;
    }*/

    if (offset + len > file_length)
        possible_byte_read = file_length - offset;
    
    while (offset >= super.blk_size) {
        current_block = &fat_pointer[block_num];
        if ( current_block->inUse != 1) {
	//  printf("Current block not in use\n");
            return 0;
        }
        block_num = current_block->next;
        offset = offset - super.blk_size;
    }
    
    int disk_read = 0, start = 0, end = 1024;
    while (possible_byte_read != bytes_read) {
        current_block = &fat_pointer[block_num];
        start = 0;
        end = 1024;
        if ( current_block->inUse != 1) {
	//    printf("Current block not in use:%d\n", block_num);
            return 0;
        }

        disk_read = disk->ops->read(disk, block_num*2, 2, temp_buf);
        if (disk_read != SUCCESS) {
	   // printf("Disk read failed\n");
            return disk_read;
	}
        if (offset != 0) {
            start = offset;
            offset = 0;
        }
        if (possible_byte_read - bytes_read < end - start)
            end = start + possible_byte_read - bytes_read;
        for (i = start; i< end; i++)
            buf[bytes_read++] = temp_buf[i];
            
        block_num = current_block->next;
    }
    //buf[bytes_read] = '\0';
   // printf("bytes read = %d", bytes_read);
    return bytes_read;
    
    //return -EOPNOTSUPP;
}

/* write - write data to a file
 * It should return exactly the number of bytes requested, except on
 * error.
 * Errors - path resolution, ENOENT, EISDIR
 *  return EINVAL if 'offset' is greater than current file length.
 */
static int hw4_write(const char *path, const char *buf, size_t len,
		     off_t offset, struct fuse_file_info *fi)
{
    int path_validate = hw4_path_translator(path);
    char * temp_buf = (char *) malloc(1024*sizeof(char));
    struct cs5600fs_entry *current_block = NULL;
    if (path_validate != SUCCESS)
        return path_validate;    
  //  printf("Offset : %d",offset);
    
    /*If current is dir then return EISDIR*/
    /*If cu */
    if (current_dir.isDir == 1) {
        return -EISDIR;
    }
    int block_num = current_dir.start;
    int file_length = current_dir.length;
    int bytes_written = 0;
    int bytes_to_write = len;
    int i;
    int length_exceeded = 0;
    if (current_dir.length < offset + len)
        length_exceeded = offset + len;
        
    if (offset > file_length) {
        //printf("Offset is greater than file length\n");
        return -EINVAL;
    }
    
    current_block = (struct cs5600fs_entry *) malloc(sizeof(struct cs5600fs_entry));
    
    while (offset >= super.blk_size) {
        current_block = &fat_pointer[block_num];
        if ( current_block->inUse != 1) {
	      //  printf("Current block not in use\n");
            return 0;
        }
        block_num = current_block->next;
        offset = offset - super.blk_size;
    }
    
    int disk_read = 0, start = 0, end = 1024, disk_write;
    while (bytes_to_write != bytes_written) {
        current_block = &fat_pointer[block_num];
        start = 0;
        end = 1024;
        if ( current_block->inUse != 1) {
	     //   printf("Current block not in use:%d\n", block_num);
            return 0;
        }

        disk_read = disk->ops->read(disk, block_num*2, 2, temp_buf);
        if (disk_read != SUCCESS) {
	      //  printf("Disk read failed\n");
            return disk_read;
	    }
        if (offset != 0) {
            start = offset;
            offset = 0;
        }
        
        if (bytes_to_write - bytes_written < end - start)
            end = start + bytes_to_write - bytes_written;
        for (i = start; i< end; i++)
            temp_buf[i] = buf[bytes_written++];
        
        disk_write = disk->ops->write(disk, block_num*2, 2, temp_buf);            
        if (current_block->eof == 1){
            current_block->eof = 0;
            break;
        }
        block_num = current_block->next;        
    }
    int free_fat_block;
    
    while (bytes_to_write != bytes_written) {
        free_fat_block = find_free_fat_block();
        current_block->next = free_fat_block;
        
        current_block = &fat_pointer[free_fat_block];
        current_block->eof = 0;
        start = 0;
        end = 1024;
        
        disk_read = disk->ops->read(disk, block_num*2, 2, temp_buf);
        if (disk_read != SUCCESS) {
	       // printf("Disk read failed\n");
            return disk_read;
	    }
	    
        if (bytes_to_write - bytes_written < end - start)
            end = start + bytes_to_write - bytes_written;
        for (i = start; i< end; i++)
            temp_buf[i] = buf[bytes_written++];
        
        disk_write = disk->ops->write(disk, block_num*2, 2, temp_buf);
    }
    current_block->eof = 1;
    disk_write = disk->ops->write(disk, 2, super.fat_len * 2, (void *) fat_pointer);
    
          
    if (length_exceeded != 0) {
        struct cs5600fs_dirent directory[16];
        disk_read=disk->ops->read(disk, parent_dir.start * 2, 2, (void*) directory);
        if(disk_read != SUCCESS)
        {
           // printf("Error in disk reading");
            return disk_read;
        }
        
        int flag = 0;
        for (i=0; i<16; i++) {
            //printf("Directory name = %s, curr_dir name = %s", directory[i].name, current_dir.name);
            if (directory[i].valid && strcmp(directory[i].name, current_dir.name) == 0) {
                directory[i].length = length_exceeded;
                flag = 1;
                break;
            }
         }
         
         if(flag == 0)
         {
          //  printf("Directory/File %s not present\n", current_dir.name);
            return -ENOENT;
         }
        
        disk_write=disk->ops->write(disk, parent_dir.start * 2, 2, (void*) directory);
        if( disk_write != SUCCESS)
        {
          //  printf("Error in disk writing");
            return disk_write;
        }
    }

    return bytes_written;
    
    //return -EOPNOTSUPP;
}

/* statfs - get file system statistics
 * see 'man 2 statfs' for description of 'struct statvfs'.
 * Errors - none. Needs to work.
 */
static int hw4_statfs(const char *path, struct statvfs *st)
{
    /* needs to return the following fields (set others to zero):
     *   f_bsize = BLOCK_SIZE
     *   f_blocks = total image - (superblock + FAT)
     *   f_bfree = f_blocks - blocks used
     *   f_bavail = f_bfree
     *   f_namelen = <whatever your max namelength is>
     *
     * it's OK to calculate this dynamically on the rare occasions
     * when this function is called.
     */
    int total_blocks;
    st->f_bsize =super.blk_size;
    total_blocks=disk->ops->num_blocks(disk);
    st->f_blocks=total_blocks-(super.fat_len+1);
    st->f_bfree=  st->f_blocks-super.fs_size;
    st->f_bavail=st->f_bfree;
    st->f_namemax=43;  
    return SUCCESS;
}

/* operations vector. Please don't rename it, as the skeleton code in
 * misc.c assumes it is named 'hw4_ops'.
 */
struct fuse_operations hw4_ops = {
    .init = hw4_init,
    .getattr = hw4_getattr,
    .readdir = hw4_readdir,
    .create = hw4_create,
    .mkdir = hw4_mkdir,
    .unlink = hw4_unlink,
    .rmdir = hw4_rmdir,
    .rename = hw4_rename,
    .chmod = hw4_chmod,
    .utime = hw4_utime,
    .truncate = hw4_truncate,
    .read = hw4_read,
    .write = hw4_write,
    .statfs = hw4_statfs,
};

