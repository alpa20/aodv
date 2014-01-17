
set val(chan)           Channel/WirelessChannel    ;#Channel Type
set val(prop)           Propagation/TwoRayGround   ;# radio-propagation model
set val(netif)          Phy/WirelessPhy            ;# network interface type
set val(mac)            Mac/802_11				   ;# MAC type , ou bien "Simple"
set val(ifq)            Queue/DropTail/PriQueue    ;# interface queue type
set val(ll)             LL                         ;# link layer type
set val(ant)            Antenna/OmniAntenna        ;# antenna model
set val(ifqlen)         50                         ;# max packet in ifq

if {$argc == 3} {
	 set val(nn)      [lindex $argv 0]     ;# number of mobile nodes
	 set val(mc)      [lindex $argv 1]     ;# max number of connexions
	 set val(sd)      [lindex $argv 2]     ;# seed choisi
	 #set val(nn)     [expr [lindex $argv 0]]     ;# number of mobile nodes
	 #set val(nn)     [expr {$val(nn) - 1}]     ;# number of mobile nodes
	
} else {
	puts "Un ou plusieurs arguments sont manquants...."
	puts "Exiting ...................."
	exit 0
}

# routing protocol
#set val(rp)             DumbAgent  
#set val(rp)             DSDV                     
#set val(rp)             DSR                      
set val(rp)             AODV                     

set val(x)		500
set val(y)		500

# Initialize Global Variables
set ns_		[new Simulator]

$ns_ use-newtrace

set tracefd     [open wireless-simple-mac.tr w]
$ns_ trace-all $tracefd

set namtrace [open wireless-simple-mac.nam w]
$ns_ namtrace-all-wireless $namtrace $val(x) $val(y)

# set up topography object
set topo       [new Topography]

$topo load_flatgrid $val(x) $val(y)

# Create God
create-god $val(nn)

# Create channel
set chan_ [new $val(chan)]

# Create node(0) and node(1)

# configure node, please note the change below.
$ns_ node-config -adhocRouting $val(rp) \
		-llType $val(ll) \
		-macType $val(mac) \
		-ifqType $val(ifq) \
		-ifqLen $val(ifqlen) \
		-antType $val(ant) \
		-propType $val(prop) \
		-phyType $val(netif) \
		-topoInstance $topo \
		-agentTrace ON \
		-routerTrace ON \
		-macTrace ON \
		-movementTrace ON \
		-channel $chan_

for {set i 0} {$i < $val(nn)} {incr i} {
    set node_($i) [$ns_ node]
    $node_($i) random-motion 0
    $ns_ initial_node_pos $node_($i) 20
}

set god_ [God instance]

exec E:/cygwin/home/Noureddine/ns-allinone-2.35-RC7/ns-2.35/indep-utils/cmu-scen-gen/setdest/setdest  -v 1 -n $val(nn) -p 0.0 -M 20.0 -t 20 -x 500 -y 500 > mvt$val(nn)

source "mvt$val(nn)"

set mvt "mvt$val(nn)"

exec ns E:/cygwin/home/Noureddine/ns-allinone-2.35-RC7/ns-2.35/indep-utils/cmu-scen-gen/cbrgen.tcl -type cbr -nn [expr {$val(nn) - 1}] -seed $val(sd) -mc $val(mc) -rate 2.0 > traffic$val(mc)

source "traffic$val(mc)"

#
# Tell nodes when the simulation ends
#
for {set i 0} {$i < $val(nn) } {incr i} {
    $ns_ at 150.0 "$node_($i) reset";
}
$ns_ at 150.0 "stop"
$ns_ at 150.01 "puts \"NS EXITING...\" ; $ns_ halt"
proc stop {} {
    global ns_ tracefd mvt
    $ns_ flush-trace
    close $tracefd
    
	#exec nam wireless-simple-mac.nam & 
    exit 0
}

# Run Simulation 

puts "Starting Simulation..."
$ns_ run
