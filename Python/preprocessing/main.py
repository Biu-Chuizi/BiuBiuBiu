# -*- coding:utf-8 -*-

import parse
import operate
import constant

if __name__ == '__main__':
  parse.init("confooo")
  operate.process('rotate')
  if constant.noise:
    operate.process('noise')
    # pass
  if constant.color:
    operate.process('color')
    # pass