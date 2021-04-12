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
type command =  
  | PushS of string
  | Pop
  | Log
  | Swap
  | Add
  | Sub
  | Mul 
  | Div 
  | Rem 
  | Neg 
  | PushI of int
  | PushB of bool
  | PushU

type myStack = 

  | Int of int
  | Str of string
  | Bool of bool
  | Unit





let get_command (s:char list): ( char list * char list) = 
  let rec foo (c:char list) (result : char list) = 
    match c with 
    | ';' :: t -> (result, t)
    | h :: t -> foo t ( result @ [h])

  in 
  foo s []

let get_string (s:char list) : (char list * char list) = 
  let rec foo (c: char list) (result: char list) (num:int) = 
    match c with
    | ';' :: t -> if (num == 2) then (result, t) else foo t (result @[';']) num
    | '\"' :: t -> foo t (result @ ['\"']) (num + 1)
    | h :: t -> foo t ( result @ [h]) num
  in 
  foo s [] 0


open Printf

let explode s =
  List.of_seq (String.to_seq s)

let implode ls =
  String.of_seq (List.to_seq ls)



(* let parser (s:string) : command list = 
   let rec foo (s : char list) (c: command list) = 
    match s with 
    | [] -> c
    | 'P' :: 'u' :: 's' :: 'h' :: ' ' :: t ->
      match t with
      | h :: w ->  
        if (h == '<')
        then match w with
          | 'u' :: w2 -> let (command, rest) = get_command t in foo rest ( c @ [PushU])
          | 't' :: w2 -> let (command, rest) = get_command t in foo rest ( c @ [PushB true])
          | 'f' :: w2 -> let (command, rest) = get_command t in foo rest ( c @ [PushB false])
        else if (h == '\"')
        then let (command, rest) = get_command t in foo rest ( c @ [PushS (implode command)])
        else let (command, rest) = get_command t in foo rest (c @ [PushI (int_of_string (implode command))])

      | 'P' :: 'o' :: 'p' :: ';' :: t -> foo t (c @ [Pop])

      | 'L' :: 'o' :: 'g' :: ';' :: t -> foo t (c @ [Log])

      | 'S' :: 'w' :: 'a' :: 'p' :: ';' :: t -> foo t (c @ [Swap])

      | 'A' :: 'd' :: 'd' :: ';' :: t -> foo t (c @ [Add])

      | 'S' :: 'u' :: 'b' :: ';' :: t -> foo t (c @ [Sub])

      | 'M' :: 'u' :: 'l' :: ';' :: t -> foo t (c @ [Mul])

      | 'D' :: 'i' :: 'v' :: ';' :: t -> foo t (c @ [Div])

      | 'R' :: 'e' :: 'm' :: ';' :: t -> foo t (c @ [Rem])

      | 'N' :: 'e' :: 'g' :: ';' :: t -> foo t (c @ [Neg])

   in 
   match (explode s) with

   | 'P' :: 'u' :: 's' :: 'h' :: ' ' :: t ->
    match t with
    | h :: w ->  
      if (h == '<')
      then match w with
        | 'u' :: w2 -> let (command, rest) = get_command t in foo rest (  [PushU])
        | 't' :: w2 -> let (command, rest) = get_command t in foo rest (  [PushB true])
        | 'f' :: w2 -> let (command, rest) = get_command t in foo rest ( [PushB false])
      else if (h == '\"')
      then let (command, rest) = get_command t in foo rest (  [PushS (implode command)])
      else let (command, rest) = get_command t in foo rest ( [PushI (int_of_string (implode command))])

    | 'P' :: 'o' :: 'p' :: ';' :: t -> foo t [Pop]

    | 'L' :: 'o' :: 'g' :: ';' :: t -> foo t [Log]

    | 'S' :: 'w' :: 'a' :: 'p' :: ';' :: t -> foo t [Swap]

    | 'A' :: 'd' :: 'd' :: ';' :: t -> foo t [Add]

    | 'S' :: 'u' :: 'b' :: ';' :: t -> foo t [Sub]

    | 'M' :: 'u' :: 'l' :: ';' :: t -> foo t  [Mul]

    | 'D' :: 'i' :: 'v' :: ';' :: t -> foo t [Div]

    | 'R' :: 'e' :: 'm' :: ';' :: t -> foo t [Rem]

    | 'N' :: 'e' :: 'g' :: ';' :: t -> foo t [Neg] *)

let rec parser (s:char list) : command list = 
  match ( explode (String.trim (implode (s)))) with
  | [] ->[]
  | 'P' :: 'u' :: 's' :: 'h' :: ' ' :: t ->
    (match t with
     | h :: w ->  
       if (h == '<')
       then match w with
         | 'u' :: w2 -> let (command, rest) = get_command t in (PushU :: parser rest)
         | 't' :: w2 -> let (command, rest) = get_command t in ((PushB true) :: parser rest)
         | 'f' :: w2 -> let (command, rest) = get_command t in ((PushB false) :: parser rest)
       else if (h == '\"')
       then let (command, rest) = get_string t in  (PushS (implode command) :: parser rest)
       else let (command, rest) = get_command t in  ((PushI (int_of_string (implode command))) :: parser rest))
  | 'N' :: 'e' :: 'g' :: ';' :: t -> Neg :: parser t
  | 'R' :: 'e' :: 'm' :: ';' :: t -> Rem :: parser t
  | 'D' :: 'i' :: 'v' :: ';' :: t -> Div :: parser t
  | 'M' :: 'u' :: 'l' :: ';' :: t -> Mul :: parser t
  | 'S' :: 'u' :: 'b' :: ';' :: t -> Sub :: parser t
  | 'A' :: 'd' :: 'd' :: ';' :: t -> Add :: parser t
  | 'S' :: 'w' :: 'a' :: 'p' :: ';' :: t -> Swap :: parser t
  | 'L' :: 'o' :: 'g' :: ';' :: t -> Log :: parser t
  | 'P' :: 'o' :: 'p' :: ';' :: t -> Pop :: parser t


