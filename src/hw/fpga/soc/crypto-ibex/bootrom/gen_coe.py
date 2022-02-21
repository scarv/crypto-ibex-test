import io
import sys
import subprocess

binname = str(sys.argv[1])
#binname ='*.bin'
binfile = open(binname, 'rb')
pro_data = binfile.read()
pro_len = int(len(pro_data)/4) #in words
binfile.close()

fileout = str(sys.argv[2])
#fileout ='*.coe'
hfile   = open(fileout, 'w')

hfile.write("memory_initialization_radix=16;\n")
hfile.write("memory_initialization_vector=\n")

pc = 0;
sram_cnt = 0;
for i in range(pro_len):    
    hfile.write("{0:08x} \n".format(int.from_bytes(pro_data[4*i:4*(i+1)], byteorder='little')))

hfile.write("; \n");
hfile.close()

