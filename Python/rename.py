#######################################################################################################
# -*- coding:utf-8 -*-
# File: rename.py
# Update: 2020/05/26
# USAGE: python rename.py
# Description:  按照路径重命名
########################################################################################################
import os
import time
def changeImgName(path):
    if not os.path.isdir(path) and not os.path.isfile(path):
        return False
    if os.path.isfile(path):
        filePath = os.path.split(path)           #分割出目录与文件
        fileMsg = os.path.splitext(filePath[1]) #分割出文件与文件扩展名
        fileExt = fileMsg[1]                     #取出后缀名(列表切片操作)
        fileName = fileMsg[0]                       #取出文件名
        imgExtList = ['bmp','jpeg','gif','png','jpg','xml','tiff', 'tif'] #常见文件名
        if fileExt.strip('.') in imgExtList:
            # os.rename(path, filePath[0]+os.sep+'sm'+fileName.replace('shm', '')+fileExt) #重命名
            # print(filePath[0] + os.sep + fileName.split('.')[0] + '.' + fileExt.strip('.'))
            # os.rename(path, dst_path + 'val_' + fileName.split('_')[-1] + '.' + fileExt.strip('.'));
            # os.rename(path, filePath[0] + os.sep + '1010_' + str(i) + '.' + fileExt.strip('.'));
            # os.rename(path, dst_path + 'val_' + fileName + '.' + fileExt.strip('.'));
            # new = fileName.replace(':', '_')
            # new = fileName.lstrip('p')
           os.rename(path, dst_path + fileName + '.' + fileExt.strip('.'))
            # os.rename(path, dst_path + new + '.' + fileExt.strip('.'))
    elif os.path.isdir(path):#递归处理
        for x in os.listdir(path):
            changeImgName(os.path.join(path, x)) #os.path.join()路径处理
time.clock()
dst_path = "/home/bit/is/"
changeImgName('/home/bit/darknet/detection_data/Open_Database/ETIS-LaribPolypDB/a')
print('程序运行耗时:%0.2f'%(time.clock()))
print('总共处理了 %s 张图片'%(i))

# import sys, os, time
# from PIL import Image

# dst_dep = 1

# def go(src_path, dep):
#     global f
#     for dirpath, dirnames, filenames in os.walk(src_path):
#         print(dirpath)
#         # print(dirnames, filenames)
#         if dep == dst_dep:
#             name_list = []
#             for f in filenames:
#                 name_list.append(f)
#             name_list.sort()
#             if len(name_list) == 0:
#                 print(dirpath, 0)
#                 name = dirpath.split('.')[0]
#                 name.replace(":", "_")
#                 os.rename(dirpath + name + '.' + 'jpg')
#             else:
#                 print(dirpath, name_list[0])
#                 name = dirpath.split('.')[0]
#                 name.replace(":", "_")
#                 os.rename(dirpath + name + '.' + 'jpg')
#         else:
#             for dir in dirnames:
#                 go(os.path.join(dirpath, dir), dep + 1)

# if __name__ == '__main__':
#     src_path = sys.argv[1]
#     go(src_path, 0)


# import os
# #from PIL import Image

# path_name='/home/lab/Desktop/2/1/'
# #path_name :表示你需要批量改的文件夹

# #pgms = dir('path_name\*jpg')
# #num_pgms = length(pgms)
# #    for i in os.listdir(num_pgms)
# #        var = Image.open('i.jpg')
# #        im.save('i.tiff')
# #        i+ = 1

# i = 1
# for item in os.listdir(path_name):#进入到文件夹内，对每个文件进行循环遍历
#     # os.rename(os.path.join(path_name, item), os.path.join(path_name, '20190913_'+ 'WL'+(str(i)+'.jpg')))#os.path.join(path_name,item)表示找到每个文件的绝对路径并进行拼接操作
#     i+= 1



# import sys, os, time
# from PIL import Image
# def changeImgName(dst_path,changeImgName1):
#     if not os.path.isdir(dst_path) and not os.path.isfile(dst_path):
#         return False
#     if os.path.isfile(dst_path):
#         filePath = os.path.split(dst_path)           #分割出目录与文件
#         print(filePath)
#         temp1 = os.path.splitext(filePath[0])
#         print(temp1)
#         temp2 = temp1[0]
#         print(temp2)
#         temp3 = temp2.split('/')[-1]               #取文件夹名
#         print(temp3)
#         fileMsg = os.path.splitext(filePath[1]) #分割出文件与文件扩展名
#         # print(fileMsg)
#         fileExt = fileMsg[1]                     #取出后缀名(列表切片操作)
#         # print(fileExt)
#         fileName = fileMsg[0]                       #取出文件名
#         # print(fileName)
#         imgExtList = ['bmp','jpeg','gif','png','jpg','xml','tiff','txt','mp4','mov','MTS'] #常见文件名
#         if fileExt.strip('.') in imgExtList:
#             # print(dst_path)
#             # os.rename(path, filePath[0]+os.sep+'sm'+fileName.replace('shm', '')+fileExt) #重命名
#             # print(filePath[0] + os.sep + fileName.split('.')[0] + '.' + fileExt.strip('.'))
#             # os.rename(path, dst_path + 'val_' + fileName.split('_')[-1] + '.' + fileExt.strip('.'));
#             # os.rename(path, filePath[0] + os.sep + '1010_' + str(i) + '.' + fileExt.strip('.'));
#             # os.rename(path, dst_path + 'val_' + fileName + '.' + fileExt.strip('.'))
#             # fileName.replace('cp', '')
#             os.rename(dst_path, changeImgName1 + temp3 + '_' + fileName + 'a' + '.' + fileExt.strip('.'))
#             # os.rename(dst_path, changeImgName1 + '20190426_' +fileName +  '.' + fileExt.strip('.'))
#     elif os.path.isdir(dst_path):#递归处理
#         for x in os.listdir(dst_path):
#             changeImgName(os.path.join(dst_path, x), changeImgName1) #os.path.join()路径处理
# if __name__ == '__main__':
#     changeImgName1= "/media/lab/E2CA6ABFCA6A9019/kkkkkyoto/"
#     dst_path = "/media/lab/E2CA6ABFCA6A9019/Kyoto/"
#     changeImgName(dst_path,changeImgName1)


