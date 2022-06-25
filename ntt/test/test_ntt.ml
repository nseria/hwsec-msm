open! Core
module Ntt = Ntts_r_fun.Ntt
module Gf = Ntt.Gf

let%expect_test "bit reversed addressing" =
  let open Hardcaml in
  let x = Array.init 8 ~f:(fun i -> Bits.of_int ~width:3 i) in
  Ntt.bit_reversed_addressing x;
  print_s [%message (x : Bits.t array)];
  [%expect {| (x (000 100 010 110 001 101 011 111)) |}];
  let x = Array.init 8 ~f:(fun i -> Bits.of_int ~width:3 i |> Bits.reverse) in
  Ntt.bit_reversed_addressing x;
  print_s [%message (x : Bits.t array)];
  [%expect {| (x (000 001 010 011 100 101 110 111)) |}]
;;

let of_z z = Gf.of_z (Z.of_string z)

let test input expected =
  Ntt.ntt input;
  let expected = Array.map expected ~f:of_z in
  if not
       ([%compare.equal: Gf.t array]
          (Array.subo input ~len:(Array.length expected))
          expected)
  then print_s [%message (input : Gf.t array) (expected : Gf.t array)]
;;

let linear n =
  Array.init n ~f:(function
      | 0 -> Gf.one
      | 1 -> Gf.two
      | _ -> Gf.zero)
;;

let%expect_test "8pt linear" =
  test
    (linear 8)
    [| "0x0000000000000003"
     ; "0xfffffffefe000002"
     ; "0x0002000000000001"
     ; "0xfffffdff00000202"
     ; "0xffffffff00000000"
     ; "0x0000000002000001"
     ; "0xfffdffff00000002"
     ; "0x000001fffffffe01"
    |];
  [%expect {| |}]
;;

let%expect_test "8pt random" =
  test
    (Array.map
       ~f:of_z
       [| "0xcef967e3e1d0860e"
        ; "0x44be7570bcd4f9df"
        ; "0xf4848ed283e858f2"
        ; "0xa3a3a47eeb6f76f6"
        ; "0xa12d1d0b69c4108b"
        ; "0xeb285d19459ef6c3"
        ; "0x10d812558ad9c103"
        ; "0xd19d3e319d1b6b4a"
       |])
    [| "0x1aaadb56e555836b"
     ; "0x975bcb9d395a282f"
     ; "0x69055db04cf94815"
     ; "0x963cdab11477cc1c"
     ; "0xd05b70dbcf57ddad"
     ; "0xed14bc2fbdc30962"
     ; "0x6c8e69de2cabb133"
     ; "0x9c83c8e1d49cd861"
    |];
  [%expect]
;;

(* let%expect_test "4096pt linear" =
 *   test
 *     (linear 4096)
 *     [| "0x0000000000000003"
 *      ; "0xe586a3342b3bf96c"
 *      ; "0x0ca769003b43919f"
 *      ; "0x28b1a9691a680e3c"
 *      ; "0x3b1e55b017fdb2e4"
 *      ; "0x309d8a339a00ae6a"
 *      ; "0xdc13ebf6fd47c483"
 *      ; "0xc12decfb84bb920e"
 *     |]
 * ;; *)
