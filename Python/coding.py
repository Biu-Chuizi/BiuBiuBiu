#######################################################################################################
# -*- coding:utf-8 -*-
# File: coding.py
# Update: 2020/05/26
# USAGE: python coding.py
# Description:  按照路径重命名
########################################################################################################
import sys, os, time
from PIL import Image
dst_dep = 2
def go(src_path, dep):
    global f
    for dirpath, dirnames, filenames in os.walk(src_path):
        if dep == dst_dep:
            name_list = []
            for f in filenames:
                name_list.append(f)
            name_list.sort()
            # print(name_list)
            if len(name_list) == 0:
                # print(1111111111111111)
                print(dirpath, name_list[0])
                name = f.split('.')[0]
                print(name)
                name.lstrip('p')
                print(name)
                os.rename(dirpath + name + '.' + 'tiff')
            else:
                print(dirpath, name_list[0])
                name = f.split('.')[0]
                print(name)
                name.lstrip('p')
                os.rename(dirpath + name + '.' + 'tiff')
        else:
            for dir in dirnames:
                go(os.path.join(dirpath, dir), dep + 1)

if __name__ == '__main__':
    src_path = sys.argv[1]
    go(src_path, 0)

# 使用 set() 函数来移除所有重复元素
def all_unique(lst):
    return len(lst) == len(set(lst))

x = [1,2,2,3,4,5,4,6]
y = [1,2,3,4,5]
all_unique(x)   # False
all_unique(y)   # True

# 检查两个字符串的组成元素是不是一样的
from collections import Counter
def anagram(first, second):
    return Counter(first) == Counter(second)

anagram("abcd3", "3acdb")
