BEGIN {
	sends=0;
	recvs=0;
	recvs_bytes=0;
	routing_packets=0.0;
	routing_bytes=0;
	droppedBytes=0;
	droppedPackets=0;
	highest_packet_id =0;
	sum=0;
	recvnum=0;
}
   
{
	time = $3;
	packet_id = $47;
   
	# CALCULATE PACKET DELIVERY RATIO
	if (( $1 == "s") &&  ( $35 == "cbr" ) && ( $19=="AGT" )) {  sends++; }
   
	if (( $1 == "r") &&  ( $35 == "cbr" ) && ( $19=="AGT" ))
		{
			recvs++;
			recvs_bytes=recvs_bytes+$37;
		}
   
	# CALCULATE DELAY 
	if ( start_time[packet_id] == 0 )  start_time[packet_id] = time;
	if (( $1 == "r") &&  ( $35 == "cbr" ) && ( $19=="AGT" )) {  end_time[packet_id] = time;  }
		else {  end_time[packet_id] = -1;  }
   
	# CALCULATE TOTAL OVERHEAD 
	if ($1 == "s" && $19 == "RTR" && $35 =="AODV") 
		{
			routing_packets++;
			routing_bytes=routing_bytes+$37;
		}
   
	# DROPPED PACKETS 
	if (( $1 == "d" ) && ( $35 == "cbr" )  && ( $3 > 0 ))
		{
			droppedBytes=droppedBytes+$37;
			droppedPackets=droppedPackets+1;
		}
   
	#find the number of packets in the simulation
	if (packet_id > highest_packet_id)
		highest_packet_id = packet_id;
}
   
END {
	for ( i in end_time )
	{
		start = start_time[i];
		end = end_time[i];
		packet_duration = end - start;
		if ( packet_duration > 0 )  
		{
			sum += packet_duration;
			recvnum++; 
		}
	}
   
	delay=sum/recvnum;
	NRL = routing_bytes/recvs_bytes;  #normalized routing load 
	PDF = (recvs/sends)*100;  #packet delivery ratio[fraction]
	TOH = routing_packets/recvs;
	printf("send = %.2f\n",sends);
	printf("recv = %.2f\n",recvs);
	printf("recvs (bytes) = %d\n",recvs_bytes);
	printf("routingpkts = %.2f\n",routing_packets++);
	printf("routingbytes (bytes) = %d\n",routing_bytes);
	printf("No. of dropped data (packets) = %d\n",droppedPackets);
	printf("No. of dropped data (bytes)   = %d\n",droppedBytes);
	printf("recvnum = %d\n",recvnum);
	printf("PDR = %.2f\n",PDF);
	printf("RAL = %.2f\n",delay*1000); #e-e delay
	printf("TOH = %.2f\n",TOH);
	printf("NRL = %.2f\n",NRL);
	print(nn,"\t",PDF,"\t",TOH,"\t",NRL,"\t",delay*1000) >> "/res" ;
	
}

