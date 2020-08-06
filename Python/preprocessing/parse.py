# -*- coding:utf-8 -*-

import configparser
import constant
import os
import ioutils
import xml.etree.ElementTree as ET

parse = configparser.ConfigParser()

def init(conf_path):
  parse.read(conf_path)
  constant.img_folder = parse.get('conf', 'image_input')
  constant.img_save = parse.get('conf', 'image_output')
  constant.label_folder = parse.get('conf', 'label_input')
  constant.angle = map(int, parse.get('conf', 'angle').split(','))
  constant.classes = parse.get('conf', 'class').split(',')
  constant.noise = True if parse.get('conf', 'noise') == 'True' else False
  constant.color = True if parse.get('conf', 'color') == 'True' else False

def xmlParser(filename):
  path = os.path.join(constant.label_folder, filename)
  if ioutils.check_exist(path) == False:
    return None
  res = dict()
  tree = ET.parse(open(path))
  root = tree.getroot()
  size = root.find('size')
  w = int(size.find('width').text)
  h = int(size.find('height').text)
  res['w'] = w
  res['h'] = h
  for obj in root.iter('object'):
    difficult = obj.find('difficult').text
    cls = obj.find('name').text
    if cls not in constant.classes or int(difficult) == 1: continue
    cls_id = constant.classes.index(cls)
    xmlbox = obj.find('bndbox')
    pos = (float(xmlbox.find('xmin').text), float(xmlbox.find('xmax').text), float(xmlbox.find('ymin').text), float(xmlbox.find('ymax').text))
    if str(cls_id) in res:
      res[str(cls_id)].append(pos)
    else:
      res[str(cls_id)] = [pos]
  return res