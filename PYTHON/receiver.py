import serial
import socket
 
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM) # UDP

#ser = serial.Serial('COM10')  # open serial port
#teamA = serial.Serial('COM11')  # open serial port
portname=raw_input("COM-PORT?:");
netaddr=raw_input("NETADDR?:");
netport=raw_input("NETPORT?:");
if(netaddr == ""):
	netaddr="127.0.0.1"

if(netport == ""):
	netport=8239
else:
	netport=int(netport)

playerA={'name':'PlayerA','last':0,'avg':0,'thres':120,'value':0,'state':0,'meas':[]}
playerB={'name':'PlayerB','last':0,'avg':0,'thres':120,'value':0,'state':0,'meas':[]}


bit=raw_input("playerconfig?");
if(bit):
	print "ALTERNATIVE first=C, second=D"
	playerA['name']="PlayerC"
	playerB['name']="PlayerD"
	

teamSer = serial.Serial(portname)  # open serial port
print(teamSer.name)         	  # check which port was really used

print "starting on port",netport

def readSerialports():
	ready=False
	count=0

	playerA["meas"]=[]
	playerB["meas"]=[]
	while not ready:
		signal=teamSer.readline()
		#print(signal)
		if(signal[0]=='0'):
			#print("CH0",signal[1:])
			playerA["meas"].append(int(signal[1:]))
		if(signal[0]=='1'):
			#print("CH1",signal[1:])
			playerB["meas"].append(int(signal[1:]))
		count=min(len(playerB["meas"]),len(playerA["meas"]))
		#print count,len(playerB["meas"]),len(playerA["meas"])
		if(count>=10):
			ready = True

def sendPullstroke(id):
	print "pull send:",id
	sock.sendto("%s"%(id,), (netaddr, netport))
		
	'''	
	for i in range(10):
		instr=ser.readline()     		  # write a string
		a,b = instr.split(' ')
		y.append(int(a))
		x.append(int(b))
		#print(input)'''
		

while(True):
	x=[]
	y=[]
	playerA['last']= playerA.get("value",0)
	playerB['last']= playerB.get("value",0)
	
	readSerialports()
	
	playerA['value']= max(playerA['meas'])-min(playerA['meas'])
	playerB['value']= max(playerB['meas'])-min(playerB['meas'])
	
	playerA['avg']= (playerA['avg'] + playerA['value'])/2
	playerB['avg']= (playerB['avg'] + playerB['value'])/2
	
	print("V",playerA['value'],playerB['value'],"a",playerA['avg'],playerB['avg'])
	if(playerA['last']+playerA['thres']<playerA['value']):
		if(playerA['state']==0):
			#print("PULL A")
			sendPullstroke(playerA['name'])
			playerA['state']=1
		  	
	if(playerB['last']+playerB['thres']<playerB['value']):
		if(playerB['state']==0):
			#print("PULL B")
			sendPullstroke(playerB['name'])
			playerB['state']=1

	if(playerA['last']-playerA['thres']>playerA['value']):
		playerA['state']=0
		#print("Release A")
	if(playerB['last']-playerB['thres']>playerB['value']):
		playerB['state']=0
		#print("Release B")


ser.close()             	  # close port
