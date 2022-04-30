######################################################################################
######################################################################################
######################################################################################
## docART Utility - A Python/Lua(LaTeX) based tool for semi-automated documentation ##
## Source: https://github.com/d-sacre/docart-documentation-utility/                 ##
## Version: alpha-2022-04-30                                                        ##
## License: GNU General Public License (GPLv3)                                      ##
## Copyright (C) 2022 Martin Stimpfl, Daniel Sacré                                  ##
##                                                                                  ##
## This program is free software: you can redistribute it and/or modify             ##
## it under the terms of the GNU General Public License as published by             ##
## the Free Software Foundation, either version 3 of the License, or                ##
## (at your option) any later version.                                              ##
##                                                                                  ##
## This program is distributed in the hope that it will be useful,                  ##
## but WITHOUT ANY WARRANTY; without even the implied warranty of                   ##
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the                    ##
## GNU General Public License for more details.                                     ##
##                                                                                  ##
## You should have received a copy of the GNU General Public License                ##
## along with this program.  If not, see <https://www.gnu.org/licenses/>.           ##
######################################################################################
######################################################################################
######################################################################################

#+++Complete+++
import os

def getEditTime(filename):
	if os.path.isfile(filename):
		return os.stat(filename).st_mtime
	else:
		return 0

#+++Complete+++	