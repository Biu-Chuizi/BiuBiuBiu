#######################################################################################################
# -*- coding:utf-8 -*-
# File: run_python.sh
# Update: 2020/05/26
# USAGE: ./run.sh ~/AI_test/Testing/
# Description: None
########################################################################################################
#!/bin/bash

thresh=(0.3)
len=${#thresh[@]}

function readFile() {
  for ((i=0; i<$len; i++))
  do
    for file in `ls $1`
    do
      echo "$file"
      cd ~/darknet
      ./darknet detector demo detection_scripts/polyp_detection.data detection_scripts/polyp_detection_test.cfg backup/polyp_detection_train_95000.weights -input $1/$file -thresh ${thresh[$i]}
      # ./darknet detector demo detection_scripts/polyp_detection.data detection_scripts/polyp_detection_test.cfg backup/polyp_detection_train_110000.weights -ext_output $1/$file -thresh ${thresh[$i]}
    done
  done
}

readFile $1
