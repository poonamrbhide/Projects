/*
 * file:        cs5600fs.h
 * description: Data structures for CS 5600 homework 4 file system.
 *
 * CS 5600, Computer Systems, Northeastern CCIS
 * Peter Desnoyers, updated November 2011
 * $Id: cs5600fs.h 454 2011-11-28 23:02:54Z pjd $
 */
#ifndef __CS5600FS_H__
#define __CS5600FS_H__

#define FS_BLOCK_SIZE 1024
#define CS5600FS_MAGIC 0x56005600

/* Entry in File Allocation Table.
 */
struct cs5600fs_entry {
    unsigned int inUse : 1;
    unsigned int eof   : 1;
    unsigned int next  : 30;
};

/* Entry in a directory
 */
struct cs5600fs_dirent {
    unsigned short valid : 1;
    unsigned short isDir : 1;
    unsigned short pad   : 6;
    unsigned short uid;
    unsigned short gid;
    unsigned short mode;
    unsigned int   mtime;
    unsigned int   start;
    unsigned int   length;
    char name[44];
};

/* Superblock - holds file system parameters. Note that this takes up
   only 80 bytes (4*4 + 64 for the root dirent) and the remaining 944
   bytes of the block are unused. 
 */
struct cs5600fs_super {
    unsigned int magic;
    unsigned int blk_size;
    unsigned int fs_size;
    unsigned int fat_len;
    struct cs5600fs_dirent root_dirent;
};

#endif


