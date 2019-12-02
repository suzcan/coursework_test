import matplotlib.pyplot as plt
import numpy as np
from PIL import Image
import re

f = open('H:/Documents/es3f1/es3f1_camera/coursework_images/in_py.txt', 'r')

contents = f.readlines()
height = 1570
width = 2671
i = 0 # width
j = 0 # height

pixels =  [[0 for x in range(width)] for y in range(height)]

for line in contents:
    if i == 1570:
        j+=1
        i = 0
    pixels[i][j]


f.close()

array = np.array(pixels, dtype=np.uint8)
new_img = Image.fromarray(array)

new_img.save('H:/Documents/es3f1/es3f1_camera/coursework_images/test_py.jpg')

print('DONE')