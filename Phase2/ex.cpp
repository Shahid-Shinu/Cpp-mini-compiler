#include <iostream>

using namespace std;

int main(){
    int a = 2,b=10;

    if(a < b){
        a = 1;
    }
    else{
        a = 2;
    }

    while(a < b){
        printf("%d\n",a);
        a = a+1;
        b = b-1;
    }
    a = 8;
}