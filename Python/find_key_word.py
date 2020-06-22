#######################################################################################################
# -*- coding:utf-8 -*-
# File: find_key_word.py
# Update: 2020/05/26
# USAGE: python find_key_word.py
# Description: Find a key word in a .txt file and rename the corrrespond file in the fold.
########################################################################################################

import sys
import os
import re

path_dir = '/media/lab/Elements SE/mixeddata/O&G20180725_1710-混合-ww删图/'
file_name= '/media/lab/Elements SE/mixeddata/20180725_3.txt'

labels = []
for name in open(file_name, 'r'):
    labels.append(name.strip())

cnt = 0
ans = []
for files in os.listdir(path_dir):
    file_path=os.path.join(path_dir,files)
    dir_file_name=file_path.split("/")[-1]
    for d in labels:
        if dir_file_name.find(d) != -1:
            ans.append(dir_file_name)
            cnt = cnt + 1
            break;    
print(cnt)

for d in ans:
    os.rename(path_dir + d, path_dir + 'F' + d)
