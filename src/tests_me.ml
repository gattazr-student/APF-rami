(* Fichier de test du multi ensemble *)
open MultiEnsemble

let (print_imelt : 'int melt -> unit) = fun aMElement ->
	let (wE,wO) = aMElement in
	print_string "(";
	print_int wE;
	print_string ",";
	print_int wO;
	print_string "); ";;

let rec (print_imset_aux : 'int mset -> unit) = fun aSet ->
match aSet with
	| [] -> ();
	| wT::wQ -> print_imelt wT; print_imset_aux wQ;;

let rec (print_imset : 'int mset -> unit) = fun aSet ->
	print_string "[ ";
	print_imset_aux aSet;
	print_string "]";;


let (print_cmelt : 'char melt -> unit) = fun aMElement ->
	let (wE,wO) = aMElement in
	print_string "(";
	print_char wE;
	print_string ",";
	print_int wO;
	print_string "); ";;

let rec (print_cmset_aux : 'char mset -> unit) = fun aSet ->
match aSet with
	| [] -> ();
	| wT::wQ -> print_cmelt wT; print_cmset_aux wQ;;

let rec (print_cmset : 'char mset -> unit) = fun aSet ->
	print_string "[ ";
	print_cmset_aux aSet;
	print_string "]";;


Printf.printf "Test du module MultiEnsemble\n\n";;

Printf.printf "Définition du MElement wMelt = (1, 99)\n";;
let wMelt:int melt = (1, 99);;
Printf.printf "Contenu de wMelt : ";; print_imelt;; Printf.printf "\n\n";;

Printf.printf "Définition du Set wMset1 = [ (1, 1); (2, 5); (3, 3) ]\n";;
let wMset1: int mset = [(1, 1); (2, 5); (3, 3)];;
Printf.printf "Contenu de wMset1 : ";; print_imset wMset1;; Printf.printf "\n\n";;

Printf.printf "Définition du Set wMset1' = [ (1, 1); (2, 5); (3, 3) ]\n";;
let wMset1': int mset = [ (1, 1); (2, 5); (3, 3) ];;
Printf.printf "Contenu de wMset1' : ";; print_imset wMset1;; Printf.printf "\n\n";;

Printf.printf "Définition du Set wMset2' = [ (1, 99); (2, 95); (3, 97) ]\n";;
let wMset2:int mset = [ (1, 99); (2, 95); (3, 97) ];;
Printf.printf "Contenu de wMset2' : ";; print_imset wMset2;; Printf.printf "\n\n";;

Printf.printf "Définition du Set wMsetA = [ ('A', 1); ('B', 5); ('C', 2) ]\n";;
let wMsetA: char mset = [ ('A', 1); ('B', 5); ('C', 2) ];;
Printf.printf "Contenu de wMsetA : ";; print_cmset wMsetA;; Printf.printf "\n\n";;

Printf.printf "Ajout de wMelt à wMset1. Sortie attendu : [ (1, 100); (2, 5); (3, 3) ]\n";;
Printf.printf "Sortie : ";; print_imset (add wMset1 wMelt);; Printf.printf "\n\n";;

Printf.printf "Union de wMset1 à wMset1. Sortie attendu : [ (1, 100); (2, 100); (3, 100) ]\n";;
Printf.printf "Sortie : ";; print_imset (union wMset1 wMset2);; Printf.printf "\n\n";;

Printf.printf "Recherche de 30 dans wMset1. Sortie attendu : false\n";;
Printf.printf "Sortie : ";; print_string (string_of_bool (member 30 wMset1));; Printf.printf "\n\n";;

Printf.printf "Recherche de 1 dans wMset1. Sortie attendu : true\n";;
Printf.printf "Sortie : ";; print_string (string_of_bool (member 1 wMset1));; Printf.printf "\n\n";;

Printf.printf "Test d'égalité entre wMset1 et wMset1'. Sortie attendu : true\n";;
Printf.printf "Sortie : ";; print_string (string_of_bool (equal wMset1 wMset1'));; Printf.printf "\n\n";;

Printf.printf "Test d'égalité entre wMset1 et wMset2. Sortie attendu : false\n";;
Printf.printf "Sortie : ";; print_string (string_of_bool (equal wMset1 wMset2));; Printf.printf "\n\n";;

Printf.printf "Calcul du cardinal de wMset1. Sortie attendu : 9 \n";;
Printf.printf "Sortie : ";; print_int (cardinal wMset1);; Printf.printf "\n\n";;

Printf.printf "Calcul du cardinal de wMset2. Sortie attendu : 300 \n";;
Printf.printf "Sortie : ";; print_int (cardinal wMset2);; Printf.printf "\n\n";;

Printf.printf "Retire l'élément wMlet à wMset2. Sortie attendu : [ (2, 95); (3, 97) ] \n";;
Printf.printf "Sortie : ";; print_imset (remove wMelt wMset2);; Printf.printf "\n\n";;

Printf.printf "Retire l'élément wMlet à l'union des set wMset1 et wMset2. Sortie attendu : [ (1, 1); (2, 100); (3, 100) ]\n";;
Printf.printf "Sortie : ";; print_imset ((remove wMelt (MultiEnsemble.union wMset2 wMset1)));; Printf.printf "\n\n";;

let _ = Random.self_init();;
Printf.printf "Récupère un élement aléatoire de wMSet1. Sortie attendue : 1 ou 2 ou 3 - [ (1, 1); (2, 5); (3, 3) ] avec un élement retiré quelconque\n";;
let (wNewM, wElement) = getRandom wMset1;; Printf.printf "Sortie : ";; print_int wElement; Printf.printf " - "; print_imset wNewM;; Printf.printf "\n\n";;
