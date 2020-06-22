#######################################################################################################
# -*- coding:utf-8 -*-
# File: reformat.py
# Update: 2020/05/26
# USAGE: python reformat.py
# Description: None
#######################################################################################################
import os
from PIL import Image

src_path = "/media/lab/data/detection_data/20190101/data"
dst_path = "/media/lab/data/detection_data/20190101/data2"
dir = os.listdir(src_path)

for d in dir:
    print(d)
    if d.split('.')[-1] == 'jpeg':
        name = d.split('.')[0]
#	print('aaaaaaaa')
        im = Image.open(src_path + '/' + d)
        im.save(dst_path + '/' + name + '.jpg')



# import os
# import time
# from PIL import Image
# import cv2

# def alter(path, obj):
#     result = []
#     s = os.listdir(path)
#     count = 1
#     for i in s:
#         name = os.path.join(path,i)
#         img = cv2.imread(name)
#         img = cv2.resize(img, (1280, 1024))
#         listStr = [str(int(time.time())), str(count)]
#         fileName = ''.join(listStr)
#         cv2.imwrite(obj+os.sep+'%s.jpg' % fileName, img)
#         count = count + 1

# alter('/media/lab/data/detection_data/20190101/JPEGImages', '/media/lab/data/detection_data/20190101/data')


# import os, glob
# from PIL import Image

# # path = raw_input("path:")
# path = "/home/bit/darknet/detection_data/Open_Database/ETIS-LaribPolypDB/data"
# # width =int(raw_input("the width U want:"))
# imgslist = glob.glob(path+'/*.*')
# # format = raw_input("format:")
# format = "tif"
# def small_img():
#     for imgs in imgslist:
#         imgspath, ext = os.path.splitext(imgs)
#         img = Image.open(imgs)
#         # (x,y) = img.size
#         # height =int( y * width /x)
#         # small_img =img.resize((width,height),Image.ANTIALIAS)
#         # small_img.save(imgspath +".thumbnail."+format)
#         img.save(imgspath +"and."+format)
#     print("done")

# if __name__ == '__main__':
#     small_img()