let rec length (s : 'a list) : int = 
  match s with
  | [] -> 0
  | h :: t -> 1 + length t


let execvp (c : command list) (error: int) (stack : myStack list): string list * int = 
  let rec foo (com : command list) (e : int) (s :myStack list) (result: string list) =
    if (e != 0)
    then (result, e)
    else 
      match com with
      | [] -> if (e != 0) then ([], e) else (result, e)
      | PushI a :: t -> foo t e (Int a :: s) result
      | PushU :: t -> foo t e (Unit :: s) result
      | PushB true :: t -> foo t e (Bool true :: s) result
      | PushB false :: t -> foo t e (Bool false :: s) result
      | PushS str :: t -> foo t e (Str str :: s) result
      | Pop :: t ->

        (match s with
         | [] -> if (e != 0) then foo t e s result else foo t 2 s result
         | h :: rest -> foo t e rest result)

      | Log :: t ->

        (match s with
         | [] -> if (e != 0) then foo t e s result else foo t 2 s result
         | Int i :: rest -> foo t e rest (  result @ [(string_of_int i)])
         | Bool b :: rest -> foo t e rest (  result @  ["<" ^ (string_of_bool b) ^ ">"] )
         | Unit :: rest -> foo t e rest (  result @ ["<unit>"])
         | Str str :: rest -> foo t e rest (result @ [str]))

      | Swap :: t ->

        (match s with 
         | [] -> if (e != 0) then foo t e s result else foo t 2 s result
         | _ :: [] -> if (e != 0) then foo t e s result else foo t 2 s result
         | x :: y :: rest -> foo t e (y :: x :: rest) result)

      | Add :: t ->
        (match s with
         | [] -> if (e != 0) then foo t e s result else foo t 2 s result
         | _ :: [] -> if (e != 0) then foo t e s result else foo t 2 s result
         | Int a :: Int b :: rest -> foo t e (Int (a+b) :: rest) result
         | _ :: _ :: rest -> if (e != 0) then foo t e s result else foo t 1 s result)

      | Sub :: t ->
        (match s with
         | [] -> if (e != 0) then foo t e s result else foo t 2 s result
         | _ :: [] -> if (e != 0) then foo t e s result else foo t 2 s result
         | Int a :: Int b :: rest -> foo t e (Int (a-b) :: rest) result
         | _ :: _ :: rest -> if (e != 0) then foo t e s result else foo t 1 s result)

      | Mul :: t ->
        (match s with
         | [] -> if (e != 0) then foo t e s result else foo t 2 s result
         | _ :: [] -> if (e != 0) then foo t e s result else foo t 2 s result
         | Int a :: Int b :: rest -> foo t e (Int (a*b) :: rest) result
         | _ :: _ :: rest -> if (e != 0) then foo t e s result else foo t 1 s result)

      | Div :: t ->
        (match s with
         | [] -> if (e != 0) then foo t e s result else foo t 2 s result
         | _ :: [] -> if (e != 0) then foo t e s result else foo t 2 s result
         | Int a :: Int b :: rest -> if (b == 0) then if (e != 0) then foo t e s result else foo t 3 s result 
           else foo t e (Int (a/b) :: rest) result
         | _ :: _ :: rest -> if (e != 0) then foo t e s result else foo t 1 s result)

      | Rem :: t ->
        (match s with
         | [] -> if (e != 0) then foo t e s result else foo t 2 s result
         | _ :: [] -> foo t 2 s result
         | Int a :: Int b :: rest -> if (b == 0) then if (e != 0) then foo t e s result else foo t 3 s result 
           else foo t e (Int (a mod b) :: rest) result
         | _ :: _ :: rest -> if (e != 0) then foo t e s result else foo t 1 s result)

      | Neg :: t ->
        (match s with
         | [] -> if (e != 0) then foo t e s result else foo t 2 s result
         | Int a :: rest -> foo t e (Int (a * (-1)) :: rest) result
         | _ :: rest -> if (e != 0) then foo t e s result else foo t 1 s result)
  in 
  match c with
  | [] -> ([], 0)
  | PushI i :: rest -> foo rest 0 [Int i] []
  | PushU :: rest -> foo rest 0 [Unit] []
  | PushB b :: rest -> foo rest 0 [Bool b] []
  | PushS str :: rest -> foo rest 0 [Str str] []
  | Pop :: rest -> foo rest 2 [] []
  | Log :: rest -> foo rest 2 [] []
  | Swap :: rest -> foo rest 2 [] []
  | Add :: rest -> foo rest 2 [] []
  | Mul :: rest -> foo rest 2 [] []
  | Sub :: rest -> foo rest 2 [] []
  | Div :: rest -> foo rest 2 [] []
  | Rem :: rest -> foo rest 2 [] []
  | Neg :: rest -> foo rest 2 [] []






let readlines (file : string) : string =
  let fp = open_in file in
  let rec loop () =
    match input_line fp with
    | s -> s ^ (loop ())
    | exception End_of_file -> ""
  in
  let res = loop () in
  let () = close_in fp in
  res

let interpreter (s : string) : string list * int = 
  let commands = parser (explode s) in
  execvp commands 0 []




let runfile (file : string) : string list * int =
  let s = readlines file in
  interpreter s



let rec count (s : char list) : int = 
  match s with
  | [] -> 0;
  | '\"' :: t -> 1 + count t 
  | h :: t -> count t