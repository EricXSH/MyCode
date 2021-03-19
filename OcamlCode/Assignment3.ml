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

(* the type of a plymorphic tree *)
type 'a tree =
  | Leaf of 'a 
  | Node of 'a tree * 'a tree


(*
TODO: write a map function for trees:
For example,
map_tree (fun x -> x+1) (Node (Leaf 1, Leaf 2)) =  (Node (Leaf 2, Leaf 3))
map_tree (fun _ -> 0)  (Node (Node (Leaf true, Node (Leaf true, Leaf false)), Node (Node (Leaf true, Node (Leaf true, Leaf false)), Leaf false))) =
                       (Node (Node (Leaf 0   , Node (Leaf 0   , Leaf 0    )), Node (Node (Leaf 0   , Node (Leaf 0   , Leaf 0    )), Leaf 0    )))
*)
let rec map_tree (f: 'a -> 'b) (tree: 'a tree): 'b tree = 
  match tree with
  | Leaf x -> Leaf (f x)
  | Node (l, r) -> Node ((map_tree f l), (map_tree f r))

(*
TODO: write a fold function for trees:
*)

let rec fold_tree (node: 'b -> 'b -> 'b)  (leaf: 'a -> 'b)  (tree: 'a tree): 'b  = 
  match tree with
  | Leaf x -> leaf x
  | Node (l,r) -> node (fold_tree node leaf l) ( fold_tree node leaf r)



(*
TODO: sum the contents of an int tree
For example,
sum_ints (Node (Leaf 1, Leaf 2)) = 3
*)
let rec sum_ints (tree: int tree): int  = 
  match tree with
  | Leaf x -> x
  | Node (l, r) -> (sum_ints l) + (sum_ints r)



(*
TODO: find the size of the tree
For example,
tree_size (Leaf 1) = 1
tree_size (Node (Leaf 1, Leaf 2)) = 3
*)
let rec tree_size (tree: 'a tree): int  = 
  match tree with
  | Leaf x -> 1
  | Node (l,r) -> (tree_size l ) + (tree_size r) + 1


(*
TODO: find the height of the tree
For example,
tree_height (Leaf 2) = 1
tree_height (Node ((Node (Leaf 1, (Node ((Node (Leaf 1, Leaf 2)), Leaf 2)))), Leaf 2)) = 5
*)
let rec tree_height (tree: 'a tree): int  =
  match tree with
  | Leaf x -> 1
  | Node (l,r) -> 1 + max (tree_height l) (tree_height r)

(*
TODO: write a function that takes a predicate on trees and retuns true if any subtree satisfies that predicate
For example,
tree_contains (Node (Leaf 1, Leaf 2)) (fun x -> match x with Leaf 2 -> true | _ -> false) = true
*)
let rec tree_contains (tree: 'a tree) (look_for: 'a tree -> bool): bool  = 
  if (look_for tree)
  then true
  else 
    match tree with
    | Leaf x -> look_for (Leaf (x))
    | Node (l,r) -> if ((tree_contains r look_for) || (tree_contains l look_for)) then true else false





(*
TODO: write a function that shows bool trees :
For example,
show_bool_tree (Leaf true) ="true"
show_bool_tree (Node (Leaf true, Leaf false)) = "(true^false)" 
show_bool_tree  (Node (Node (Leaf true, Node (Leaf true, Leaf false)),
   Node (Node (Leaf true, Node (Leaf true, Leaf false)), Leaf false))) =
    "((true^(true^false))^((true^(true^false))^false))" 
*)
let rec show_bool_tree (tree: bool tree) : string  = 
  match tree with
  | Leaf x -> string_of_bool x
  | Node (l,r) -> "(" ^ show_bool_tree l ^ "^" ^ show_bool_tree r ^ ")"


(* standard functions to convert between strin and char list *)
let explode s =
  let rec exp i l =
    if i < 0 then l else exp (i - 1) (s.[i] :: l) in
  exp (String.length s - 1) []

(*let implode l =
  let res = String.create (List.length l) in
  let rec imp i = function
    | [] -> res
    | c :: l -> res.[i] <- c; imp (i + 1) l in
  imp 0 l;;
*)
let implode ls =
  String.of_seq (List.to_seq ls)

(*
TODO: write a fubction that reads bool trees :
for all (finite) t : bool trees.
read_bool_tree t = Some (show_bool_tree t)
For example,
read_bool_tree "true" = Some (Leaf true)
read_bool_tree "false" = Some (Leaf false)
read_bool_tree "tralse" = None
read_bool_tree "(true^false)" = Some (Node (Leaf true, Leaf false))
read_bool_tree "((true^(true^false))^((true^(true^false))^false))" =
Some
 (Node (Node (Leaf true, Node (Leaf true, Leaf false)),
   Node (Node (Leaf true, Node (Leaf true, Leaf false)), Leaf false)))
*)

(* Hint 
   write a helper function 
   read_bool_prefix : (char list) -> ((bool * (char list)) option) 
   such that
   read_bool_prefix (explode "true???")       = Some (true, ['?'; '?'; '?'])
   read_bool_prefix (explode "false123")      = Some (false, ['1'; '2'; '3'])
   read_bool_prefix (explode "antythingales") = None
   read_bool_prefix []                        = None
   write a helper function 
   read_bool_tree_prefix (char list) -> ((bool tree * (char list)) option) 
   such that
   read_bool_tree_prefix [] = None
   read_bool_tree_prefix (explode "true???") = Some (Leaf true, ['?'; '?'; '?'])
   read_bool_tree_prefix (explode "(true^false)124") = Some (Node (Leaf true, Leaf false), ['1'; '2'; '4'])
   read_bool_tree_prefix (explode "(true^(true^false))aaa") = Some (Node (Leaf true, Node (Leaf true, Leaf false)), ['a'; 'a'; 'a'])
   read_bool_tree_prefix (explode "(true^(true^fa se))aaa") = None
*)
let  read_list (s: char list) : ((char list) option) = 
  let rec foo (c : char list) (l: (char list) )= 
    match c with 
    | [] -> Some (l)
    | h :: t -> foo t (l @ [h])
  in 
  match s with 
  | [] -> None
  | h :: t -> foo t [h]

let  read_bool_prefix (s: char list) : ((bool * (char list)) option) = 
  let rec foo (c: char list) (b: bool) (l: (char list)) = 
    match c with
    | [] -> Some (b,l)
    | h :: t -> foo t  b (l @ [h])
  in 
  match s with 
  | [] -> None
  | 't' :: 'r' :: 'u' :: 'e' :: h :: t -> foo t true [h]
  | 'f' :: 'a' :: 'l' :: 's' :: 'e' :: h :: t -> foo t false [h]
  | _::t -> None


let rec create_tree (s: char list ): ( bool tree) = 
  match s with
  | 't' :: 'r' :: 'u' :: 'e' :: [] -> Leaf true
  | 'f' :: 'a' :: 'l' :: 's' :: 'e' :: [] -> Leaf false
  | 't' :: 'r' :: 'u' :: 'e' :: t -> Node (Leaf true, create_tree t)
  | 'f' :: 'a' :: 'l' :: 's' :: 'e' :: t -> Node (Leaf false, create_tree t)
  | '^' :: t -> create_tree t
  | '(' :: t -> create_tree t
  | ')' :: t -> create_tree t



let rec read_bool_tree (tree: string) : ((bool tree) option) = 
  if (tree == "true" )
  then Some (Leaf true)
  else if (tree == "false")
  then Some (Leaf false)
  else 
    let s = explode tree in
    match s with 
    | [] -> None
    | '(' :: t -> read_bool_tree (implode t)
    | 't' :: 'r' :: 'u' :: 'e' :: t -> Some (Node (Leaf true, create_tree t))
    | 'f' :: 'a' :: 'l' :: 's' :: 'e' :: t -> Some (Node (Leaf false, create_tree t)) 
    | _ :: t -> None







(*
write a fubction that checks that parenthisis are balnaced:
Parenthisis are balenced if there are no parenthises
Parenthisis are balenced if ( and )  enclose a balenced parenthises
Parenthisis are balenced if balenced parenthises are ajacent to a balenced parenthisis
For example,
matching_parens "" = true
matching_parens "((((((((((()))))))))))" = true
matching_parens "()()()()()()" = true
matching_parens "(()())" = true
matching_parens "())(()" = false
*)


(* Hint 
   write mutually recirsive functions 
   matching_paren_prefix : (char list) -> ((char list) option)
   matching_parens_prefix : (char list) -> ((char list) option)
   the and keyword allows mutual recursion
   let rec matching_paren_prefix (ls: char list) : ((char list) option) = failwith "unimplemented"
   and matching_parens_prefix  (ls: char list) : ((char list) option) = failwith "unimplemented"
   such that
   matching_paren_prefix [] = None
   matching_paren_prefix (explode "(???") = None
   matching_paren_prefix (explode "()???") = Some ['?'; '?'; '?']
   matching_paren_prefix (explode "(((())))123") = Some ['1'; '2'; '3']
   matching_paren_prefix (explode "()()()") = Some ['('; ')'; '('; ')']
   matching_paren_prefix (explode "(()()())abc") = Some ['a'; 'b'; 'c']
   matching_parens_prefix [] = Some []
   matching_parens_prefix (explode "()()()") = Some ['('; ')'; '('; ')']
   matching_parens_prefix (explode ")aa") = Some [')'; 'a'; 'a']
*)



let  matching_parens (tree: string) : bool  = 
  let rec foo (check : int) (s :char list) = 
    if (check < 0)
    then false 
    else 
      match s with 
      | [] -> if (check == 0) then true else false
      | '(' :: t -> foo (check + 1) t
      | ')' :: t -> foo (check - 1) t
  in 
  foo 0 (explode tree)