import socket

import time

UDP_IP = "127.0.0.1"
UDP_PORT = 8239

sock = socket.socket(socket.AF_INET, # Internet
                     socket.SOCK_DGRAM) # UDP
sock.bind((UDP_IP, UDP_PORT))

print "UDP LISTENER ON PORT", UDP_PORT

while True:
	ticks = time.time()
	data, addr = sock.recvfrom(1024) # buffer size is 1024 bytes
	print "received message:", data, ticks
