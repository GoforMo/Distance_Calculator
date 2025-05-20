import math
import sys


with open(sys.argv[1],'w') as fd:
    for i in range(int(sys.argv[2])):
        sqrt_val = int(round(math.sqrt(i)))
        fd.write(f'"{sqrt_val:0{int(sys.argv[3])}b}",  -- sqrt({i:4d}) = {sqrt_val}\n')

fd.close()
        