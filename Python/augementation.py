#######################################################################################################
# -*- coding:utf-8 -*-
# File: augementation.py
# Update: 2020/05/26
# USAGE: python augementation.py
# Description: None
########################################################################################################


# import packages
from keras.preprocessing.image import ImageDataGenerator, array_to_img, img_to_array, load_img
from PIL import Image
import PIL.Image

datagen = ImageDataGenerator(
        rotation_range=0.2,
        width_shift_range=0.2,
        height_shift_range=0.2,
        shear_range=0.2,
        zoom_range=0.2,
        horizontal_flip=True,
        fill_mode='nearest')

img = load_img('/Users/guo/a.jpg')  # this is a PIL image, please replace to your own file path
x = img_to_array(img)  # this is a Numpy array with shape (3, 150, 150)
x = x.reshape((1,) + x.shape)  # this is a Numpy array with shape (1, 3, 150, 150)

# the .flow() command below generates batches of randomly transformed images
# and saves the results to the `preview/` directory

i = 0
for batch in datagen.flow(x,
						  batch_size=1,
                          save_to_dir='/Users/guo',
                          save_prefix='lena',
                          save_format='jpg'):
    i += 1
    if i > 20:
        break  # otherwise the generator would loop indefinitely
	
# from keras.preprocessing.image import ImageDataGenerator, img_to_array, load_img
# import os


# datagen = ImageDataGenerator(
#     rotation_range=20,
#     width_shift_range=0.15,
#     height_shift_range=0.15,
#     zoom_range=0.15,
#     shear_range=0.2,
#     horizontal_flip=True,
# 	fill_mode='nearest')

# # for i in range(6,11):
# #     img = load_img("pic//generator//{}.png".format(i))
# #     x = img_to_array(img)
# #     print(x.shape)
# #     x = x.reshape((1,) + x.shape)
# #     print(x.shape)
# #     datagen.fit(x)
# #
# #     counter = 0
# #     for batch in datagen.flow(x, batch_size=2 , save_to_dir='pic//generator', save_prefix=str(i), save_format='png'):
# #         counter += 1
# #         if counter > 100:
# #             break  # 否则生成器会退出循环

# dirs = os.listdir("picture")
# print(len(dirs))
# for filename in dirs:
#     img = load_img("picture//{}".format(filename))
#     x = img_to_array(img)
#     # print(x.shape)
#     x = x.reshape((1,) + x.shape) #datagen.flow要求rank为4
#     # print(x.shape)
#     datagen.fit(x)
#     prefix = filename.split('.')[0]
#     print(prefix)
#     counter = 0
#     for batch in datagen.flow(x, batch_size=4 , save_to_dir='generater_pic', save_prefix=prefix, save_format='jpg'):
#         counter += 1
#         if counter > 100:
#             break  # 否则生成器会退出循环
