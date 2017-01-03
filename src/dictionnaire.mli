(*
 * dico
 * Arbre 26-naire. Les enfants d'un noeud sont les lettres de l'alphabet.
 * Si le boolean dans un noeud est a vrai, le chemin depuis la racine représente
 * le mot contenu dans le dictionnaire.
 *)
type dico = Noeud of dico array * bool | Feuille

(* dico_vide
 * retourne un dictionnaire vide
 * @param unit :
 * @return dico : dictionnaire vide
 *
 * Dans la spécification, dico_vide n'était pas une fonction. Il n'était donc pas possible
 * d'assurer que dico_vide était effectivement un dico vide. Nous avons donc décidé de
 * définir dico_vide comme étant une fonction.
 *)
val dico_vide : unit -> dico


(* member
 * vérifie la présence d'un mot dans un dictionnaire. Le mot peut être composé
 * d'une ou plusieurs étoiles symbolisant n'importe quel caractère
 * @param string : mot à rechercher dans le dictionnaire
 * @param dico : dictionnaire à utiliser
 * @return bool : true si le mot est dans le dictionnaire, false sinon
 *)
val member : string -> dico -> bool

(* add
 * Ajoute un mot dans un dictionnaire
 * @param string : mot à rajouter dans le dictionnaire
 * @param dico : dictionnaire à utiliser
 * @return dico : dictionnaire passé en paramètre avec le mot supplémentaire
 *)
val add : string -> dico -> dico

(* remove
 * Retire un mot dans un dictionnaire
 * @param string : mot à retirer dans le dictionnaire
 * @param dico : dictionnaire à utiliser
 * @return dico : dictionnaire passé en paramètre avec le mot retiré
 *)
val remove : string -> dico -> dico


(* of_stream
 * Retourne un dictionnaire contenant tous les mots dans un stream de caractères.
 * Les mots dans le stream doivent être séparés par des retours à la ligne
 * @param char Stream.t : stream de char contenant les mots à mettre dans un dictionnaire.
 * @return dico : dictionnaire contenant tous les mots du stream
 *)
val of_stream : char Stream.t -> dico

(* to_list
 * Retourne une liste de string contenant tous les mots d'un dictionnaire.
 * La liste est trié dans l'ordre alphabétique.
 * @param dico : dictionnaire à utiliser
 * @return string list :  liste de string contenant tous les mots dans le dictionnaire
 *)
val to_list : dico -> string list
