open Regle

module Tuiles =
struct

	(* couleur des tuiles *)
	type couleur = Bleu | Rouge | Jaune | Noir

	(* Tuile *)
	type t = Tuile of couleur * int

	(* Combinaison ou liste de Tuile *)
	type combi = t list

	(* liste de couple de Tuile et son occurence *)
	type main = t MultiEnsemble.mset

	(* Pour savoir le nom des joueurs, leurs scores, les tuiles présentes sur leurs chevalets(main), les combinaisons posés sur la table(table), les tuiles de la pioche(pioche), si les joueurs ont déja posés des tuiles(pose), nombre de tour*)
	type etat = {
		noms: string array;
		scores: int array;
		mains: main array;
		table: combi list;
		pioche: main;
		pose: bool array;
		tour: int
	}

	(* paquet
	 * initialise la pioche de tuiles. Les tuiles sont numérotées de 1 à 13 et possède chacune une couleur. Chaque tuile apparait
	 * exactement deux fois
	 * @return t MultiEnsemble.mset : renvoie une liste de couple de Tuiles et son occurence
	 *)
    let (paquet:t MultiEnsemble.mset) =
		let p = ref MultiEnsemble.nil in
			for wI=1 to 13 do
				p := MultiEnsemble.add !p ((Tuile (Bleu, wI)), 2);
				p := MultiEnsemble.add !p ((Tuile (Rouge, wI)), 2);
				p := MultiEnsemble.add !p ((Tuile (Jaune, wI)), 2);
				p := MultiEnsemble.add !p ((Tuile (Noir, wI)), 2);
			done;
		!p

	(* combi_suite
 	 * vérifie si une combinaison de tuiles est une suite monochromes d'au moins 3 tuiles consécutives
 	 * @param combi : liste d'une combinaison de tuiles
 	 * @return bool : true si la combinaison est une suite monochrome d'au moins 3 tuiles consécutives sinon false
 	 *)
	let rec (combi_suite : combi -> bool) = fun aCombi ->
  		match aCombi with
  		|[Tuile(c1,n1);Tuile(c2,n2);Tuile(c3,n3)] -> (c1 = c2) && (c2 = c3) && (n1+1 = n2) && (n2+1 = n3)
  		|Tuile(c1,n1) :: Tuile(c2,n2) :: q ->
    			if (c1=c2) && (n1+1=n2) then combi_suite (Tuile(c2,n2) :: q) else false
    	|_ -> false

    (* combi_couleur
 	 * vérifie si une combinaison de tuiles est un groupe d'au moins 3 tuiles de couleurs distinctes et comportant le même entier
 	 * @param combi : liste d'une combinaison de tuiles
 	 * @return bool : true si la combinaison est un groupe d'au moins 3 tuiles de couleurs distinctes et
 	 * comportant le même entier sinon false
 	 *)
    let (combi_couleur : combi -> bool) = fun aCombi ->
  		match aCombi with
  		|[Tuile(c1,n1);Tuile(c2,n2);Tuile(c3,n3)] -> (c1 != c2) && (c1 != c3) && (c2 != c3) && (n1 = n2) && (n2 = n3)
  		|[Tuile(c1,n1);Tuile(c2,n2);Tuile(c3,n3);Tuile(c4,n4)] -> (c1 != c2) && (c1 != c3) && (c1 != c4) && (c2 != c3) && (c2 != c4) && (c3 != c4) && (n1 = n2) && (n2 = n3) && (n3 = n4)
  		|_ -> false

  	(* combi_valide
 	 * vérifie si une combinaison de tuiles est un groupe d'au moins 3 tuiles de couleurs distinctes et comportant le même entier ou
 	 * une suite monochromes d'au moins 3 tuiles consécutives
 	 * @param combi : liste d'une combinaison de tuiles
 	 * @return bool : true si la combinaison est un groupe d'au moins 3 tuiles de couleurs distinctes et
 	 * comportant le même entier ou une suite monochromes d'au moins 3 tuiles consécutives sinon false
 	 *
 	 * On utilise combi_couleur et combi_suite
 	 *)
  	let (combi_valide : combi -> bool) = fun aCombi -> combi_suite (aCombi) || combi_couleur (aCombi)

	(* combi_point
	 * donne le nombre de points d'une combinaison de tuiles
	 * @param combi : liste d'une combinaison de tuiles
	 * @return int : entier qui donne le nombre de points d'une combinaison de tuiles
	 *)
	let rec (combi_point : combi -> int) = fun aCombi ->
    	match aCombi with
    	|[] -> 0
    	|Tuile(c,n) :: q -> n+combi_point q

	(* suite_combi_point
	 * donne le nombre de points de plusieurs combinaisons de tuiles
	 * @param combi list: liste de plusieurs combinaisons de tuiles
	 * @return int : entier qui donne le nombre de points de toutes les combinaisons de tuiles
	 *)
	let rec (suite_combi_point : combi list -> int) = fun aCombi ->
		match aCombi with
		|[] -> 0
		|e :: q -> combi_point e + suite_combi_point q

	(* suite_combi_valide
	 * vérifie si toutes les combinaisons sont valides
	 * @param combi list : liste de plusieurs combinaisons de tuiles
	 * @return bool : true si indépendemment toutes les combinaisons sont correctes
	 *)
	let rec (suite_combi_valide : combi list -> bool) = fun aCombi ->
  		match aCombi with
  		|[]  -> false
  		|[e] -> combi_valide e
  		|combi1 :: combi2 :: q -> if combi_valide (combi1) then suite_combi_valide (combi2 :: q) else false

	(* premier_coup_valide
 	 * vérifie les règles de la première pose, c'est-à-dire la liste de combinaison de tuiles est supérieur à 30 et chaque combinaison 		* de la liste est vérifiée.
 	 * @param main : main de départ (aucun coup joué encore)
 	 * @param combi list : liste de combinaison
 	 * @param main : main après le coup posé
 	 * @return bool : true si la liste de combinaison de tuiles est supérieur à 30, si les combinaisons sont valides sinon false
 	 *
 	 * On suppose que si les joueurs sont honnêtes, les tuiles dans la main de départ sont exactement les mêmes dans la liste de
 	 * combinaisons plus, celle qui sont dans la main après le coup posé. Les trichuers peuvent donc rajouter des tuiles qui n'étaient
 	 * pas dans leur main de départ pour former des combinaisons.
 	 *)
	let rec (premier_coup_valide : main -> combi list -> main -> bool) = fun aMain aNewCombi aNewMain ->
	(suite_combi_point aNewCombi >= 30) && (suite_combi_valide aNewCombi)

	(* points
	 * Il n'y a pas de points faits à chaque coup, donc on renvoie zéro, les points sont comptés à la fin de la partie
	 * @param combi list :
	 * @param main :
	 * @param combi list :
	 * @param main :
	 * @return int : 0
	 *)
	let (points : combi list -> main -> combi list -> main -> int) = fun aCombis aMain aNewCombi aNewMain -> 0

	(* points_finaux
	 * donne le nombre de points de tuiles contenues dans la dernière mains
	 * @param main : liste de couples de tuiles et d'occurence de cette tuile
	 * @return int : entier qui donne le nombre de points des tuiles contenues dans la main
	 *)
	let rec (points_finaux : main -> int) = fun aMain ->
		match aMain with
		|[] -> 0
		|(Tuile(c,n),occ) :: q -> occ*n + (points_finaux q)

	(* main_min
	 * donne le nombre de tuiles minimum dans une main
	 * @return int : 0
	 *)
	let (main_min : int) = 0

	(* main_initiale
	 * donne le nombre de tuiles contenues dans la première main
	 * @return int : 14
	 *)
	let (main_initiale : int) = 14

	(* ecrit_valeur
	 * pas implémenter ici
	 * @param t : tuile
	 * @return string :
	 *)
	let (ecrit_valeur : t -> string) = fun aTuile ->
		"not Implemented yet"

	(* fin_pioche_vide
	 * vérifie si la pioche est vide
	 * @return bool : true à la fin du jeu la pioche est toujours vide
	 *)
	let (fin_pioche_vide : bool) = true

end
