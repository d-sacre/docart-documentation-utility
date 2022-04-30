# -*- coding: utf-8 -*-
#+++Step1And2+++
import os
#+++Step1+++
from datetime import datetime

directory = "./test-directory/"

#+++comment Step1+++# FUTURE CODE FOR DIR CHECKER
#+++newline Step1+++
#+++Step1+++
# Check if dir exists and if not create it
if not os.path.exists(directory):
    os.makedirs(directory)

#+++Step1+++
filename = datetime.now().strftime("%Y_%m_%d-%I_%M_%S_%p")
#+++comment Step1+++# Generate the file path without checking if dir exists
#+++comment Step1And2, all +++# file path generation save (dir check above)
filepath = directory + filename

open(filepath, 'a').close()
#+++Step1+++
#+++Step1And2+++

