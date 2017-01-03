(*
 * mElement
 * un element et un entier représentant le nombre de fois que cet element est présent
 *)
type 'e melt = 'e * int

(*
 * multi ensemble
 * Il s'agit d'un liste de mElement
 *)
type 'e mset = 'e melt list

(*
 * multi ensemble vide
 *)
let (nil : 'e mset) = []

(* add
 * Rajout d'un mElement dans un set
 * @param 'e mset : set à utiliser
 * @param 'e melt : mElement à rajouter au set
 * @return mset : set donnée en paramètres avec en supplément aMElem
 *)
let rec (add : 'e mset -> 'e melt -> 'e mset) = fun aSet aMElem ->
	let (wElem, wOccur) = aMElem in
	match aSet with
	| [] -> [aMElem]
	| (wE, wO)::wQ -> if (wE = wElem) then
						(wE,wO+wOccur)::wQ
					else
						(wE,wO)::(add wQ aMElem)

(* union
 * produit un set comme étant l'union de deux sets
 * @param 'e mset : set à utiliser
 * @param 'e mset : set à utiliser
 * @return 'e mset : set union des deux sets
 *)
let (union : 'e mset -> 'e mset -> 'e mset) = fun aSet1 aSet2 ->
	(List.fold_left add aSet1 aSet2)

(* member
 * retourne le resultat de la recherche d'un element dans un set
 * @param 'e : element à utiliser
 * @param 'e mset : set à utiliser
 * @return bool : true si l'élement est dans le set, false sinon
 *)
let rec (member : 'e -> 'e mset -> bool) = fun aElem aSet ->
	match aSet with
	| [] -> false
	| (wE, wO)::q -> if wE = aElem then
						true
					else
						(member aElem q)

(* getNbOccurences
 * retourne le nombre d'occurence d'un element dans un set
 * @param 'e : element à utiliser
 * @param 'e mset : set à utiliser
 * @return int : nom d'occurence de l'element dans le set
 *)
let rec (getNbOccurences : 'e -> 'e mset -> int) = fun aElem aSet ->
	match aSet with
	| [] -> 0
	| (wE, wO)::q -> if wE = aElem then
						wO
					else
						(getNbOccurences aElem q)
(* subset
 * retourne true si le premier set donné en paramètre est un sous ensemble du second, false sinon
 * @param 'e mset : set à utiliser
 * @param 'e mset : set à utiliser
 * @return bool : true si aSet1 sous ensemble de aSet2, false sinon
 *)
let rec (subset : 'e mset -> 'e mset -> bool ) = fun aSet1 aSet2 ->
	match aSet1 with
	| [] -> true
	| (wE,wO)::q -> if (member wE aSet2) && wO <= (getNbOccurences wE aSet2) then
						subset q aSet2
					else
						false

(* equal
 * retourne true si les deux sets en paramètres sont égaux, false sinon
 * @param 'e mset : set à utiliser
 * @param 'e mset : set à utiliser
 * @return bool : true si aSet1 est egal à aSet2, false sinon
 *)
let rec (equal : 'e mset -> 'e mset -> bool) = fun aSet1 aSet2 ->
	(subset aSet1 aSet2) && (subset aSet2 aSet1)

(* cardinal
 * retourne le nombre d'elements dans un set
 * @param 'e mset : set à utiliser
 * @return int : nombre d'elements dans le set aSet
 *)
let (cardinal : 'e mset -> int) = fun aSet ->
	let (f : int -> 'e melt -> int) = fun aInt aMElem ->
		let (wE, wO) = aMElem in wO + aInt
	in
	(List.fold_left f 0 aSet)

(* remove
 * supprime le mElement dans un set.
 * @param 'e melt : mElement à retirer
 * @param 'e mset : set à utiliser
 * @return 'e mset : multi ensemble donnée en paramètres avec l'élement retiré
 *)
let rec (remove : 'e melt -> 'e mset -> 'e mset ) = fun aMElem aSet ->
	let (wElem, wOccur) = aMElem in
	if wOccur > 0 then
		match aSet with
		| [] -> []
		| (wE,wO)::q -> if wE = wElem then
							if wOccur < wO then	(wE, wO - wOccur)::q
							else q
						else (wE,wO)::(remove aMElem q)
	else
		aSet

(* get
 * Retourne l'élement se trouvant à l'index i du mset
 * @param int : index de l'élement à retourner
 * @param 'e mset : set à utiliser
 * @return 'e : élement retourné
 *)
let rec (get: int -> 'e mset -> 'e) = fun aIndex aSet ->
	match (aIndex, aSet) with
	| (0, (wE, wO)::wQ) -> wE
	| (wN, (wE, wO)::wQ) -> if (wO -1 >= 0) then (get (wN-1) ((wE, (wO-1))::wQ)) else (get wN wQ)
	| (_, nil) -> failwith "Error"

(* getRandom
 * Retourne un élement aléatoire dans un set en le retirant de ce set. Le module Random doit être initialisé
 * avant l'appel à cette fonction.
 * @param 'e mset : set a utiliser
 * @return 'e mset * 'e : couple set passé en paramètre à la fonction avec l'element 'e retiré et un élément
 *)
let (getRandom: 'e mset -> 'e mset * 'e) = fun aSet ->
	let wE = get (Random.int ((cardinal aSet)+1)) aSet in
		((remove (wE,1) aSet) ,wE)
