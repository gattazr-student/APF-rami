open Regle

module Jeu = functor (R : REGLE) ->
struct

	(* coup_valide
	 * vérifie si le coup joué est correct et gère le premier coup 
	 * @param R.combi list : tuiles posées sur la table
	 * @param R.main : main du joueur avant d'avoir posé des tuiles
	 * @param R.combi list : nouvelles tuiles posées sur la table en plus des anciennes
	 * @param R.main : nouvelle main du joueur, c'est-à-dire, sa main initiale moins les tuiles posées sur la table
	 * @param bool : le joueur a déjà posé avant ?
	 * @return bool : le coup proposer est correcte ?
	 *)
	let (coup_valide : R.combi list -> R.main -> R.combi list-> R.main-> bool-> bool) = fun aJeu aMain aNewJeu aNewMain aPose ->
		if aPose = false then
			(R.premier_coup_valide aMain aJeu aNewMain)
		else
			(List.fold_left (&&) true (List.map (R.combi_valide) aNewJeu))

	(* remplir_mains
	 * Permet de commencer le jeu avec la main de chaque joueur distrubuée
	 * @param int : le nombre de joueurs
	 * @param int : le nombre d'élément à piocher
	 * @param R.t MultiEnsemble.mset : le paquet de base
	 * @return R.main array : le tableau des mains de chaque joueur
	 * @return R.main : la pioche restante
	 *)
	let (remplir_mains : int -> int -> R.t MultiEnsemble.mset -> R.main array * R.main ) = fun aTaille nbapioche aPaquet ->
		let tab = (Array.make aTaille MultiEnsemble.nil) in
		let pioche = ref aPaquet in
		for i=1 to aTaille do
			for j=1 to nbapioche do
				let (wP, wE) = (MultiEnsemble.getRandom !pioche) in
				pioche := wP;
				tab.(i) <- (MultiEnsemble.add (tab.(i)) (wE,1));
			done;
		done;
		(tab,!pioche)

	(* initialiser
	 * rempli les noms des joueurs, met les scores à 0, distribue les mains, nettoie la table, créer la pioche, personne n'a encore posé, on est au tour 0
	 * @param string list : liste de noms de joueurs
	 * @return R.etat : l'état initil -> on est prèt à jouer
	 *)
	let (initialiser : string list -> R.etat) = fun aChaine ->
		let nb_j = (List.length aChaine) in
		let (wLesMains,wPioche) = (remplir_mains nb_j R.main_initiale R.paquet) in
			{ 	noms = (Array.of_list aChaine);
				scores = (Array.make nb_j 0);
				mains = wLesMains ;
				table = []; 
				pioche = wPioche;
				pose = (Array.make nb_j false);
				tour = 0}

	(* stringToListe
	 * transforme une chaine en une liste de caractères
	 * @param chaine : la string à changer de type
	 * @return char list : la liste correspondante
	 *)
	let (stringToListe : string -> char list ) = fun aChaine ->
		let wL = (String.length aChaine) in
		let l = ref [] in
		let i = ref 0 in
		while (!i <= (wL-1)) do
			l := (!l)@[aChaine.[!i]];
			i := !i + 1;
		done;
		!l

	(* lit_coup
	 * A FINIR
	 * interface avec l'utilisateur
	 * lit un coup de jeu possible
	 * en vérifiant que ce jeu est possible
	 * le joueur peut aussi choisir de piocher
	 * @param string : nom du joueur
	 * @param R.main : sa main 
	 * @param R.combi list : la table
	 * @param bool : boolean pour savoir si le joueur courant a déjà posé
	 * @retrun (R.main*(R.combi list)) option : la main nouvelle du joueur et la nouvelle table
	 *)
	let (lit_coup : string -> R.main -> R.combi list -> bool -> (R.main*(R.combi list)) option ) = fun aNom aJeu aMain aJoue ->
		print_string ("\tLe joueur "^aNom^" doit choisir de jouer (1) ou de piocher (2) :\n") ;
		let choix = ref 0 in
		choix := read_int ();
		while ((!choix != 1)||(!choix != 2)) do
			begin
				print_string ("\tChoix incorrect, que choisissez vous ?\n") ;
				choix := read_int ();
			end
		done;
		None
		(* if (!choix = 1) then
			begin
				print_string ("\tVous avez choisi de jouer.Proposer une combinaison.\n");
				(* Lecture de la combinaison *)
				while not(coup_valide a b c d aJoue) do
					print_string ("\tMerci de rentrer une table valide avec la main que vous possedez !\n");
					(* Lecture de la combinaison *)
				
				(* let wCoups = ref [] and wNMain = ref MultiEnsemble.nil in *)

				(* print_string ("\tQuel mot voulez vous jouer ? (Séparez les R par des espaces)\n");
				let coup_line = read_line() in
				wCoups := stringToListe coup_line;

				print_string ("\tQuel est la nouvelle main?\n");
				let nMain_line = read_line() in
				wNMain := (MultiEnsemble.add !wNMain (stringToListe nMain_line));

				while not (coup_valide aJeu aMain !wCoups !wNMain aJoue) do
					print_string ("\tQuel mot voulez vous jouer ? (Séparez les R par des espaces)\n");
					let coup_line = read_line() in
					wCoups := stringToListe coup_line;

					print_string ("\tQuel est la nouvelle main?\n");
					let nMain_line = read_line() in
					wNMain := stringToListe nMain_line;
				done; *)
			end	
			None
		else
			(* print_string ("\tVous choisissez de ne pas jouer, donc de piocher.\n"); *)
			None *)

	(* joué 
	 * À FAIRE !
	 * doit permettre de jouer 
	 * @param R.etat : état initial ou chargé
	 * @return (string * int)list : la liste des joueurs avec leurs noms en association
	 *)
	let  (joue : R.etat -> (string * int)list) = fun aEtat ->
		[]
		(* ALGO *)
		(* 	tant que la partie n'est pas finie
				lire un coup
				mettre à jour l'état courant
			et aisni de suite pour chaque joueur à chaque tour *)

	(* sauvegarde
	 * À FAIRE !
	 * transforme l'état courant en string pour l'affichage
	 * @param R.etat : état à sauvergarder
	 * @return string : la converstion de l'état suivant la grammaire donnée
	 *)
	let (sauvegarde : R.etat -> string) = fun aEtat ->
		"Not implemented yet"

	(* chargement
	 * À FAIRE ! 
	 * transforme le flux reçu en un état en vérifiant la grammaire
	 * @param char Stream.t : flux extrait du fichier
	 * @retrun R.etat : état lu et complet
	 *)
	let (chargement : char Stream.t -> R.etat) = fun aFlux ->
		{ noms = [||]; scores = [||]; mains = [||]; table = []; pioche = []; pose = [||]; tour = 0}

end
