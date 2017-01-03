# Projet APF - Rami

par Jules HABLOT, Anna BRUEL et Rémi GATTTAZ

Ce fichier est un fichier markdown. Pour une meilleur lisibilité de ce Readme, nous vous conseillons donc de le transformer en html.

## Le Projet
Le rami est un jeu à plusieurs variantes. C'est à dire qu'il existe plusieurs version du jeu du rami, possédant chacun des spécificité mais avec tout de même une base commune. Le but de ce projet a donc été d'implémenter des modules afin de pouvoir obtenir plusieurs variantes du jeu du rami.

## Liste des fonctionalités
Pendant notre développement, nous avons crées des fichiers de tests. Nommés tests_*, ils sont compilé avec la commande ```make test```.


### Module multi-ensembles
Le module multi-ensemble définit les structures de donnée mset et melt ainsi que toutes les fonctions qui ont été supposé nécéssaires afin de gérer ces structures. Les fonctions suivantes ont été écrites et testés :
- add
- union
- member
- equal
- cardinal
- remove
- getRandom

Toutes ces fonctions fonctionnent correctement. Le fichier de test lié à ce module est tests_me.

### Module dictionnaire
Le module dictionnaire définit la structure de donnée dico. Les dicos sont utilisés pour le jeu du rami des lettres afin de vérifier que les mots joués appartiennent bien aux dictionnaires français. Les fonctions suivantes ont été écrites et testés :
- dico_vide
- member
- add
- remove
- of_stream
- to_list

Etant donnée que le dictionnaire qui nous a été fournis à 336531 lignes, nous avons tentés d'optimiser certaines fonctions. Surtout au niveau de l'espace mémoire utilisé. Dans cet optique, nous avons donc utilisé des fonctions telle que List.rev_append plutot que @.

Aussi, nous avons modifié légèrement la spécification qui nous avais été donnée. En effet, dans la version qui nous avait été founis, dico_vide n'était pas une fonction. Afin de pouvoir récupérér à n'importe quel moment un dictionnaire vide, nous avons donc défini dico_vide comme étant une fonction.

Toutes ces fonctions fonctionnent correctement. Le fichier de test lié à ce module est tests_dico.

### Sauvegarde et lecture depuis un fichier
Etant donnée que la sauvegarde et le relecture d'une partie est un module qui peut être fait plus tard, nous avons mis de coté de module au début du projet. N'ayant pas eu le temps de finir le projet, il n'a donc pas été implémenté du tout.

### Le rami des lettres
Le module lettre dans rami.ml définit les règles du rami. Les fonctions suivantes ont été écrites et testés :
- paquet qui définit les lettres de l'alphabet ainsi que le nombre total de chacune des lettres dans le jeu, ainsi que 2 jokers '*'
- combi_valide vérifie si le mot est dans le dictionnaire.
	- string_of_t convertit une lettre en string
	- rajout convertit une liste de lettres en string 
- premier_coup_valide qui vérifie si le premier coup joué est correct. Les combinaisons de lettres doivent être valides, être au moins de longueur 6 et que les lettres de la combinison proviennent seulement de la main du joueur.
	- utilise combi_valide.
- points compte les points quand un mot ou une combinaison de lettre valide est posé. Il lui manque le fait de mettre le double de points si le joueur fini sa main.
- points_finaux calcule le nombre de lettres restantes dans la dernière main et les mets en négatif.
- main_min renvoie 7. C'est le nombre minimum de lettres que l'on peut avoir dans une main
- main_initiale renvoie 14. C'est le nombre de lettres que le joueur a dans sa main initialement.
- ecrit_valeur. "Non implémenté"
- fin_pioche_vide renvoie false car le jeu ne s'arrète pas à la fin de la pioche mais il s'arrête quand la pioche est vide et qu'un joueur fini son tour avec une main vide.

### Rummikub
Le module Tuiles dans Rummikub.ml définit les règles du Rummikub. Les fonctions suivantes ont été écrites et testés :
- paquet qui initiatise les tuiles. Il y a 104 tuiles en tout. Chaque tuile est en double, numérotée de 1 à 13 de couleur Bleu ou Jaune ou Noir ou Rouge. 
- combi_valide qui vérifie soit combi_couleur ou soit combi_suite
	- combi_couleur vérifie si une combinaison d'au moins 3 tuiles de couleurs distinctes et comportent le même entier 
	- combi_suite vérifie si une combinaison monochrome d'au moins 3 tuiles sont consécutifs
- premier_coup_valide qui vérifie si le premier coup joué est correct, c'est-à-dire les combinaisons posées font 30 points au minimum et sont valides
	- utilise suite_combi_point qui compte les points de la liste de plusieurs combinaisons
		- utilise combi_point qui compte les points d'une combinaison
	- suite_combi_valide qui vérifie si la liste de plusieurs combinaisons est valides
		- utilise combi_valide 
- points qui donne les points marqués sur un coup. Dans le rummikub, les points sont comptés à la fin de partie
- points_finaux renvoie les points des tuiles restantes de la dernière main
- main_min renvoie 0. C'est le nombre minimum de tuiles que l'on peut avoir dans une main
- main_initiale renvoie 14. C'est le nombre de tuiles que le joueur a dans sa main initialement.
- ecrit_valeur. "Non implémenté"
- fin_pioche_vide renvoie true car la pioche est vide à la fin.

### Jouer
Le foncteur jeu dans jeu.ml décrit le déroulement du jeu lors du rami ou du rummikud. Il est composé des fonctions suivantes :
- coup_valide vérifie si le coup joué est correct et gère le premier coup 
- remplir_mains permet de commencer le jeu avec la main de chaque joueur distrubuée
- initialiser met les noms des joueurs, met les scores à 0, distribue les mains, nettoie la table, créé la pioche, personne n'a encore posé, on est au tour 0
- stringToListe convertit une chaîne de caractères en liste de caractères
- lit_coup demande à l'utilisateur de piocher ou de jouer (fonction non terminée)
- joue, sauvegarde et chargement ne sont pas implémentées
 
## Aides
Nous avons eu beaucoup de mal a obtenir un makefile nous permettant de compiler ce programme. Après avoir échangé quelque mails avec M Mounier, nous avons demandé à M Mounier si nous pouvions le rencontre afin de lui poser toutes nos questions lors d'une rencontre. Ayant accepté, nous avons donc pu discuté avec lui de nos problèmes de compilations que nous avons pu résoudre peu après.


## Comment utiliser ce programme

Nous pensons mettre en place un système permettant de mettre un argument ou deux lors de l'appel de l'exécutable :
le premier argument serai le fichier dans lequel on sauvegarderai la partie si demandé au cours du jeu
le deuxième serai facultaif et permettrait, s'il est présent, de charger la partie à partir de ce fichier
Sinon il suffit de suivre les instructions afficher à la console, ne pas hésiter à faire des copié-collé

### Compiler
Etant donné qu'un makefile est présent, pour créer les éxécutables de ce programme, il suffit de lancer la commande ```make``` en étant dans le dossier source.

La commande va créer deux éxécutables : rummikub et rami. Il s'agit respectivement des éxécutables permettant de lancer le jeu du rummikub et le jeu du rami.

### Tester
Nous avons définis dans le makefile une target test. Aussi, lorsque la commande ```make test``` est utilisée, un ensemble d'éxécutables nommés test_* sont crées. Ces fichiers nous ont permis de tester nos modules au fur et à mesure du développement.
