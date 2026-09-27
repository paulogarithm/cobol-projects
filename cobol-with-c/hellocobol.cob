       identification division.
       program-id.     hellocobol.
       
       data division.
       working-storage section.
       01  ws-variable pic 9(9) value 0 comp-3.

       procedure division.
           move 1 to ws-variable.
           add 1 to ws-variable.
           compute ws-variable = ws-variable * 2.
           multiply ws-variable by 2 giving ws-variable.
           display ws-variable.

           call "max"
               using by value ws-variable 10
               returning ws-variable.

           call "display_number"
               using by value ws-variable.

           call "succ" using by reference ws-variable.

           display ws-variable.
           goback.
