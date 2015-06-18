
#include "Summarizer2.hpp"
#include <iostream>
using namespace std;
/*Checks in uppercase char*/
bool isUpper(char c)
{
    
    if((int)c>=65 && (int)c<=90)
        return true;
    return false;
}
/*Checks in lowercase char*/

bool isLower(char c)
{
    
    if((int)c>=97 && (int)c<=122)
        return true;
    return false;
}
/*Returns array index corresponding to character*/

int getArrayIndex(char c)
{
    if(isUpper(c))
        return ((int)c-65);
    if(isLower(c))
        return ((int)c-71);
    else return -999;
}
/*Returns character corresponding to array index*/

char getchfromIndex(int index)
{
    if(index<=25)
        return index+65;
    return index+71;
}
/*Constructor sets all values to default and sets BST/ Linked list to NULL i.e. Empty*/
Summarizer2::Summarizer2()
{
    head=NULL;
    root=NULL;
    firstword="";
    lastword="";
    distinctword=0;
    mostcommonword="";
    for (int i=0;i<52;i++)
    {
        arrmostcommonletter[i]=0;
        arrmostcommonfirstletter[i]=0;

    }
    mostcommonfirstletter=(char) 0;
    mostcommonletter=(char) 0;
}
/*Destructor : Deallocates each nodes memory*/
Summarizer2::~Summarizer2()
{
    deallocateBST(root);
}



/*This function adds a word to summarizer. For this Binary search tree is created with Word,it's count ,left and right children
The complexity of this function is O(logn) in avg case
The loops execute : (log n + log n + log n + constant time) times
This function actually determines / sets : lastword,mostcommonfirstletter,mostcommonletter, distinctword,mostcommonword,mostcommonwordcount; */

// Adds a word to the collection in the Summarizer.
void Summarizer2:: add(std::string word)
{

    if(word.length()>0)
    {
        int index=getArrayIndex(word.at(0));
        
        /*Update character count if it is valid for mostcommonFirstLetter*/
        if(index!=-999)
        {
            arrmostcommonfirstletter[index]=arrmostcommonfirstletter[index] +1;
        }
    }
    int flaginvalidcharacter=0;
    for (unsigned i=0; i< word.length() & flaginvalidcharacter==0 ; ++i)
    {
        int index=getArrayIndex(word.at(i));
        if(index==-999)
        {
            flaginvalidcharacter=1;
        }
    }
    /*Update character counts if they are valid for mostCommonLetter*/

    for (unsigned i=0; i< word.length() & flaginvalidcharacter==0 ; ++i)
    {
        int index=getArrayIndex(word.at(i));
        arrmostcommonletter[index]=arrmostcommonletter[index] +1;
        
    }
    if(flaginvalidcharacter==0)
    {
    createBinarySearchTree(word);
    //set first and last words for bst
    setFirstWord();
    setLastWord();
        
    int reqfindex=0,reqindex=0;
    int maxfletter=arrmostcommonfirstletter[0];
    int maxletter=arrmostcommonletter[0];
    for(int j=1;j<52;j++)
    {
        // Re-setting the most common first letter, if # of occurrences exceeds the current max
        if(arrmostcommonfirstletter[j]>maxfletter)
        {
            maxfletter=arrmostcommonfirstletter[j];
            reqfindex=j;
        }
         // Re-setting the most common letter, if # of occurrences exceeds the current max
        if(arrmostcommonletter[j]>maxletter)
        {
            maxletter=arrmostcommonletter[j];
            reqindex=j;
        }
    }
        // Converting the ints back into the character type
    mostcommonfirstletter=getchfromIndex(reqfindex);
    mostcommonletter=getchfromIndex(reqindex);
    }
    
}




/*Returns count for a particular word to be searched*/

int getCount(TreeNode * current, std::string searchword){
    // If word doesn't exist, return 0
    if(current==NULL)
        return 0;
    // If searchword = current word, then return the current count
    if(current->word.compare(searchword)==0)
        return current->count;
    
    // If searchword less than current word, then go left
    else if( searchword < current->word)
        return getCount(current->left, searchword);
    
    // Else, go right
    else  return getCount(current->right, searchword);
}

