import numpy as np
from PIL import Image
import sys

filename = sys.argv[1]
im = Image.open(filename)
data = np.array(im)

r1, g1, b1 = 0, 0, 0 # Original value
r2, g2, b2 = 0, 0, 1 # Value that we want to replace it with

red, green, blue = data[:,:,0], data[:,:,1], data[:,:,2]
mask = (red == r1) & (green == g1) & (blue == b1)
data[:,:,:3][mask] = [r2, g2, b2]

im = Image.fromarray(data)
im.save(filename)