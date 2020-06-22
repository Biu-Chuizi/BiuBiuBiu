#######################################################################################################
# -*- coding:utf-8 -*-
# File: result_list.py
# Update: 2020/05/26
# USAGE: python3 result_list.py ~/darknet/answer_40000_20181111/
# Description: 打印结果
########################################################################################################

import sys
import os

dst_dep = 2
fopen = open('result.txt', 'w')

def go(src_path, dep):
    global f
    for dirpath, dirnames, filenames in os.walk(src_path):
        if dep == dst_dep:
            name_list = []
            for f in filenames:
                name_list.append(f)
            name_list.sort()
            if len(name_list) == 0:
                print(dirpath, 0)
                fopen.write('\t'.join(dirpath.split("/")[-2:]) + "\t" + "0" + "\n")
            else:
                print(dirpath, name_list[0])
                fopen.write('\t'.join(dirpath.split("/")[-2:]) + "\t" + name_list[0].split('_')[0] + "\n")
        else:
            for dir in dirnames:
                go(os.path.join(dirpath, dir), dep + 1)

if __name__ == '__main__':
    src_path = sys.argv[1]
    go(src_path, 0)
    fopen.close()

