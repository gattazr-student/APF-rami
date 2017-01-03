(* Fichier de test du dictionnaire *)
open Dictionnaire

let rec print_list = function
	[] -> ()
	| e::l -> print_string e ; print_string " " ; print_list l

let valide s =
	((String.length s) <> 0) &&
	begin
		let ret = ref true in
			for i = 0 to (String.length s) - 1 do
				let c = Char.code s.[i] in
					ret := (!ret) && (c >= (Char.code 'A')) && (c <= (Char.code 'Z'))
			done;
			!ret
	end;;

let dico() =
	let flux = open_in "tests/dico_fr.txt" in
	let mondico = ref (Dictionnaire.dico_vide ()) in
	try
		begin
			while true do
				let l = String.uppercase (input_line flux) in
					if (valide l) then
						mondico := Dictionnaire.add l (!mondico)
			done;
			!mondico
		end
	with
	End_of_file -> !mondico;;

let (print_dico : dico -> unit) = fun aDico ->
	Printf.printf "Contenu du dico : ";
	print_list(to_list aDico);
	Printf.printf "\n\n";;

Printf.printf "Test du module Dictionnaire\n\n";;


Printf.printf "Création d'un dico vide : \n";;
let wDico = dico_vide();;
print_dico wDico;;

Printf.printf "Rajout des mots BONJOUR et BAOBAD dans un dico vide. Sortie attendue : BONJOUR BAOBAD\n";;
let wDico1 = add "BONJOUR" (add "BAOBAD" (dico_vide()));;
print_dico wDico1;;

Printf.printf "Recherche de BONJOUR dans le dictionnaire wDico1. Sortie attendue : true \n";;
Printf.printf "Sortie : ";; print_string (string_of_bool (member "BONJOUR" wDico1));; Printf.printf "\n\n";;

Printf.printf "Recherche de CHAT dans le dictionnaire wDico1. Sortie attendue : false \n";;
Printf.printf "Sortie : ";; print_string (string_of_bool (member "CHAT" wDico1));; Printf.printf "\n\n";;

Printf.printf "Retire l'élement BONJOUR du dictionnaire wDico1. Sortie attendue : BAOBAD \n";;
print_dico (remove "BONJOUR" wDico1);;

Printf.printf "Retire l'élement BAOBAD du dictionnaire wDico1. Sortie attendue : \n";;
print_dico (remove "BAOBAD" wDico1);;

(*
TODO : Rajouter la gestion de l'exception pour pouvoir remettre ce test
Printf.printf "Retire l'élement CHAT du dictionnaire wDico1. Sortie attendue : Exception \n";;
print_dico (remove "CHAT" wDico1);;
*)

Printf.printf "Créer le dictionnaire à partir du stream \"BONJOUR\\nBOABAB\\n\". Sortie attendue : BAOBAD BONJOUR\n";;
print_dico (of_stream (Stream.of_string "BONJOUR\nBAOBAB\n"));;

Printf.printf "Créer le dictionnaire à partir du stream \"BONJOUR\\nBOABAB\". Sortie attendue : BAOBAD BONJOUR\n";;
print_dico (of_stream (Stream.of_string "BONJOUR\nBAOBAB"));;

Printf.printf "Créer le dictionnaire à partir du stream \"BONJOUR\". Sortie attendue : BONJOUR\n";;
print_dico (of_stream (Stream.of_string "BONJOUR"));;

Printf.printf "Lecture et écriture dans le terminal d'un fichier dictionnaire de 300 000 mots.\nAppuyez sur une touche :\n";;
let _ = read_line();;

print_dico (dico());;
