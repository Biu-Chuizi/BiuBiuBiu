# -*- coding:utf-8 -*-

import numpy as np
import parse
import constant
import random
from PIL import Image, ImageEnhance, ImageOps, ImageFile

def _color(im):
  random_factor = np.random.randint(0, 31) / 10.
  color_im = ImageEnhance.Color(im).enhance(random_factor)
  random_factor = np.random.randint(10, 21) / 10.
  brightness_im = ImageEnhance.Brightness(color_im).enhance(random_factor)
  random_factor = np.random.randint(10, 21) / 10.
  contrast_im = ImageEnhance.Contrast(brightness_im).enhance(random_factor)
  random_factor = np.random.randint(0, 31) / 10.
  return ImageEnhance.Sharpness(contrast_im).enhance(random_factor)

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
  dw = 1. / (size[0])
  # dw =1. / 1280
  dh = 1. / (size[1])
  # dh =1. / 1024
  x = (box[0] + box[1]) / 2.0 - 1
  y = (box[2] + box[3]) / 2.0 - 1
  w = box[1] - box[0]
  h = box[3] - box[2]
  x = x * dw
  w = w * dw
  y = y * dh
  h = h * dh
  return (x, y, w, h)