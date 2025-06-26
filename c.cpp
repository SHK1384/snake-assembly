#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <windows.h>
#include <conio.h>
#include <time.h>
extern "C"{
    void asmMain(void);
};
int main(void){
    try{
        //printf("running programm.\n");
        asmMain();
        //printf("terminated successfuly\n");
    }catch(...){
        printf("Error.\n");
    }
} 