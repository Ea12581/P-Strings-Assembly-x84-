#include "pstring.h"
#include "assert.h"
#include <stdio.h>
#include <string.h>

void testPstrlen(){
    Pstring p1 = {5,"aaaaa"};
    Pstring p2 = {6,"bbbbbb"};
    assert(pstrlen(&p1) == 5);
    assert(pstrlen(&p2) == 6);
    printf("Success pstrlen (1/5)\n");
}

void testReplaceChar(){
    Pstring p1 = {5,"aaaaa"};
    Pstring p2 = {6,"bbbbbb"};
    Pstring p3 = {6,"bcbcbc"};
    Pstring p4 = {0,""};
    assert(strcmp(replaceChar(&p1,'a','b')->str,"bbbbb") == 0);
    assert(strcmp(replaceChar(&p2,'a','b')->str,"bbbbbb") == 0);
    assert(strcmp(replaceChar(&p2,'b','@')->str,"@@@@@@") == 0);
    assert(strcmp(replaceChar(&p3,'c','a')->str,"bababa") == 0);
    assert(strcmp(replaceChar(&p3,'a',' ')->str,"b b b ") == 0);
    assert(strcmp(replaceChar(&p3,'b','r')->str,"r r r ") == 0);
    assert(strcmp(replaceChar(&p4,'b','r')->str,"") == 0);
    printf("Success eplaceChar (2/5)\n");
}






int main(){
testPstrlen();
    return 0;
}
