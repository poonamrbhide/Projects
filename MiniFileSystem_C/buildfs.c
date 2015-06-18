/*
 * file:        buildfs.c
 * description: create a HEFT file system image
 *
 * CSG 112 - Computer Architecture - Fall 2008
 * Peter Desnoyers
 * Northeastern University Computer & Information Science
 *
 * $Id: buildfs.c 154 2010-04-09 17:47:03Z pjd $
 */

#define _XOPEN_SOURCE 500
#define _BSD_SOURCE

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>

#include <unistd.h>
#include <fcntl.h>

#include <assert.h>

#include "cs5600fs.h"


int write_block(int fd, int lba, void *buf)
{
    return pwrite(fd, buf, FS_BLOCK_SIZE, lba*FS_BLOCK_SIZE);
}

int read_block(int fd, int lba, void *buf)
{
    return pread(fd, buf, FS_BLOCK_SIZE, lba*FS_BLOCK_SIZE);
}

#define S_SUPER 4
#define S_FAT 1
#define S_DIR 2
#define S_FILE 3

const int dir_entries_per_block = (FS_BLOCK_SIZE /
				   sizeof(struct cs5600fs_dirent));
const int fat_entries_per_block = (FS_BLOCK_SIZE /
				   sizeof(struct cs5600fs_entry));

struct cs5600fs_super super;

int main(int argc, char **argv)
{
    char *path = argv[1];

    printf("buildfs: %d dirents/dir, %d fats/block\n",
	   dir_entries_per_block, fat_entries_per_block);
    if (argc < 2)
	exit(1);
    
    int fd = open(path, O_WRONLY|O_CREAT, 0777);
    if (fd < 0)
	perror("error: open"), exit(1);

    void *buf = calloc(FS_BLOCK_SIZE, 1);

    char line[128], *args[10];
    int state = 0, i, blk_num;
    FILE *fp = stdin;
    if (argc > 2)
	fp = fopen(argv[2], "r");

    struct cs5600fs_dirent *dir = buf;
    struct cs5600fs_entry  *fat = buf;
    
    while (fgets(line, sizeof(line), fp) != NULL) {
	char *tmp = line;
	int end = (strchr(line, ';') != NULL);

	if (line[0] == '#')
	    continue;

	//printf("%s", line);
	
	for (i = 0; (args[i] = strsep(&tmp, "; \t\n")) != NULL;)
	    if (strlen(args[i]) > 0) /* skip empty elements */
		if (++i >= 10)
		    break;

	int nargs = i;
	if (nargs == 0)
	    goto skip;
	
	if (state == 0) {
	    memset(buf, 0, FS_BLOCK_SIZE);
	    if (!strcmp(args[0], "super")) {
		state = S_SUPER;
		memset(&super, 0, sizeof(super));
	    }
	    else if (!strcmp(args[0], "fat")) {
		state = S_FAT;
		for (i = 0; i < fat_entries_per_block; i++)
		    fat[i].inUse = 0;
		for (i = 0; i <= super.root_dirent.start; i++)
		    fat[i].inUse = fat[i].eof = 1;
	    }
	    else if (!strcmp(args[0], "dir")) {
		state = S_DIR;
		for (i = 0; i < dir_entries_per_block; i++)
		    dir[i].valid = 0;
	    }
	    else if (!strcmp(args[0], "file"))
		state = S_FILE;
	    else
		printf("bad cmd: %s\n", args[0]), exit(1);
	    
	    blk_num = atoi(args[1]);
	}
	else if (state == S_SUPER) {
	    super.magic = CS5600FS_MAGIC;
	    super.blk_size = FS_BLOCK_SIZE;
	    
	    if (!strcmp(args[0], "nblocks")) {
		int i, len = strtol(args[1], NULL, 0);
		super.fs_size = len;
		super.fat_len = ((len+fat_entries_per_block-1)/
				       fat_entries_per_block);
		struct cs5600fs_dirent *de = &super.root_dirent;
		de->valid = 1;
		de->isDir = 1;
		de->mode = 0777;
		de->start = super.fat_len+1;

		/* create the disk image first
		 */
		for (i = 0; i < len; i++) 
		    write_block(fd, i, buf);
		memcpy(buf, &super, sizeof(super));
	    }
	    else
		printf("bad cmd: %s\n", args[0]), exit(1);
	}
	else if (state == S_FAT) {
	    int a = atoi(args[0]) % fat_entries_per_block;
	    int b = atoi(args[1]);
	    int eof = (nargs > 2 && !strcmp(args[2], "eof"));
	    fat[a].next = b;
	    fat[a].eof = eof;
	    fat[a].inUse = 1;
	}
	else if (state == S_DIR) {
	    int j = atoi(args[0]);
	    assert(j >= 0 && j < dir_entries_per_block);
	    dir[j].valid = 1;
	    dir[j].isDir = (args[1][0] == 'd');
	    dir[j].mode = 0777;
	    strcpy(dir[j].name, args[2]);
	    dir[j].start = atoi(args[3]);
	    dir[j].length = atoi(args[4]);
	}
	else if (state == S_FILE) { /* file block# */
	    int fd2 = open(args[0], O_RDONLY);
	    read_block(fd2, atoi(args[1]), buf);
	    close(fd2);
	}
	
    skip:
	if (end) {
	    write_block(fd, blk_num, buf);
	    state = 0;
	}
    }

    close(fd);
    return 0;
}
