#######################################################################################################
# -*- coding:utf-8 -*-
# File: run_python_.sh
# Update: 2020/05/26
# USAGE: ./run_python_.sh
# Description: None
########################################################################################################
#!/bin/bash

# cd ~/darknet
# ./run.sh ~/AI_test/Testing/

# thresh=(0.1)
# len=${#thresh[@]}
function readFile() {
  for file in `ls /home/lab/SinGAN/Input/T1b_wrong`
  do
    #   echo "$file"
    cd ~/SinGAN
    #   ./darknet detector demo ../darknetAB/detection_scripts/polyp_detection.data ../darknetAB/detection_scripts/polyp_detection_test.cfg ../darknetAB/backup/polyp_detection_train_15000.weights -input $1/$file -thresh ${thresh[$i]}
    CUDA_VISIBLE_DEVICES=1 python SR.py --input_dir Input/T1b_wrong --input_name $file --max_size 500
      # ./darknet detector demo detection_scripts/polyp_detection.data detection_scripts/polyp_detection_test.cfg backup/polyp_detection_train_110000.weights -ext_output $1/$file -thresh ${thresh[$i]}
  done
}

readFile 
