#ifndef SORT_H
#define SORT_H

#include <stdlib.h>
#include <stack>
#include <iostream>

using namespace std;

static int swapCount = 0;

void swap(int* a, int* b)
{
    //swapCount++;
    int temp;
    temp = *a; 
    *a = *b; 
    *b = temp; 
}

void merge(int a[], int a_temp[], int l, int m, int r){

        int x; 
        x = m - l + 1;
        int y; 
        y = r - m;

        int L[x];
        int R[y];

        for (int i = 0; i < x; i++){
          L[i] = a[ l + i];
        
        }

        for ( int i = 0; i < y; i++){
          R[i] = a[m + 1 + i];
        }

        int i = 0, j = 0, k = l;

        while ((i < x) && (j < y)){

          if (L[i] <= R[j]){
            a[k] = L[i];
            i++;
            

          }else {
            a[k] = R[j];
            j++;
          }
          
         k++;

        }

        while (i < x){
          a[k++] = L[i++];
        }

        while (j < y){
          a[k++] = R[j++];

        }
/*
        for (int i = l; i < r; i++){
          a[i] = a_temp[i];
        }
*/

}

/* See Knuth's shuffles https://en.wikipedia.org/wiki/Random_permutation */



void insertionsort(int a[],  int n)
{ 
// You program this
  int j = 0, trav = 0;
  for (int i = 1; i < n; i++){
    trav = a[i];
    j = i;
    while ((j > 0) && (a[j-1] > trav)){
      a[j] = a[j-1];
      j--;

    }

    a[j] = trav;
}

}



// Order Theta(NlogN) sorting

void mergeSort(int a[], int a_tmp[], int l, int r)
{
    // you program this.  a_tmp can be used for merging 

    



   

      if (l < r){
        int middle = l + ( r - l) / 2;
        mergeSort (a, a_tmp, l, middle);
        mergeSort (a, a_tmp, middle + 1, r);
        merge(a, a_tmp, l, middle, r);

      }
    

    

    



}

void mergeSortblend(int a[], int a_tmp[], int l, int r)
{
 // You program this

  if ((r - l + 1) <= 32){

      insertionsort (a, (r-l+1));
      return;

    } else {

   

      if (l < r){
        int middle = l + ( r - l) / 2;
        mergeSort (a, a_tmp, l, middle);
        mergeSort (a, a_tmp, middle + 1, r);
        merge(a, a_tmp, l, middle, r);

      }
    }

}





// 


void checkInorder(int a[],int left, int right){
  //checks  that a is in order from left to right
  for (int i = left;i <right; i++){
    if (a[i] > a[i+1]){
      int tmp = i;
    }
  }
}

void simpleTimsort(int a[], int a_tmp[], int n)
{ 
   //You program this
stack <int> index; index.push(0);

bool ascending = true;
int count = 1;

for (int i = 1; i < n; i++){




  
  if ((a[i] < a[i-1]) && ( (i + 1 ) % 32 != 1)){
    int trav = a[i];
    int j = i;
    while ((j > index.top() + 1) && (a[j-1] > trav)){
      a[j] = a[j-1];
      j--;

    }

    a[j] = trav;

  }

    if ((i + 1) % 32 == 0){
    index.push(i);
    
  }    

}


int r = n - 1;
int tmp;
int l;
int m;
m = index.top();
index.pop();
while (!index.empty()){
  
  if (index.size() == 1){
    l = 0;
  }else {
  l = index.top() + 1;
  tmp = l - 1;
  }


  merge(a,a_tmp, l,m,r);

  m = tmp;
  index.pop();

}
  




}// end function





#endif 
