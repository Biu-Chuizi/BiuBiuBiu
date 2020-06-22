# -*- coding:utf-8 -*-

import numpy as np
import parse
import constant

def _rotate(im, angle):
  res = im
  if angle == 0:
    res = im
  elif angle == 90:
    res = np.rot90(np.rot90(np.rot90(im)))
  elif angle == 180:
    res = np.rot90(np.rot90(im))
  elif angle == 270:
    res = np.rot90(im)
  return res

def _modify_locate(filename, angle):
  info = parse.xmlParser(filename)
  if info == None:
    return None
  else:
    res = dict()
    print("1111")
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
        if angle == 0:
          width = info['w']
          height = info['h']
          xmin = pos[0]
          xmax = pos[1]
          ymin = pos[2]
          ymax = pos[3]
        elif angle == 90:
          xmin, xmax, ymin, ymax = height - ymax, height - ymin, xmin, xmax
          height, width = width, height
        elif angle == 180:
          xmin, xmax, ymin, ymax = width - xmax, width - xmin, height - ymax, height - ymin
        elif angle == 270:
          xmin, xmax, ymin, ymax = ymin, ymax, width - xmax, width - xmin
          height, width = width, height
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