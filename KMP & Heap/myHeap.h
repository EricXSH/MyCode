#ifndef BINARY_HEAP_H_
#define BINARY_HEAP_H_

using namespace std;

const int MAX_SIZE = 100000; //the maximum amount of elements our heap should have.

template <typename Object>
class Heap
{
public:
   Heap(){
      elements = 0;
   };
   void insert(Object* item){// Add the object pointer item to the heap
	   if (elements >= MAX_SIZE){
		   cout << "Heap is full; can't insert "<< endl;
      // FILL IN THE REST

			return;
	   }

      
      int index = elements;
      array[index] = item;
      item->position = index;
      

      
      
      upHeap (elements);
      elements++;

     



   };  	

   Object* remove_min(){
      if (elements == 0){
		   cout << "empty heap error, can't delete"<<endl;
	   }
      Object* temp = array[0];
      // FILL IN THE REST



      array[0] = array[--elements ];
    
      
     
      downHeap(0);
     


      return temp;
   };       // Remove the smallest element in the heap & restructure heap
   
   void decreaseKey(int pos, int val)// Decreases Key in pos to val
   {
         // FILL IN THE REST
         array[pos]->key = val;

         upHeap(pos);

   }; 
   

   bool IsEmpty() const {  return (elements <= 0);};
   bool IsFull() const {return (elements >=MAX_SIZE );};
   int count() const {return elements;};
   Object* value(int pos) const{ //return a pointer to an object in heap position
	   if (pos >= elements){
		   cout << "Out of range of heap " << pos << "elements " << elements << endl;
	   }
      return (array[pos]);
   };  
protected:
   Object* array[MAX_SIZE];
   int elements;       //  how many elements are in the heap
private:
   void downHeap(int pos){// starting with element in position pos, sift it down the heap 
                       // until it is in final min-heap position
      Object* item = array[pos];

      // FILL THIS IN

      int left = 2 * pos + 1;


      while (left < elements){

         
      if (left < elements - 1){
         int right = 2 * pos + 2;
      

          if ((left < elements - 1) && (array[left]->key > array[right]->key)){
            left = right;
         }
      }

       if ( (array[left]->key < array[pos]->key)){
         array[pos] = array[left];
         array[pos]->position = pos;
         array[left] = item;
         array[left]->position = left;

         pos = left;
         left = 2 * left + 1;

        
      }else {
         break;
      }
         item = array[pos];



      }
      



 

   }; 

   void upHeap(int new_pos){// starting with element in position int, sift it up the heap
                       // until it is in final min-heap position
      Object* item = array[new_pos];
      
      //FILL IN THE REST 

      while ((new_pos >= 0) && (array[(new_pos - 1) /2]->key > array[new_pos]->key)){
         
         array[new_pos] = array[(new_pos - 1) /2];
         array[new_pos]->position = new_pos;
         array[(new_pos - 1) /2] = item;
         array[(new_pos - 1) /2]->position = (new_pos - 1) /2;

         new_pos = (new_pos - 1) /2;
         item = array[new_pos];

        
      }

   };   
};
#endif
