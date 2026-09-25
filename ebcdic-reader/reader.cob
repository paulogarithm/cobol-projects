       identification division.
       program-id. ebcdic-reader.
       author. pol.

       environment division.
       input-output section.
       file-control.
           select in-file
               assign to "INFILE"
               organization is sequential
               file status is ws-in-file-status.
           select out-file
               assign to "OUTFILE"
               organization is line sequential
               file status is ws-out-file-status.

       data division.
       file section.
       fd  in-file.
       01  in-record.
           02 rec-header           pic XXX.
           02 customer-lastname    pic X(15).  
           02 customer-firstname   pic X(10).
           02 customer-adress      pic X(20).
           02 customer-city        pic X(20).
           02 customer-state       pic X(22).
           02 customer-country     pic X(13).
           02 customer-note        pic X(40).
           02 rec-finishchar       pic X.
       
       fd  out-file.
       01  out-record pic X(255).

       
       working-storage section.
       01  ws-ebcdic-chars pic X(63) value
           X"40" &
           X"818283848586878889" &
           X"919293949596979899" &
           X"A2A3A4A5A6A7A8A9"   &
           X"C1C2C3C4C5C6C7C8C9" &
           X"D1D2D3D4D5D6D7D8D9" &
           X"E2E3E4E5E6E7E8E9"   &
           X"F0F1F2F3F4F5F6F7F8F9".

       01  ws-ascii-chars pic X(63) value
           X"20" &
           "abcdefghijklmnopqrstuvwxyz" &
           "ABCDEFGHIJKLMNOPQRSTUVWXYZ" &
           "0123456789".

       01  ws-out-file-status pic XX.
           88 ws-out-eof value "10".
           88 ws-out-ok value "00".

       01  ws-in-file-status pic XX.
           88 ws-in-eof   value "10".
           88 ws-in-ok    value "00".
       
       procedure division.
           open input in-file.
           if not ws-in-ok
               display "input file not found."
               stop run
           end-if

           open output out-file.
           if not ws-out-ok
               display "output file cannot be created."
               stop run
           end-if

           move "firstname,lastname,adress,city,state,country,note"
                to out-record.
           write out-record.

           perform 1000-read-record
           perform until ws-in-eof
               perform 2000-display-record
               perform 3000-write-record
               perform 1000-read-record
           end-perform
           
           close in-file.
           close out-file.
           goback.

       1000-read-record.
           read in-file into in-record.
           
           inspect in-record
               converting ws-ebcdic-chars to ws-ascii-chars.
       
       2000-display-record.
           display function trim(customer-firstname) " "
                   function trim(customer-lastname).

       3000-write-record.
           move spaces to out-record.
           string
                function trim(customer-firstname) ","
                function trim(customer-lastname) ","
                function trim(customer-adress) ","
                function trim(customer-city) ","
                function trim(customer-state) ","
                function trim(customer-country) ","
                function trim(customer-note)
                delimited by size
                into out-record
           end-string.
           write out-record.

           
