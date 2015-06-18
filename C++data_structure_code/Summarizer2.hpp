
#ifndef SUMMARIZER_HPP
#define SUMMARIZER_HPP

#include <string>
using namespace std;

typedef struct Node {
	std::string word;
	Node* next;
} Node;

typedef struct TreeNode {
    std::string word;
    TreeNode* left;
    TreeNode* right;
    int count;
} TreeNode;


class Summarizer2 {
private:
    Node* head;
    TreeNode * root;
    std::string firstword;
    std::string lastword;
    char mostcommonfirstletter;
    char mostcommonletter;
    int distinctword;
    std::string mostcommonword;
    int  mostcommonwordcount;
    int arrmostcommonletter[52];
    int arrmostcommonfirstletter[52];
    TreeNode * newTreeNode(std::string word);
    void setFirstWord();
    void setLastWord();
    void createBinarySearchTree(std::string word);
    void deallocateBST( TreeNode * n);
    
   
public:
    // Constructs a new, empty Summarizer.
    Summarizer2();
    // Deallocates memory for all the members in the class
    ~Summarizer2();
    // Adds a word to the collection in the Summarizer.
    void add(std::string word);
    
    // Returns the number of times the word "word" is found in the Summarizer.
    int occurrences(std::string word);
    
    // Returns the lexicographically first word in the Summarizer.
    std::string firstWord();
    
    // Returns the lexicographically last word in the Summarizer.
    std::string lastWord();
    
    // Returns a most commonly appearing first letter of a word in the Summarizer.
    char mostCommonFirstLetter();
    
    // Returns a most commonly appearing letter in the Summarizer.
    char mostCommonLetter();
    
    // Returns a most commonly appearing word in the Summarizer.
    std::string mostCommonWord();
    
    // Returns the number of distinct words
    int distinctWords();
    
};

#endif
