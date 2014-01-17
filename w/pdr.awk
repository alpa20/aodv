BEGIN {
        sendLine = 0;
        recvLine = 0;
}
 
$0 ~/^s.* AGT/ {
        sendLine ++ ;
}
 
$0 ~/^r.* AGT/ {
        recvLine ++ ;
}

END {
        print (nn," ",(recvLine/sendLine*100),"\n");
}