(** Multistage pipelined ripple-carry-adder (or subtractor).
 *
 * This module computs [a `op1` b `op2` c `op3` d...], where each of the ops
 * are either (+) or (-) (they don't have to be the same). The output of the
 * module will contain all the results and carries of the following:
 *
 * - a `op1` b
 * - a `op1` b `op2` c
 * - a `op1` b `op2` c `op3` d
 * - ...
 *
 * The generated architecture for a single pipeline stage for summing 3 numbers
 * looks something like the following:
 *
 * > LUT > CARRY8 > LUT > CARRY8
 *           ^              ^
 * > LUT > CARRY8 > LUT > CARRY8
 *           ^              ^
 * > LUT > CARRY8 > LUT > CARRY8
 *           ^              ^
 * > LUT > CARRY8 > LUT > CARRY8
 *
 * This architecture have a different CARRY8 output for every add operation.
 * This ensures that the carry-chain have a carry-in input can be used
 * appropriately across multiple pipeline stages
*)

open Hardcaml

(** Output from performing a single [a `op1` b] step. *)
module Single_op_output : sig
  type 'a t =
    { result : 'a
    ; carry : 'a
    }
  [@@deriving fields]
end

module Term_and_op : sig
  type 'a t =
    { op : [ `Add | `Sub ]
    ; term : 'a
    }
end

module Input : sig
  type 'a t =
    { lhs : 'a
    ; rhs_list : 'a Term_and_op.t list
    }
end

(** Instantiate a hierarchical pipelined adder/subtractor chain. *)
val hierarchical
  :  ?name:string
  -> ?instance:string
  -> stages:int
  -> scope:Scope.t
  -> enable:Signal.t
  -> clock:Signal.t
  -> Signal.t Input.t
  -> Signal.t Single_op_output.t list

(** Similar to [hierarchical], but without hierarchy. *)
val create
  :  (module Comb.S with type t = 'a)
  -> stages:int
  -> pipe:(n:int -> 'a -> 'a)
  -> 'a Input.t
  -> 'a Single_op_output.t list
