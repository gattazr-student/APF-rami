open Regle

module Lettres : REGLE =
struct

	(* Fonction donnée
	 * Permet de vérifier qun 'un string est composé que de MAJUSCULES
	 * @param string : chaine à contrôler
	 * @return bool : chaine contient que des MAJUSCULES ?
	 *)
	let valide s =
		((String.length s) <> 0) &&
		begin
			let ret = ref true in
				for i = 0 to (String.length s) - 1 do
					let c = Char.code s.[i] in
						ret := (!ret) && (c >= (Char.code 'A')) && (c <= (Char.code 'Z'))
				done;
				!ret
		end

	(* Fonction donnée
	 * Permet de créer une variable global contenant le dictionnaire complet
	 * C'est une variable sans paramètre
	 * @return dico
	 *)
	let dico =
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
		End_of_file -> !mondico

	(* Nous sommes dans le cas des tuiles avec juste des lettres dessus *)
	type t = char

	type combi = t list

	type main = t MultiEnsemble.mset

	type etat = {
		noms: string array;
		scores: int array;
		mains: main array;
		table: combi list;
		pioche: main;
		pose: bool array;
		tour: int
	}

	(* Définition du paquet du jeu, celui qui est présent dans la boite du RAMI :)
	 * C'est une variable sans paramètre
	 * @return dico
	 *)
	 let paquet =
		let p = ref MultiEnsemble.nil in
			p := MultiEnsemble.add !p ('A',8);
			p := MultiEnsemble.add !p ('B',2);
			p := MultiEnsemble.add !p ('C',3);
			p := MultiEnsemble.add !p ('D',3);
			p := MultiEnsemble.add !p ('E',16);
			p := MultiEnsemble.add !p ('F',2);
			p := MultiEnsemble.add !p ('G',2);
			p := MultiEnsemble.add !p ('H',2);
			p := MultiEnsemble.add !p ('I',9);
			p := MultiEnsemble.add !p ('J',1);
			p := MultiEnsemble.add !p ('K',1);
			p := MultiEnsemble.add !p ('L',6);
			p := MultiEnsemble.add !p ('M',4);
			p := MultiEnsemble.add !p ('N',7);
			p := MultiEnsemble.add !p ('O',7);
			p := MultiEnsemble.add !p ('P',2);
			p := MultiEnsemble.add !p ('Q',1);
			p := MultiEnsemble.add !p ('R',7);
			p := MultiEnsemble.add !p ('S',7);
			p := MultiEnsemble.add !p ('T',7);
			p := MultiEnsemble.add !p ('U',7);
			p := MultiEnsemble.add !p ('V',2);
			p := MultiEnsemble.add !p ('W',1);
			p := MultiEnsemble.add !p ('X',1);
			p := MultiEnsemble.add !p ('Y',1);
			p := MultiEnsemble.add !p ('Z',1);
			p := MultiEnsemble.add !p ('*',2);
		!p


	(* string_of_t
	 * Permet juste de créer un string à partir d'un type t 
	 * @param t : le caratère à transformer
	 * @return string
	 *)
	let (string_of_t : t -> string) = fun aC ->
		String.make 1 aC

	(* rajout
	 * Permet convertir une liste de char en une string 
	 * @param string : le string de base auquel sera fait l'ajout
	 * @param t list : la liste à transformer
	 * @return string : la chaine correspondante à la liste contaténée à l'argument 1
	 *)
  	let rec (rajout : string -> t list -> string) = fun aCh aListe ->
		match aListe with
		|[] -> aCh
		|t::q -> let fin=(rajout aCh q) in (string_of_t t)^fin

	(* combi_valide
	 * Permet de savoir si la combinaison est bien dans le dictionnaire, on suppose que la combinaison est ordonnée
	 * @param combi : la combinaison à vérifier
	 * @return bool : OK ?
	 *)
	let (combi_valide : combi -> bool) = fun aCombi ->
		match aCombi with
		|[] -> false
		|_ -> let mot=(rajout "" aCombi) in
			(Dictionnaire.member mot dico)&&(String.length mot > 2)

	(* premier_coup_valide
	 * On veut savoir si le premier coup est jouable
	 * On regarde donc dans un premier temps si les combinaisons sont valides,
	 * Puis on test pour savoir si une combinaison au moins est de longueur plus grande que 6
	 * Enfin on cherche à savoir si toute les combinaisons sortent de la main du joueur ou s'il en a pris sur le plateau, ce qu'il n'a pas le droit de faire 
	 * @param main : La main courante du joueur
	 * @param combi list : les combinaisons que le joueur veut faire
	 * @param main : la main du joueur après "avoir joué"
	 * @return bool : son coup est bon ? il a enfin sorti ?*)
	let (premier_coup_valide : main -> combi list -> main -> bool) = fun aMain aNewCombis aNewMain ->
		(* ajout
		 * met un élément dans un mset avec une seul occurence
		 * @param main : une main d'un joueur
		 * @param t : la tuile à ajouter une fois
		 * @return main : la main après cet ajout*)
		let ajout (mset:main)(lettre:t):main = MultiEnsemble.add mset (lettre,1) in
		(List.fold_left (&&) true (List.map combi_valide aNewCombis)) && 
		((List.fold_left (max) 0 (List.map List.length aNewCombis))>=6) &&
		(MultiEnsemble.equal aMain (List.fold_left (ajout) aNewMain (List.concat aNewCombis)))

	(* points
	 * Cette fonction n'est pas complète !!
	 * Il lui manque le fait de mettre le double de points si le joueur fini sa main
	 * Mais aussi les points de plus pour le mot le plus long qu'il à former et donc qu n'existait pas avant.
	 * Pour le moment on ne compte que le nombre de tuiles posées pendant ce tour
	 * @param combi list : les combinaisons qui sont déjà sur le plateau
	 * @param main : la main du joueur avant sa pose
	 * @param combi list : les combinaisons posées sur la table, après le tour du joueur
	 * @param main : la main finale du joueur courant 
	 * @return int : le nombre de points pour cette pose
	 *)
	let (points : combi list -> main -> combi list -> main -> int) = fun aCombis aMain aNewCombis aNewMain ->
		(MultiEnsemble.cardinal aMain) - (MultiEnsemble.cardinal aNewMain)

	(* points_finaux 
	 * Pour ma part il n'y a pas de points à la fin de la partie si ce n'est des négatifs pour toutes les tuiles non posées
	 * @param main : la main à la fin de la partie
	 * @return int : entier négatif : des points en moins par nombre de tuiles restantes dans la main du joueur à la fin de la partie
	 *)
	let (points_finaux : main -> int) = fun aMain ->
		- (MultiEnsemble.cardinal aMain)

	(* Voici une constante qui correspond au nombre de lettre minimum à avoir dans sa main à chaque tour *)
	let (main_min : int) =
		7

	(* Voici une autre constante correspondante au nombre de lettres de chaque joueur au début du jeu *)
	let (main_initiale : int) =
		14

	(* Cette fonction nous permet de mettre dans un string les valeurs de tuiles du jeu, soit des lettres *)
	let (ecrit_valeur : t -> string) = fun aCarte ->
		string_of_t aCarte

	(* On définie ici une constante qui est fausse car le jeu ne s'arrète pas à la fin de la pioche mais quand la pioche est vide et qu'un joueur fini son tour avec une main vide *)
	let (fin_pioche_vide : bool) =
		false

end
