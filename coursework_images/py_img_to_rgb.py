import matplotlib.pyplot as plt
import numpy as np
from PIL import Image

img = Image.open('H:/Documents/es3f1/es3f1_camera/coursework_images/group_of_people.jpg')
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

plt.imsave('H:/Documents/es3f1/es3f1_camera/coursework_images/test_py.jpg', img)
print('DONE')