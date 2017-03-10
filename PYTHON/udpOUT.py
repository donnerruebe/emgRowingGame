
import socket
from time import sleep

netaddr=raw_input("NETADDR?:");
netport=raw_input("NETPORT?:");
if(netaddr == ""):
	netaddr="127.0.0.1"

if(netport == ""):
	netport=8239
else:
	netport=int(netport)
	
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM) # UDP

def sendPullstroke(id):
	print "pull send:",id
	sock.sendto("%s"%(id,), (netaddr, netport))


player=("PlayerA","PlayerB","PlayerC","PlayerD")
count=0
while True:
	sendPullstroke(player[count])
	count+=1
	sleep(.2)
	if(count>3):
		count=0
	
