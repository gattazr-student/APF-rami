(* decomposeString
 * retourne la décomposition tête reste d'une chaine de caratères.
 * @param string : chaine à décomposer
 * @return char*string : couple charatère de tête, reste de la chaine
 *)
let (decomposeString : string -> (char*string) ) = fun aString ->
	let wLength = (String.length aString) in
	if wLength > 0 then
		(aString.[0],(String.sub aString 1 (wLength - 1)))
	else
		failwith "String is empty"

(* indiceOfLetter
 * retourne l'indice dans l'alphabet d'un caractère en majuscule
 * @param char : caractère à utiliser
 * @return char*string : couple charatère de tête, reste de la chaine
 *)
let (indiceOfLetter : char -> int) = fun aChar ->
	int_of_char(aChar) - int_of_char('A')
(*
 * dico
 * Arbre 26-naire. Les enfants d'un noeud sont les lettres de l'alphabet.
 * Si le boolean dans un noeud est a vrai, le chemin depuis la racine représente
 * le mot contenu dans le dictionnaire.
 *)
type dico = Noeud of dico array * bool | Feuille

(*
 * Dans la spécification, dico_vide n'était pas une fonction. Il n'était donc pas possible
 * d'assurer que dico_vide était effectivement un dico vide. Nous avons donc décidé de
 * définir dico_vide comme étant une fonction.
 *
 * dico_vide
 * retourne un dictionnaire vide
 * @param unit :
 * @return dico : dictionnaire vide
 *)
let (dico_vide: unit -> dico) = fun () -> Noeud((Array.make 26 Feuille), false)

(* member
 * vérifie la présence d'un mot dans un dictionnaire. Le mot peut être composé
 * d'une ou plusieurs étoiles symbolisant n'importe quel caractère
 * @param string : mot à rechercher dans le dictionnaire
 * @param dico : dictionnaire à utiliser
 * @return bool : true si le mot est dans le dictionnaire, false sinon
 *)
let rec (member : string -> dico -> bool) = fun aElement aDico ->
	match aDico with
	| Feuille -> false
	| Noeud(wTab, wB) ->
		if aElement = "" then
			wB
		else
			let (wC, wRest) = decomposeString(aElement) in
			if(wC = '*') then
				(Array.fold_left (||) false (Array.map (member wRest) wTab))
			else
				(member wRest (wTab.((indiceOfLetter(wC)))))

(* add
 * Ajoute un mot dans un dictionnaire
 * @param string : mot à rajouter dans le dictionnaire
 * @param dico : dictionnaire à utiliser
 * @return dico : dictionnaire passé en paramètre avec le mot supplémentaire
 *)
let rec (add : string -> dico -> dico)= fun aElement aDico ->
	match aDico with
		| Feuille ->
			let wTab = Array.make 26 Feuille in
				(add aElement (Noeud(wTab, false)));
		| Noeud(wTab, wB) ->
			if (String.length aElement > 0) then
				let (wC, wRest) = decomposeString(aElement) in
				let wIndex = indiceOfLetter wC in
					wTab.(wIndex)<-(add wRest (wTab.(wIndex)));
					Noeud(wTab, wB)
			else
				Noeud(wTab,true)

(* remove
 * Retire un mot dans un dictionnaire
 * @param string : mot à retirer dans le dictionnaire
 * @param dico : dictionnaire à utiliser
 * @return dico : dictionnaire passé en paramètre avec le mot retiré
 *)
let rec (remove : string -> dico -> dico) = fun aElement aDico ->
	match aDico with
		| Feuille -> failwith "Ce mot n'est pas dans le dico!"
		| Noeud(wTab, wB) ->
			if (String.length aElement > 0) then
				let (c0,rest) = decomposeString(aElement) in
				let nb = indiceOfLetter c0 in
					wTab.(nb) <- (remove rest (wTab.(nb)));
					Noeud(wTab, wB);
			else
				Noeud(wTab, false)


(* read_mot
 * Retourne la chaine de charatère formant le prochain mot dans le stream de caractères.
 * Un mot est considéré comme fini lorsqu'un retour à la ligne est fait.
 * @param string : string contenant les charatères précédent du mot
 * @param char Stream.t : stream de char contenant un mot
 * @return string : un mot
 *)
let rec (read_mot : string -> char Stream.t -> string) = fun aMot ->
	parser
	| [< ''A'..'Z' as wC; wRest >] -> (read_mot (aMot^(String.make 1 wC)) wRest)
	| [< ''\n' >] -> aMot
	| [< >] -> aMot


(* read_mots
 * Retourne un dictionnaire contenant tous les mots contenus le dictionnaire passé
 * en paramètres et les mots contenus dans un stream de charactères. Les mots dans
 * le stream doivent être séparés par des retours à la ligne Les mots dans le
 * stream doivent être séparés par des retours à la ligne
 * @param dico : dictionnaire à utiliser
 * @param char Stream.t : stream de char contenant les mots à mettre dans un dictionnaire.
 * @return dico : dictionnaire contenant tous les mots du stream et du dictionnaire en paramètre
 *)
let rec (read_mots : dico -> char Stream.t -> dico) = fun aDico ->
	parser
	| [< wMot = (read_mot "") ; wRest >] ->
		if (wMot = "") then
			aDico
		else
			(read_mots (add wMot aDico) wRest)

(* of_stream
 * Retourne un dictionnaire contenant tous les mots dans un stream.
 * Les mots dans le stream doivent être séparés par des retours à la ligne
 * @param char Stream.t : stream de char contenant les mots à mettre dans un dictionnaire.
 * @return dico : dictionnaire contenant tous les mots du stream
 *)
let (of_stream : char Stream.t -> dico) = fun aStream ->
	read_mots (dico_vide()) aStream


(* to_list_aux
 * Retourne une liste de string contenant tous les mots du dictionnaire préfixé par une string
 * @param string : préfixe des mots contenu dans le dictionnaire
 * @param dico : dictionnaire à utiliser
 * @return string list :  liste de string contenant tous les mots dans le dictionnaire
 *)
let rec (to_list_aux : string -> dico -> string list) = fun aString aDico ->
	match aDico with
	| Feuille -> []
	| Noeud(wTab, wB) -> let wStrings = ref [] in
							for wI = 0 to 25 do
								wStrings := (List.rev_append
									(to_list_aux (aString^(String.make 1 (Char.chr (int_of_char 'A' + wI)))) wTab.(wI))
									!wStrings
								);
							done;
							(if wB then
								List.rev (aString::!wStrings)
							else
								List.rev (!wStrings)
							)


(* to_list
 * Retourne une liste de string contenant tous les mots d'un dictionnaire.
 * La liste est trié dans l'ordre alphabétique.
 * @param dico : dictionnaire à utiliser
 * @return string list :  liste de string contenant tous les mots dans le dictionnaire
 *)
let (to_list : dico -> string list) = fun aDico ->
	to_list_aux "" aDico
