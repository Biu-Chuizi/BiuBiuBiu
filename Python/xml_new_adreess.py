#######################################################################################################
# -*- coding:utf-8 -*-
# File: xml_new_adreess.py
# Update: 2020/05/26
# USAGE: python xml_new_adreess.py
# Description: 更改坐标文件地址索引
########################################################################################################

import os
def get_filePathList(dirPath, partOfFileName=''):
    allFileName_list = list(os.walk(dirPath))[0][2]
    fileName_list = [k for k in allFileName_list if partOfFileName in k]
    filePath_list = [os.path.join(dirPath, k) for k in fileName_list]
    return filePath_list

# 修改文件夹中的单个xml文件
import xml.etree.ElementTree as ET
def single_xmlCompress(old_xmlFilePath, new_xmlFilePath):
    with open(old_xmlFilePath) as file:
        fileContent = file.read()
    root = ET.XML(fileContent)
    # 获得图片地址，并改成新地址
    path = root.find('path')
    path.text = str(new_dirPath)
    tree = ET.ElementTree(root)
    tree.write(new_xmlFilePath)
    
# 修改文件夹中的若干xml文件
def batch_xmlCompress(old_dirPath, new_dirPath):
    xmlFilePath_list = get_filePathList(old_dirPath, '.xml')
    for xmlFilePath in xmlFilePath_list:
        old_xmlFilePath = xmlFilePath
        xmlFileName = os.path.split(old_xmlFilePath)[1]
        new_xmlFilePath = os.path.join(new_dirPath, xmlFileName)
        single_xmlCompress(xmlFilePath, new_xmlFilePath)

import argparse
def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('-d', '--dirPath', type=str, help='旧文件夹路径', default='/home/lab/AI_Projects/001_keras_YOLOv3/resources/selected_images')    
    argument_namespace = parser.parse_args()
    return argument_namespace  

# 主函数    
if __name__ == '__main__':
    argument_namespace = parse_args()
    old_dirPath = argument_namespace.dirPath
    assert os.path.exists(old_dirPath), 'not exists this path: %s' %old_dirPath
    new_dirPath = '/home/lab/AI_Projects/001_keras_YOLOv3/resources/images_416' 
    batch_xmlCompress(old_dirPath, new_dirPath)
    print('所有.xml文件都已经完成修改')