       identification division.
       program-id. succ.

       data division.
       linkage section.
       01  lk-input pic 9(9) comp-3.

       procedure division using by reference lk-input.
           add 1 to lk-input.
           goback.
