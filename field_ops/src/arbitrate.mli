open Hardcaml
open Signal

(** Arbitrate a resource between N items *)
val arbitrate
  :  enable:t
  -> clock:t
  -> clear:t
  -> valid:t
  -> f:(t -> t)
  -> t list
  -> t list

(** Arbitrate a resource between two items *)
val arbitrate2 : enable:t -> clock:t -> clear:t -> valid:t -> f:(t -> t) -> t * t -> t * t
