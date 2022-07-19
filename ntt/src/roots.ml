open Base

let inverse =
  [| "1"
   ; "18446744069414584320"
   ; "281474976710656"
   ; "18446744069397807105"
   ; "17293822564807737345"
   ; "70368744161280"
   ; "549755813888"
   ; "17870292113338400769"
   ; "13797081185216407910"
   ; "1803076106186727246"
   ; "11353340290879379826"
   ; "455906449640507599"
   ; "17492915097719143606"
   ; "1532612707718625687"
   ; "16207902636198568418"
   ; "17776499369601055404"
   ; "6115771955107415310"
   ; "12380578893860276750"
   ; "9306717745644682924"
   ; "18146160046829613826"
   ; "3511170319078647661"
   ; "17654865857378133588"
   ; "5416168637041100469"
   ; "16905767614792059275"
   ; "9713644485405565297"
   ; "5456943929260765144"
   ; "17096174751763063430"
   ; "1213594585890690845"
   ; "6414415596519834757"
   ; "16116352524544190054"
   ; "9123114210336311365"
   ; "4614640910117430873"
   ; "1753635133440165772"
  |]
  |> Array.map ~f:(fun const -> Z.of_string const |> Gf_z.of_z)
;;

let forward = Array.map inverse ~f:Gf_z.inverse
