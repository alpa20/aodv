BEGIN {
        sendLine = 0;
        recvLine = 0;
        fowardLine = 0;
}
 
$0 ~/^s.* AGT/ {
        sendLine ++ ;
}
 
$0 ~/^r.* AGT/ {
        recvLine ++ ;
}
 
$0 ~/^f.* RTR/ {
        fowardLine ++ ;
}
 
END {
        printf "%.4f \n",(recvLine/sendLine*100);
}