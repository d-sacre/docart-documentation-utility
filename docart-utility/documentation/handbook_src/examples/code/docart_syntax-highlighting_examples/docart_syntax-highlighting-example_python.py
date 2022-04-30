# -*- coding: utf-8 -*-

from datetime import datetime

# generate the current date and time strings from time stamps
date = datetime.now().strftime("%Y-%m-%d")
time = datetime.now().strftime("%I:%M:%S %p")

# assemble the string which will be printed
# Warning: This syntax requires Python 3.6 or higher
ostring = f"Hello World, the date is {date}, the time is {time}." 

print(ostring)


