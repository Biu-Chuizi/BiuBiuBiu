# -*- coding:utf-8 -*-

import numpy as np
import parse
import constant
import random
from PIL import Image, ImageEnhance, ImageOps, ImageFile

def gaussianNoisy(im, mean=0.2, sigma=0.3):
  for _i in range(len(im)):
    im[_i] += random.gauss(mean, sigma)
  return im

def _noise(im, mean=0.2, sigma=0.3):
  img = np.asarray(im)
  w, h = img.shape[:2]
  img_r = gaussianNoisy(img[:, :, 0].flatten(), mean, sigma)
  img_g = gaussianNoisy(img[:, :, 1].flatten(), mean, sigma)
  img_b = gaussianNoisy(img[:, :, 2].flatten(), mean, sigma)
  img = np.zeros([w, h, 3], np.uint8)
  img[:, :, 0] = img_r.reshape([w, h])
  img[:, :, 1] = img_g.reshape([w, h])
  img[:, :, 2] = img_b.reshape([w, h])
  return Image.fromarray(np.uint8(img))

def _get_pos(filename):
  info = parse.xmlParser(filename)
  if info == None:
    return None
  else:
    res = dict()
    for cls in constant.classes:
      cls_id = constant.classes.index(cls)
      if str(cls_id) not in info: continue
      pos_list = info[str(cls_id)]
      for pos in pos_list:
        width = info['w']
        height = info['h']
        xmin = pos[0]
        xmax = pos[1]
        ymin = pos[2]
        ymax = pos[3]
        ans = convert((width, height), (xmin, xmax, ymin, ymax))
        if str(cls_id) in res:
          res[str(cls_id)].append(ans)
        else:
          res[str(cls_id)] = [ans]
    return res

def convert(size, box):
  # dw = 1. / (size[0])
  dw =1. / 1280
  # dh = 1. / (size[1])
  dh =1. / 1024
  x = (box[0] + box[1]) / 2.0 - 1
  y = (box[2] + box[3]) / 2.0 - 1
  w = box[1] - box[0]
  h = box[3] - box[2]
  x = x * dw
  w = w * dw
  y = y * dh
  h = h * dh
  return (x, y, w, h)