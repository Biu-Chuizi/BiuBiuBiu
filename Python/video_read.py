#######################################################################################################
# -*- coding:utf-8 -*-
# File: video_read.py
# Update: 2020/05/26
# USAGE: python video_read.py
# Description: None
########################################################################################################

import os
import cv2
# import cv

videos_src_path = '/Volumes/Ubuntu-Serv/FFOutput'
videos_save_path = '/Volumes/Ubuntu-Serv/0'

videos = os.listdir(videos_src_path)
videos = filter(lambda x: x.endswith('mp4'), videos)  ## MP4 dev 

for each_video in videos:
    # print each_video

    # get the name of each video, and make the directory to save frames
    each_video_name, _ = each_video.split('.')
    os.mkdir(videos_save_path + '/' + each_video_name)               

    each_video_save_full_path = os.path.join(videos_save_path, each_video_name) + '/'

    # get the full path of each video, which will open the video tp extract frames
    each_video_full_path = os.path.join(videos_src_path, each_video)

    cap  = cv2.VideoCapture(each_video_full_path)
    frame_count = 1
    success = True

    timeF = 10  

    while(success):
        success, frame = cap.read()
        # print 'Read a new frame: ', success

        params = []
        # params.append(cv2.CV_IMWRITE_PXM_BINARY)
        params.append(1)
        if (frame_count%timeF == 0):

            cv2.imwrite(each_video_save_full_path + each_video_name + "_%d.tiff" % frame_count, frame, params)

        frame_count = frame_count + 1

cap.release()


# import cv2

       
# vc = cv2.VideoCapture('/Volumes/Ubuntu-Serv/FFOutput/陈志文151804.mp4') #读入视频文件
# c=1

# if vc.isOpened(): #判断是否正常打开
#     rval, frame = vc.read()
# else:
#     rval = False

# timeF = 100  #视频帧计数间隔频率

# while rval:   #循环读取视频帧
#     rval, frame = vc.read()
#     if(c%timeF == 0): #每隔timeF帧进行存储操作
#         cv2.imwrite('image/'+str(c) + '.jpg',frame) #存储为图像
#     c = c + 1
#     cv2.waitKey(1)
# vc.release()


# #---------------------

# #本文来自 张某人ER 的CSDN 博客 ，全文地址请点击：https://blog.csdn.net/xinxing__8185/article/details/48440133?utm_source=copy 
