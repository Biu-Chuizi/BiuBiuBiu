# -*- coding:utf-8 -*-

import os
import cv2
import shutil

def make_folder(path):
  if os.path.exists(path) == False:
    os.makedirs(path)
  else:
    shutil.rmtree(path)
    os.makedirs(path)

def check_exist(path):
  path = os.path.join(path)
  if os.path.exists(path) == False:
    return False
  else:
    return True

def label_write(path, info):
  f = open(path, 'w')
  for cls_id in info.keys():
    for pos in info[cls_id]:
      f.write(str(cls_id) + " " + " ".join([str(x) for x in pos]) + '\n')
  f.close()

def img_write(path, img):
  cv2.imwrite(path, img)