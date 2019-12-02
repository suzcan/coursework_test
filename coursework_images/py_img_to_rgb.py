import matplotlib.pyplot as plt
import numpy as np
from PIL import Image

img = Image.open('H:/Documents/es3f1/es3f1_camera/coursework_images/group_of_people.jpg')
'''
arr = np.array(img)

i = 0
f = open('H:/Documents/es3f1/es3f1_camera/coursework_images/in_py.txt', 'w')
for v in np.nditer(arr):
    f.write(np.array2string(v))
    f.write(' ')
    i+=1
    if i == 3:
        f.write('\n')
        i = 0

f.close()
'''

pix = img.load()
height = img.height # 1570
width = img.width # 2671

f = open('H:/Documents/es3f1/es3f1_camera/coursework_images/in_py.txt', 'w')

for i in range(width):
    for j in range(height):
        f.write(str(pix[i,j][0]) + " " + str(pix[i,j][1]) + " " + str(pix[i,j][2]) + "\n")

f.close()


print('DONE')