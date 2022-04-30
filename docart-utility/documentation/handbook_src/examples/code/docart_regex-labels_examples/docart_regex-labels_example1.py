# -*- coding: utf-8 -*-
#+++Step1And2+++
import os
#+++Step1+++
from datetime import datetime

directory = "./test-directory/"
#+++Step1+++

if not os.path.exists(directory):
    os.makedirs(directory)

#+++Step1+++
filename = datetime.now().strftime("%Y_%m_%d-%I_%M_%S_%p")
filepath = directory + filename
open(filepath, 'a').close()
#+++Step1+++
#+++Step1And2+++

