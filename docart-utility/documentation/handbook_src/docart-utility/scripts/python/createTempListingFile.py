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
# +++PythonExample+++
import os
import sys
import re
import time
import hashlib
import fileTime as ft

export_path = './TMP/lst/'

# Function to start the encoding
def run(sourcefile, lsttag, delim, force_rebuild):
	if not os.path.exists(export_path):
		os.makedirs(export_path)
	writefile = export_path + str(hashlib.sha256(sourcefile.encode()).hexdigest()) + '_' + lsttag + '.lst'
# +++PythonExample+++
	if not force_rebuild and ft.getEditTime(sourcefile) < ft.getEditTime(writefile):
		return
		
	delim_reg = delim
	escapelist = ['+', '-', '!', '?', '[', ']', '{', '}']

	for character in escapelist:
		if character not in delim:
			pass
		else:
			delim_reg = delim_reg.replace(character, '\\' + character)

	if lsttag == 'all':
		tag = 'all'
	else:
		tag = delim + lsttag + delim
	
	expression_dictionary = {}
	expression_dictionary["anyTag"] = [re.compile('.*' + delim_reg + '[a-zA-Z0-9, ]*' + delim_reg + '.*'), delim_reg + '[a-zA-Z0-9, ]{1,64}' + delim_reg]
	expression_dictionary["newline"] = [re.compile('.*' + delim_reg + 'newline ' +'[a-zA-Z0-9, ]*' + lsttag +'\\b' + '[a-zA-Z0-9, ]*' + delim_reg + '.*'), delim_reg + 'newline ' +'[a-zA-Z0-9, ]*' + lsttag +'\\b' + '[a-zA-Z0-9, ]*' + delim_reg]
	expression_dictionary["comment"] = [re.compile('.*' + delim_reg + 'comment ' +'[a-zA-Z0-9, ]*' + lsttag +'\\b' + '[a-zA-Z0-9, ]*' + delim_reg + '.*'), delim_reg + 'comment ' +'[a-zA-Z0-9, ]*' + lsttag + '\\b' + '[a-zA-Z0-9, ]*' + delim_reg]

	outtext = fulltextSplit(sourcefile, lsttag, tag, expression_dictionary)
	lstofile=open(writefile,'w')
	lstofile.write(outtext)
	lstofile.close()

def unindent(text):
	if text == '':
		return text
		
	indents = True
	while indents:
		tmp = ''
		lines = text.split('\n')
		for l in lines:
			if not l.startswith('\t') and l != '':
				indents = False
				break
		if indents:
			for l in lines:
				tmp += l[1:]
				if l != '':
					tmp = tmp + '\n'
			text = tmp
	return text



def fulltextSplit(sourcefile, lsttag, tag, expression_dictionary):
	sourcedata = open(sourcefile, 'r')
	fulltext = sourcedata.read()
	sourcedata.close()
	
	if tag == 'all':
		list = [fulltext]
	else:
		list = fulltext.split(tag)

		if len(list) % 2 != 1 and len(list) > 1:
			return 'Uneven number of Tags found!'

		list = list[1::2]
		
	outtext = ''
	for paragraph in list:
		paragraph = paragraph.rsplit('\n', 1)[0]#.rstrip()
		linelist = paragraph.splitlines()
		new_paragraph = ''
		for line in linelist:
			if expression_dictionary["anyTag"][0].match(line) == None:
				new_paragraph += (line + '\n')
			elif expression_dictionary["newline"][0].match(line) != None:
				new_paragraph += '\n'
			elif expression_dictionary["comment"][0].match(line) != None:
				new_paragraph += (re.split(expression_dictionary["comment"][1], line)[1] +'\n')

		outtext += (new_paragraph.rsplit('\n', 1)[0])

	outtext = unindent(outtext)
	return outtext.lstrip().rstrip()


if __name__ == '__main__':

	if len(sys.argv) < 4 or len(sys.argv) > 5:
		print('Wrong Arguments for Parsing Source Files!')
		print('Usage:')
		print('\t arg[1] = Path to Sourcefile')
		print('\t arg[2] = Tag Name')
		print('\t arg[3] = Tag Delimiter')
		print('\t arg[4] = Optional flag; "f" to rebuild all files')
		print('e.g. "MyFile.h Mytag +++" for parsing MyFile.h for text surrounded by "+++Mytag+++"')

	sourcefile = str(sys.argv[1])
	lsttag = str(sys.argv[2])
	delim = str(sys.argv[3])
	if len(sys.argv) == 5 and str(sys.argv[4]) == 'f':
		force_rebuild = True
	else:
		force_rebuild = False

	run(sourcefile, lsttag, delim, force_rebuild)

#+++Complete+++
