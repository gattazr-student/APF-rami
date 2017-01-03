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
val nil : 'e mset

(* add
 * Rajout d'un mElement dans un set
 * @param 'e mset : set à utiliser
 * @param 'e melt : mElement à rajouter au set
 * @return mset : set donnée en paramètres avec en supplément aMElem
 *)
val add : 'e mset -> 'e melt -> 'e mset

(* union
 * produit un set comme étant l'union de deux sets
 * @param 'e mset : set à utiliser
 * @param 'e mset : set à utiliser
 * @return 'e mset : set union des deux sets
 *)
val union : 'e mset -> 'e mset -> 'e mset

(* member
 * retourne le resultat de la recherche d'un element dans un set
 * @param 'e : element à utiliser
 * @param 'e mset : set à utiliser
 * @return bool : true si l'élement est dans le set, false sinon
 *)
val member : 'e -> 'e mset -> bool

(* equal
 * retourne true si les deux sets en paramètres sont égaux, false sinon
 * @param 'e mset : set à utiliser
 * @param 'e mset : set à utiliser
 * @return bool : true si aSet1 est egal à aSet2, false sinon
 *)
val equal : 'e mset -> 'e mset -> bool

(* cardinal
 * retourne le nombre d'elements dans un set
 * @param 'e mset : set à utiliser
 * @return int : nombre d'elements dans le set aSet
 *)
val cardinal : 'e mset -> int

(* remove
 * supprime le mElement dans un set.
 * @param 'e melt : mElement à retirer
 * @param 'e mset : set à utiliser
 * @return 'e mset : multi ensemble donnée en paramètres avec l'élement retiré
 *)
val remove : 'e melt -> 'e mset -> 'e mset

(* getRandom
 * Retourne un élement aléatoire dans un set en le retirant de ce set. Le module Random doit être initialisé
 * avant l'appel à cette fonction.
 * @param 'e mset : set a utiliser
 * @return 'e mset * 'e : couple set passé en paramètre à la fonction avec l'element 'e retiré et un élément
 *)
val getRandom : 'e mset -> ('e mset * 'e)
