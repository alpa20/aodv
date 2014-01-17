
foreach {v1 v2} $argv {}


set val(chan)       Channel/WirelessChannel  ;# Type of Channel to be used 
set val(prop)       Propagation/TwoRayGround ;# Propagation Model 
set val(netif)      Phy/WirelessPhy   ;# Network Interface Type 
set val(mac)        Mac/802_11    ;# MAC layer Standard 

set val(ll)         LL 
set val(ant)        Antenna/OmniAntenna  ;# Type of Antenna 

set val(ifq)        Queue/DropTail/PriQueue  ;# Type of Queue 
set val(ifqlen)         50                ;# Maximum Packets in IFQ Queue 
set val(seed)           0.1

set val(x)              500       ;# X dimension of the topography 
set val(y)              500       ;# Y dimension of the topography 
set val(nn)             $v1                 ;# Total number of nodes simulated 
set nnn 			    [expr {$v1 - 1}]

set val(adhocRouting)    AODV   ;# Protocol for Simulation 


;#  Mobility Model File Path 
set val(stop)             150.0    ;# Simulation time 



exec ns E:/cygwin/home/Noureddine/ns-allinone-2.35-RC7/ns-2.35/indep-utils/cmu-scen-gen/cbrgen.tcl -type cbr -nn $nnn -seed 1.2 -mc $v2 -rate 0.000125 > cp1

exec E:/cygwin/home/Noureddine/ns-allinone-2.35-RC7/ns-2.35/indep-utils/cmu-scen-gen/setdest/setdest  -n $v1 -p 0   -M 10 -t $val(stop) -x $val(x) -y $val(y) > sc1



set val(cp)  "cp1" 
set val(sc)  "sc1"

# Where to Store Output 

set val(tr)  "cp1sc1.tr" 
set val(na)  "cp1sc1.nam" 


# =============================================================== 
# Main Program 
# =============================================================== 
# Initialize Global Variables 

set ns_  [new Simulator]   ;# create simulator instance 
set topo [new Topography]   ;# setup topography object 
set tracefd  [open $val(tr) w]   ;# create trace object for ns and nam 
set namtrace    [open $val(na) w] 

$ns_ trace-all $tracefd 
$ns_ use-newtrace 
$ns_ namtrace-all-wireless $namtrace $val(x) $val(y) 

# define topology 
$topo load_flatgrid $val(x) $val(y) 

set god_ [create-god $val(nn)]   ; # Create God 

#global node setting 
$ns_ node-config  -adhocRouting $val(adhocRouting)  -llType $val(ll) -macType $val(mac) -ifqType $val(ifq) -ifqLen $val(ifqlen) -antType $val(ant) -propType $val(prop) -phyType $val(netif)  -channelType $val(chan)  -topoInstance $topo -agentTrace ON  -routerTrace OFF  -macTrace OFF 

for {set i 0} {$i < $val(nn) } {incr i} { 

 set node_($i) [$ns_ node]  ;#  Create the specified number of nodes 
 $node_($i) random-motion 0  ;# disable random motion 

} 

 # Define node movement model 

puts "Loading connection pattern..." 
source $val(cp)    ;# Loading Connection pattern File defined 


# Define traffic model 

puts "Loading scenario file..." 
source $val(sc)    ;# Loading Movement model file 


# Define node initial position in nam 

for {set i 0} {$i < $val(nn)} {incr i} { 

    $ns_ initial_node_pos $node_($i) 20 

} 

# Tell nodes when the simulation ends 

for {set i 0} {$i < $val(nn) } {incr i} { 

    $ns_ at $val(stop).0 "$node_($i) reset"; 

} 



# ending nam and the simulation  
$ns_ at $val(stop) "$ns_ nam-end-wireless $val(stop)" 
$ns_ at $val(stop) "stop" 
$ns_ at 150.01 "puts \"end simulation\" ; $ns_ halt"

proc stop {} { 
    global ns_ tracefd namtrace 
    $ns_ flush-trace 
    close $tracefd 
    close $namtrace 

puts "Starting hhhhhhhh Simulation..." 

    #Execute nam on the trace file 
    exec nam cp1sc1.nam & 
    exit 0 
} 
 


# Run Simulation 

puts "Starting Simulation..." 
$ns_ run 

