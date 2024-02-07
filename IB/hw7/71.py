import sys
import os
import argparse
import errno
spacefortree = '   '
line = '│'
def makeTree(path,count):
	try:
		objects = os.listdir(path)
	except:
		return {'files': []}
	if count:
		files=[]
	else:
		files = list(filter(lambda object: os.path.isfile(path + '/'+ str(object)), objects))
	directories = list(filter(lambda object: os.path.isdir(path + '/'+ str(object)), objects))
	directoriesDict={('files',): files}
	for directory in directories:
		directoriesDict [str(directory)]=makeTree(path+'/'+str(directory),count)
	return directoriesDict
def printTree(dirDict,outPath,count,path):
	if outPath is not None:
		sys.stdout=open(outPath,'w')
	print(path)
	def printrectree(dirDict,beg):
		if len(dirDict)>1:
			directs=list(dirDict.items())[1:]
			for direct, directTree in directs[:-1]:
				print(beg+'├── '+ direct)
				printrectree(directTree,beg+line+spacefortree)
			print(beg +'├── ' + directs[-1][0])
			printrectree(directs[-1][1],
beg+(line if len(list(dirDict.items())[0][1])>0  else '')+spacefortree+' ' * len(line))
		if len(dirDict[('files',)])>0:
			for file in dirDict['files',][:-1]:
				print(beg+'├── '+file)
			print (beg+'├── '+dirDict['files',][-1])
	printrectree(dirDict,'')
def process_path_argument(parser, arg):
	if os.path.exists(arg):#дальше ошибки, позже аргумент, если нет ошибок
		if not os.path.isfile(arg):
			parser.error(f'Требуется указать путь до файла')
		elif not os.access(arg, os.W_OK):
			parser.error(f'Нет доступа на запись в файл {arg}')
		else:
			return arg
	else:
		try:
			os.makedirs(os.path.dirname(arg))
		except OSError as error:
			if error.errno != errno.EEXIST:
				parser.error(f'Не удается создать файл {arg}. Ошибка: {error}')
		return arg
parser = argparse.ArgumentParser(add_help=False)
parser.add_argument('-d', dest='dirOnly', action='store_true')
parser.add_argument('-o', dest='outputPath', type=lambda path: process_path_argument(parser, path))
args, unknowns = parser.parse_known_args()
if __name__ == '__main__':
	for path in unknowns:
		if os.access(path, os.R_OK) and os.path.exists(path) and os.path.isdir(path):
			printTree(makeTree(path,args.dirOnly), args.outputPath ,args.dirOnly,path)
		else:
			sys.stderr.write( f'Не удалось открыть директорию {path} или её не существует \n')