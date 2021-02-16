(*
Honor code comes here:

First Name:Shihao
Last Name:Xing
BU ID:U66709138

I pledge that this program represents my own
program code and that I have coded on my own. I received
help from no one in designing and debugging my program.
I have read the course syllabus of CS 320 and have read the sections on Collaboration
and Academic Misconduct. I also understand that I may be asked to meet the instructor
or the TF for a follow up interview on Zoom. I may be asked to explain my solution in person and
may also ask you to solve a related problem.
*)



(* 
a print_list function useful for debugging.
*)

let rec print_list (ls: int list): unit =
  let rec aux ls = match ls with
    | [] -> print_string ""
    | e::[] -> print_int e
    | e::l -> 
      let _ = print_int e 
      in let _ = print_string "; " 
      in aux l

  in let _ = print_string "[" 
  in let _ = aux ls
  in         print_string "]" 





(* Problems *)

(*
TODO: Write a function called between that lists the integers between two integers (inclusive)
If the first number is greater then the second return the empty list
the solution should be tail recursive

For example,
between 4 7 = [4; 5; 6; 7]
between 3 3 = [3]
between 10 2 = []
between 4 1000000 does not stack overflow
*)


let between (n:int) (e:int): int list = 
  let rec foo  (l:int list) (b:int) (c:int) : int list=
    if (b - c > 0)
    then l 
    else foo (c :: l) b (c-1)
  in 
  foo [] n e


(*
TODO: Write a zip function that takes two lists of integers and combines them into a list of pairs of ints
If the two input list are of unequal lengths, combine as long as possible
your method should be tail recursive.

For example,
zip_int [1;2;3;5] [6;7;8;9] = [(1,6);(2,7);(3,8);(5,9)]
zip_int [1] [2;4;6;8] = [(1,2)]
zip_int (between 0 1000000) (between 0 1000000) does not stack overflow
*)

(*let rec zip_int (a: int list) (b: int list): (int * int) list = 
  match (a,b) with
  | [],[] -> []
  | [], _::tail ->[]
  | _::tail, [] ->[]
  | h1::t1 , h2::t2 -> (h1, h2) :: zip_int t1 t2
*)



let zip_int (a: int list) (b: int list): (int*int) list = 
  let rec foo (l: (int*int) list) (x: int list) (y: int list) = 
    match (x,y) with
    | [],[] -> l
    | [], _::tail -> l
    | _::tail,[] -> l
    | h1::t1, h2::t2 -> foo (l @ [(h1, h2)]) t1 t2
  in match (a,b) with 
  | t1::w1, t2::w2 -> foo [(t1,t2)] w1 w2
  | [],[] -> []
  | [], _::tail -> []
  | _::tail,[] -> []







(*
TODO: Write a dotProduct function for lists of integers,
If the two list are of unequal lengths then return 0

For example,
dotProduct [1;2;3;4] [6;7;8;9] = 80            (since 1*6+2*7+3*8+4*9 = 80)
dotProduct [1;2;3;4] [6] = 0
*)

let rec dotProduct (x: int list) (y: int list): int = 
  let rec length l = 
    match l with 
      [] -> 0
    |
      _::tail -> 1 + length tail
  in 
  if (length x != length y)
  then 0
  else 
    match (x,y) with
      [],[] -> 0
    |
      h1::tail1, h2::tail2 -> h1 * h2 + dotProduct tail1 tail2


(* 
TODO:
Write a function that takes a list of tuples and returns a string representation of that list

your representation should be valid as OCaml source:
* every element of a list must be separated by ";"
* the list must be wrapped in "[" and "]"
* tuples should (1,2)
* You may use whitespace however you like

For example,
list_of_tuple_as_string [(1,2);(3,4);(5,6)] = "[ (1,2); (3,4); (5,6) ]"
*)



let  list_of_tuple_as_string (list: (int*int) list): string = 
  let rec conv (list: (int*int) list): string = 
    match list with
    | [] -> "]"
    | (a,b) :: [] -> "(" ^ string_of_int a ^  "," ^ string_of_int b ^ ") ]"
    | (a,b) :: tail -> "(" ^ string_of_int a ^ "," ^ string_of_int b ^ "); " ^ conv tail
  in
  "[ " ^ conv list





(* 
TODO:
Write an insertion sort function for lists of integers

for example,
sort [6;7;1] = [1;6;7]
*)

(* 
Hint: We encourage you to write the following helper function 

let rec insert (i: int) (list: int list): int list = failwith "unimplemented"

that takes a a number, an already sorted ls and returns a new sorted list with that number inserted
for example,
insert 5 [1;3;5;7] = [1;3;5;5;7]

You can  then call this helper function inside sort. 
*)


let rec sort (ls: int list): int list = 
  let rec insert (i: int) (list: int list): int list =
    match list with 
    | [] -> [i]
    | h :: t -> if (i <= h) then i :: h :: t
      else h :: insert i t
  in 
  match ls with 
  | [] -> []
  | h :: t -> insert h (sort t) 
