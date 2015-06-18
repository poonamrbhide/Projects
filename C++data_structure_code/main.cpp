

#include <iostream>
#include "Summarizer2.hpp"
#include<assert.h>

using namespace std;
int main()
{
    Summarizer2 s;
    s.add("abc");
    
    // Testing implementation of the occurrences function
    
    assert(s.occurrences("abc")==1);
    assert(s.occurrences("pqr")==0);
    
    s.add("pqr");
    s.add("pqr");
    s.add("pqr");
    s.add("Th");
    s.add("pqr");
    s.add("pqr;");

    assert(s.occurrences("pqr;")==0);
    assert(s.distinctWords()==3);

    // Testing implementation of the occurrences function
    assert(s.occurrences("PQR")==0);
    assert(s.occurrences("pqr")==4);
    assert(s.occurrences("abc") ==1);
    assert(s.occurrences("ABC") ==0);
    assert(s.occurrences("abC") ==0);
    s.add("pqrst");
    s.add("pqrstsss");
    s.add("ab");
    
    s.add("AB");
    
    // Testing implementation of the first word function
    assert(s.firstWord().compare("AB")==0);
    
    // Testing implementation of the last word function
    assert(s.lastWord().compare("pqrstsss")==0);
    s.add("a");
    s.add("Q");
    assert(s.firstWord().compare("AB")==0);
    s.add("Q");
    s.add("A");
    assert(s.firstWord().compare("A")==0);
    
    // Testing implementation of the most common word function
    assert(s.mostCommonWord().compare("pqr")==0);
    s.add("ssss");
    
    // Testing implementation of the most common letter function
    assert((int) s.mostCommonLetter()=='s');
    s.add("pppppppppppppppppp");
    assert((int) s.mostCommonLetter()=='p');
    
    // Testing implementation of the most common first letter
    assert((int) s.mostCommonFirstLetter()=='p');
    assert((int) s.mostCommonFirstLetter()=='p');
    assert(s.mostCommonWord().compare("pqr")==0);
    s.add("z");
    assert(s.lastWord().compare("z")==0);
    
    std::cout << "Tests completed." << std::endl;
    return 0;
}