# import os
# import time
# def changeImgName(path):
#     global i
#     if not os.path.isdir(path) and not os.path.isfile(path):
#         return False
#     if os.path.isfile(path):
#         filePath = os.path.split(path)           #分割出目录与文件
#         fileMsg = os.path.splitext(filePath[1]) #分割出文件与文件扩展名
#         fileExt = fileMsg[1]                     #取出后缀名(列表切片操作)
#         fileName = fileMsg[0]                       #取出文件名
#         imgExtList = ['bmp','jpeg','gif','png','jpg','xml'] #常见文件名
#         if fileExt.strip('.') in imgExtList:
#             # os.rename(path, filePath[0]+os.sep+'sm'+fileName.replace('shm', '')+fileExt) #重命名
#             print(filePath[0] + os.sep + fileName.split('.')[0] + '.' + fileExt.strip('.'))
#             # os.rename(path, dst_path + 'val_' + fileName.split('_')[-1] + '.' + fileExt.strip('.'));
#             # os.rename(path, filePath[0] + os.sep + '1010_' + str(i) + '.' + fileExt.strip('.'));
#             os.rename(path, dst_path + 'val_' + fileName + '.' + fileExt.strip('.'));
# 	        i += 1
#     elif os.path.isdir(path):#递归处理
#         for x in os.listdir(path):
#             changeImgName(os.path.join(path, x)) #os.path.join()路径处理
# time.clock()
# i = 0
# dst_path = "/home/bit/is/"
# changeImgName('/home/bit/darknet/detection_data/Open_Database/ETIS-LaribPolypDB/a')
# print('程序运行耗时:%0.2f'%(time.clock()))
# print('总共处理了 %s 张图片'%(i))

# import sys, os, time
# from PIL import Image

# dst_dep = 2

# def go1(src_path, dep):
#     for rt, dirs, files in os.walk(src_path):
#         if dep == dst_dep:
#             for f in files:
#                 nf = f.replace(':', '_')
#                 #print(nf)
#                 os.rename(os.path.join(rt, f), os.path.join(rt, nf))
#         else:
#             for d in dirs:
#                 go1(os.path.join(rt, d), dep + 1)

# def go(src_path, dep):
#     global f
#     for dirpath, dirnames, filenames in os.walk(src_path):
#         if dep == dst_dep:
#             name_list = []
#             for f in filenames:
#                 name_list.append(f)
#             name_list.sort()
#             if len(name_list) == 0:
#                 print(dirpath, 0)
#                 name = dirpath.split('.')[0]
#                 name.replace(":", "_")
#                 os.rename(dirpath + name + '.' + 'jpg')
#             else:
#                 print(dirpath, name_list[0])
#                 name = dirpath.split('.')[0]
#                 name.replace(":", "_")
#                 os.rename(dirpath + name + '.' + 'jpg')
#         else:
#             for dir in dirnames:
#                 go(os.path.join(dirpath, dir), dep + 1)

# if __name__ == '__main__':
#     src_path = sys.argv[1]
#     go1(src_path, 0)


# import os
# #from PIL import Image

# path_name = '/home/lab/Desktop/JPEGImages'
# # path_name = '/home/lab/Desktop/Annotations'
# change_name = '/home/lab/Desktop/BLI'
# #path_name :表示你需要批量改的文件夹

# #pgms = dir('path_name\*jpg')
# #num_pgms = length(pgms)
# #    for i in os.listdir(num_pgms)
# #        var = Image.open('i.jpg')
# #        im.save('i.tiff')
# #        i+ = 1

# i = 1
# for item in os.listdir(path_name):#进入到文件夹内，对每个文件进行循环遍历
#     name_list = []
#     for f in item:
#         name_list.append(f)
#     name_list.sort()
#     os.rename(os.path.join(path_name, item), os.path.join(change_name, (str(i)+'.jpg')))#os.path.join(path_name,item)表示找到每个文件的绝对路径并进行拼接操作
#     i+= 1
