#######################################################################################################
# -*- coding:utf-8 -*-
# File: compare_name.py
# Update: 2020/05/26
# USAGE: python compare_name.py
# Description: None
########################################################################################################

import os


out = open('/home/lab/darknet/detection_data/train.txt', 'w')

cnt = 0
for line in open('/home/lab/darknet/detection_data/1.txt'):
    line = line.strip()
    fileName = line.split('/')[-1].split('.')[0]
    if not os.path.exists(line):
        print(line)
        cnt += 1
    elif not os.path.exists('/home/lab/darknet/detection_data/labels/' + fileName + ".txt"):
        print('/home/lab/darknet/detection_data/labels/' + fileName + ".txt")
        cnt += 1
    else:
        out.write(line + '\n')
print(cnt)


# import os

# def main(src, dest):
#     out_file = open(dest,'w')  #生成了在指定目录下的txt文件  
#     with open(dest, 'w') as f:
#         for name in os.listdir(src):
#             base_name = os.path.basename(name)
#             file_name = base_name.split('.')[0]
#             f.write('%s\n' % file_name)

# if __name__ == '__main__':
#     TrainDir = 'VOCdevkit/VOC2007/JPEGImages'  #图片文件所在目录
#     target = 'VOCdevkit/VOC2007/ImageSets/Main/train.txt'
#     main(TrainDir, target)