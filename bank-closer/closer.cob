       identification division.
       program-id. closer.

       environment division.
       input-output section.
       file-control.
           select fs-account-file
               assign to "MASTERS"
               organization is line sequential
               file status is ws-master-status.
           
           select fs-movement-file
               assign to "MOVEMENTS"
               organization is line sequential
               file status is ws-movement-status.
           
           select fs-output-file
               assign to "RESULT"
               organization is line sequential
               file status is ws-output-status.

       data division.
       file section.
       fd  fs-account-file.
       01  fs-account-record.
           05  acc-number      pic 9(10).
           05  acc-lastname    pic X(10).
           05  acc-firstname   pic X(10).
           05  acc-money       pic S9(11)V99.
       
       fd  fs-movement-file.
       01  fs-movement-record.
           05  mov-acc-number  pic 9(10).
           05  mov-type        pic X.
           05  mov-money       pic S9(8)V99.
           05  mov-description pic X(20).
       
       fd  fs-output-file.
       01  fs-output-record    pic X(255).

       working-storage section.
       01  ws-master-status    pic XX.
           88  ws-master-eof   value "10".
           88  ws-master-ok    value "00".
       
       01  ws-movement-status  pic XX.
           88  ws-movement-eof value "10".
           88  ws-movement-ok  value "00".
       
       01  ws-output-status    pic XX.

       01  ws-formatted        pic -(11)9.99.

       01  ws-total-credit     pic s9(11)v99.
       01  ws-total-debit      pic s9(11)v99.
       01  ws-total-money      pic s9(11)v99.

       procedure division.
           open input fs-account-file.
           open input fs-movement-file.
           open output fs-output-file.

           perform 4000-write-header.
           perform 1000-account-parsing.
           perform 1500-movement-parsing.

           perform until ws-master-eof
               perform 4500-write-account-header
               perform until mov-acc-number not = acc-number
                           or ws-movement-eof
                   perform 2000-apply-movement-to-account
                   perform 1500-movement-parsing
               end-perform
               perform 2500-apply-money-change
               perform 1000-account-parsing
           end-perform.
           perform 4950-write-conclusion.

           close fs-output-file.
           close fs-account-file.
           close fs-movement-file.
           goback.
       
      *    Parsing

       1000-account-parsing.
           read fs-account-file into fs-account-record.
       
       1500-movement-parsing.
           read fs-movement-file into fs-movement-record.
       
      *    Money changes

       2000-apply-movement-to-account.
           if mov-type = "D" then
               add mov-money to ws-total-debit
               compute mov-money = - mov-money
           else
               add mov-money to ws-total-credit
           end-if.
           add mov-money to acc-money.
           perform 4800-write-instruction.
       
       2500-apply-money-change.
           add acc-money to ws-total-money.
           perform 4900-write-footer.
      
      *    Writing
       
       4000-write-header.
           move spaces to fs-output-record.
           move "RAPPORT DE CLOTURE JOURNALIERE" to fs-output-record.
           write fs-output-record.
           move spaces to fs-output-record.
           write fs-output-record.
       
       4500-write-account-header.
           move spaces to fs-output-record.
           string
               "COMPTE "
               acc-number " "
               function trim(acc-lastname) " "
               function trim(acc-firstname)
               delimited by size
               into fs-output-record
           end-string.
           write fs-output-record.

           move spaces to fs-output-record.
           move acc-money to ws-formatted.
           string
               "    Solde initial:         "
               ws-formatted
               delimited by size
               into fs-output-record
           end-string.
           write fs-output-record.
       
       4800-write-instruction.
           move spaces to fs-output-record.
           move mov-money to ws-formatted.
           string
               "    "
               mov-type
               "  "
               mov-description
               ws-formatted
               delimited by size
               into fs-output-record
           end-string.
           write fs-output-record.
       
       4900-write-footer.
           move spaces to fs-output-record.
           move acc-money to ws-formatted.
           string
               "    Solde finale:          "
               ws-formatted
               delimited by size
               into fs-output-record
           end-string.
           write fs-output-record.
           move spaces to fs-output-record.
           write fs-output-record.

       4950-write-conclusion.
           move spaces to fs-output-record.
           move ws-total-debit to ws-formatted.
           string
               "TOTAL MOUVEMENTS DEBIT:  "
               ws-formatted
               delimited by size
               into fs-output-record
           end-string.
           write fs-output-record.

           move spaces to fs-output-record.
           move ws-total-credit to ws-formatted.
           string
               "TOTAL MOUVEMENTS CREDIT: "
               ws-formatted
               delimited by size
               into fs-output-record
           end-string.
           write fs-output-record.

           move spaces to fs-output-record.
           move ws-total-money to ws-formatted.
           string
               "TOTAL GENERAL SOLDES:    "
               ws-formatted
               delimited by size
               into fs-output-record
           end-string.
           write fs-output-record.