// Returns the number of times the word "word" is found in the Summarizer.
// This has complexity of log(n) in average case.
int Summarizer2:: occurrences(std::string searchword)
{
   // TreeNode * current=root;
    return getCount(root,searchword);
}

// Returns the lexicographically first word in the Summarizer.
std::string Summarizer2::firstWord()
{
    return firstword;
}

// Returns the lexicographically last word in the Summarizer.
std::string Summarizer2::lastWord()
{
    return lastword;
    
}

// Returns a most commonly appearing first letter of a word in the Summarizer.
char Summarizer2::mostCommonFirstLetter()
{
    return mostcommonfirstletter;
}

// Returns a most commonly appearing letter in the Summarizer.
char Summarizer2:: mostCommonLetter()
{
    return mostcommonletter;
}

// Returns number of distinct words
int Summarizer2:: distinctWords()
{
    return distinctword;
    
}
// Returns a most commonly appearing word in the Summarizer.
std::string  Summarizer2::mostCommonWord()
{
    // create a unique word list
    return mostcommonword;
}

// Destructor
// Deleting leaves as no other node is dependent on them.
void Summarizer2::deallocateBST( TreeNode * n)
{
    if( n == NULL )
        return;
    if( n->left != NULL )
        deallocateBST( n->left);
    if( n->right!= NULL )
        deallocateBST( n->right);
    delete n;
    return;
}
/*Creates new Tree node*/
TreeNode * Summarizer2:: newTreeNode(std::string word)
{
    TreeNode* newtreenode=new TreeNode;
    newtreenode->word=word;
    newtreenode->left=NULL;
    newtreenode->right=NULL;
    newtreenode->count=1;
    return newtreenode;
}
/*Sets first word by going leftmost in BST*/
void Summarizer2::setFirstWord()
{
    
    TreeNode * current=root;
    while(current->left!=NULL)
    {
        current=current->left;
    }
    
    firstword= current->word;
    
}
/*Sets last word by going rightmost in BST*/

void Summarizer2::setLastWord()
{
    TreeNode * current=root;
    while(current->right!=NULL)
    {
        current=current->right;
    }
    lastword= current->word;
}
/*Creates binary search tree , If the word already exists it updates it's count*/
void Summarizer2::createBinarySearchTree(std::string word)
{
    TreeNode * previous;
    int flag=0;
    /*Tree is null, create a root and assign values to relevant private variables*/
    if (root == NULL)
    {
        root=newTreeNode(word);
        distinctword++;
        firstword=word;
        lastword=word;
        mostcommonword=word;
        mostcommonwordcount=root->count;
    }
    else
    {
        TreeNode* current;
        current = root;
        // Find the Node's parent
        while(current!=NULL && flag==0)
        {
            previous = current;
            if(word > current->word)
                current = current->right;
            else if(word < current->word)
                current = current->left;
            //If the word is duplicate
            else
            {
                current->count=current->count+1;


                if(current->count>mostcommonwordcount)
                {
                    mostcommonwordcount= current->count;
                    mostcommonword= current->word;
                }
                else if(current->count==mostcommonwordcount &&  current->word<mostcommonword)
                {
                    mostcommonwordcount= current->count;
                    mostcommonword= current->word;
                    
                }
                flag=1;
            }
        }
        /* If the word is unique */
        if(flag==0)
        {
         
            TreeNode * newTNode=newTreeNode(word);
            /* Checking if there is a tie in number of occurrences */
            if(newTNode->count==mostcommonwordcount &&  newTNode->word<mostcommonword)
            {
                mostcommonwordcount= newTNode->count;
                mostcommonword= newTNode->word;
                
            }
            distinctword++;
            if(word < previous->word)
                previous->left = newTNode;
            else
                previous->right = newTNode;
        }
    }
    
};

