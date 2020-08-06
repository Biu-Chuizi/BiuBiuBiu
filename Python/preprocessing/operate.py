# -*- coding:utf-8 -*-

import os
import constant
import ioutils
import cv2
import rotate
import noise
import color
from PIL import Image, ImageEnhance, ImageOps, ImageFile

def rotate_process(rotate_input, rotate_img_save_path, rotate_label_save_path, angle):
  for rt, dirs, files in os.walk(rotate_input):
    for d in dirs:
      rotate_process(os.path.join(rt, d), rotate_img_save_path, rotate_label_save_path, angle)
    for f in files:
      suffix = os.path.splitext(f)
      if suffix[-1] != '.jpg': continue
      im = cv2.imread(os.path.join(rt, f), 1)
      res_img = rotate._rotate(im, angle)
      res_pos = rotate._modify_locate(suffix[0] + '.xml', angle)
      if res_pos != None:
        img_name = suffix[0] + '_rot' + str(angle) + '.jpg'
        label_name = suffix[0] + '_rot' + str(angle) + '.txt'
        dst_img_file = os.path.join(rotate_img_save_path, img_name)
        dst_label_file = os.path.join(rotate_label_save_path, label_name)
        ioutils.img_write(dst_img_file, res_img)
        ioutils.label_write(dst_label_file, res_pos)
        print(f + ' done.')

def noise_process(noise_input, noise_img_save_path, noise_label_save_path):
  for rt, dirs, files in os.walk(noise_input):
    for d in dirs:
      noise_process(os.path.join(rt, d), noise_img_save_path, noise_label_save_path)
    for f in files:
      suffix = os.path.splitext(f)
      if suffix[-1] != '.jpg': continue
      im = Image.open(os.path.join(rt, f), mode='r')
      res_pos = noise._get_pos(suffix[0] + '.xml')
      if res_pos != None:
        res_img = noise._noise(im)
        img_name = suffix[0] + '_guassian' + '.jpg'
        label_name = suffix[0] + '_guassian' + '.txt'
        dst_img_file = os.path.join(noise_img_save_path, img_name)
        dst_label_file = os.path.join(noise_label_save_path, label_name)
        res_img.save(dst_img_file)
        ioutils.label_write(dst_label_file, res_pos)
        print(f + ' done.')

def color_process(color_input, color_img_save_path, color_label_save_path):
  for rt, dirs, files in os.walk(color_input):
    for d in dirs:
      color_process(os.path.join(rt, d), color_img_save_path, color_label_save_path)
    for f in files:
      suffix = os.path.splitext(f)
      if suffix[-1] != '.jpg': continue
      im = Image.open(os.path.join(rt, f), mode='r')
      res_pos = color._get_pos(suffix[0] + '.xml')
      if res_pos != None:
        res_img = color._color(im)
        img_name = suffix[0] + '_color' + '.jpg'
        label_name = suffix[0] + '_color' + '.txt'
        dst_img_file = os.path.join(color_img_save_path, img_name)
        dst_label_file = os.path.join(color_label_save_path, label_name)
        res_img.save(dst_img_file)
        ioutils.label_write(dst_label_file, res_pos)
        print(f + ' done.')

def rot():
  for _angle in constant.angle:
      rotate_img_save_path = os.path.join(os.path.join(constant.img_save, 'rot' + str(_angle)), 'image')
      rotate_label_save_path = os.path.join(os.path.join(constant.img_save, 'rot' + str(_angle)), 'label')
      ioutils.make_folder(rotate_img_save_path)
      ioutils.make_folder(rotate_label_save_path)
      rotate_input = constant.img_folder
      print('Rotate ' + str(_angle) + ' start')
      rotate_process(rotate_input, rotate_img_save_path, rotate_label_save_path, _angle)
      print('Rotate ' + str(_angle) + ' end')

def noi():
  noise_img_save_path = os.path.join(os.path.join(constant.img_save, 'noise'), 'image')
  noise_label_save_path = os.path.join(os.path.join(constant.img_save, 'noise'), 'label')
  ioutils.make_folder(noise_img_save_path)
  ioutils.make_folder(noise_label_save_path)
  noise_input = constant.img_folder
  print('Noise Generation Start')
  noise_process(noise_input, noise_img_save_path, noise_label_save_path)
  print('Noise Generation End')

def col():
  color_img_save_path = os.path.join(os.path.join(constant.img_save, 'color'), 'image')
  color_label_save_path = os.path.join(os.path.join(constant.img_save, 'color'), 'label')
  ioutils.make_folder(color_img_save_path)
  ioutils.make_folder(color_label_save_path)
  color_input = constant.img_folder
  print('Color Generation Start')
  color_process(color_input, color_img_save_path, color_label_save_path)
  print('Color Generation End')

def process(op):
  if op == 'rotate':
    rot()
  if op == 'noise':
    noi()
  if op == 'color':
    col()