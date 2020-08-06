#######################################################################################################
# -*- coding:utf-8 -*-
# File: image_format_check.py
# Update: 2020/07/28
# USAGE: none
# Description: 检查文件夹下哪些图片不是标准RGB格式
########################################################################################################
from PIL import Image     
import os       
path = '/Users/lyz/Desktop/dataset/images/' 
for file in os.listdir(path):      
     extension = file.split('.')[-1]
     if extension == 'jpg':
           fileLoc = path+file
           img = Image.open(fileLoc)
           if img.mode != 'RGB':
                 print(file+', '+img.mode)
 