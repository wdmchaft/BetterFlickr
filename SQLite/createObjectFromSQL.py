import re

##########################################################
# 	INTERFACE
##########################################################
def header(fileH, dict):
	defines = ""
	
	##########################################################
	# 	Print Column
	##########################################################
	val = 0
	for k in dict:
		print k
		for v in dict[k]:
			defines = defines + '#define k%s%sColumn %d\n' % (table, str.capitalize(v), val)
			val += 1
	defines = defines + "\n"
	
	##########################################################
	# 	Print ColumnName
	##########################################################
	for k in dict:
		print k
		for v in dict[k]:
			defines += '#define k%s%sColumnName @"%s"\n' % (table, str.capitalize(v), v)
			#defines = defines + '#define k'+str.capitalize(v)+'ColumnName'+"\t@"+'"'+v+'"'+"\n"
	defines = defines + "\n"
	
	##########################################################
	# 	Print Interface
	##########################################################
	interface = "@interface " + table + " : NSObject" + "\n{"
	for k in dict:
		for v in dict[k]:
			if re.match(r'bool', k, re.IGNORECASE):
				interface = interface + '\tBOOL\t'
			elif re.match(r'int', k, re.IGNORECASE):
				interface = interface + ') NSInteger '
			elif re.match(r'varchar|text', k, re.IGNORECASE):
				interface = interface + '\tNSString*\t'
			interface = interface + '_'+ v + ";\n"
	interface = interface + "}\n\n"
	print interface
	
	##########################################################
	# 	Print Properties
	##########################################################
	properties = ''
	for k in dict:
		for v in dict[k]:
			properties = properties + '@property (nonatomic'
			if re.match(r'bool', k, re.IGNORECASE):
				properties = properties + ') BOOL '
			elif re.match(r'int', k, re.IGNORECASE):
				properties = properties + ') NSInteger '
			elif re.match(r'varchar|text', k, re.IGNORECASE):
				properties = properties + ',retain) NSString* '
			properties = properties + v + ";\n"
	
	print properties
	
	##########################################################
	# 	Print Useful Function and complete
	##########################################################
	
	useful = "\n"
	useful += '- (' + table + '*)initWithSQLiteStatement:(sqlite3_stmt*)iStatement;' + "\n"
	useful += '- (' + table + '*)initWithDictionary:(NSDictionary*)iDictionary;' + "\n"
	
	useful += "\n@end\n"
	
	print useful
	
	
	fileH.writelines([defines, interface, properties, useful])
	
	return
	
##########################################################
# 	IMPLENTATION
##########################################################

def implementation(fileM, dict):
	
	##########################################################
	# 	SYNTHESIZE
	##########################################################
	synth = ''
	for k in dict:
		for v in dict[k]:
			synth += "@synthesize " + v + " = _" + v + ";\n"
		
	print synth
	
	##########################################################
	# 	SQL
	##########################################################
	sql = '- (%s*)initWithSQLiteStatement:(sqlite3_stmt*)iStatement\n' % (table)
	sql += '{\n\tif (self = [super init])\n\t{\n'
	for k in dict:
		for v in dict[k]:
			val = ''
			if re.match(r'bool|int', k, re.IGNORECASE):
				val = 'sqlite3_column_int(iStatement, k%s%sColumn);\n' % (table,str.capitalize(v))
			elif re.match(r'varchar|text', k, re.IGNORECASE):
				val = '[[NSString alloc] initWithSQLiteStatement:iStatement column:k%s%sColumn];\n' % (table,str.capitalize(v))
			sql += '\t\t_%s = %s' % (v, val)
	sql += '\t}\n\n'
	sql += '\treturn self;\n}\n'
	print sql
	
	##########################################################
	# 	DICTIONARY
	##########################################################
	d = '- (%s*)initinitWithDictionary:(NSDictionary*)iDictionary\n' % (table)
	d += '{\n\tif (self = [super init])\n\t{\n'
	for k in dict:
		for v in dict[k]:
			val = ''
			if re.match(r'bool|int', k, re.IGNORECASE):
				val = '[NSString integerFromDictionary:iDictionary key:k%s%sColumnName];\n' % (table,str.capitalize(v))
			elif re.match(r'varchar|text', k, re.IGNORECASE):
				val = '[[NSString alloc] initWithDictionary:iDictionary key:k%s%sColumnName];\n' % (table,str.capitalize(v))
			d  += '\t\t_%s = %s' % (v, val)
	d  += '\t}\n\n'
	d  += '\treturn self;\n}\n'
	print d
	
	##########################################################
	# 	DEALLOC
	##########################################################
	dealloc = '- (void)dealloc\n{\n'
	for k in dict:
		for v in dict[k]:
			val = ''
			if re.match(r'varchar|text', k, re.IGNORECASE):
				val += '\t[_%s release];\n' % (v)
				dealloc += val
	dealloc += '\n\t[super dealloc];\n}\n'
	print dealloc
	
	fileM.writelines([synth, sql, d, dealloc])
	
	return
	
##########################################################
# 	MAIN
##########################################################

# Let's create a file and write it to disk.
fileInputName = "/Volumes/Storage/Projects/BetterFlickr/SQLite/betterflickr.sql"
fileInput = open(fileInputName, 'r')

#fileInput.read()

content =  fileInput.read()

fileInput.close()

print content

#MTables = re.finditer(r'create table\s*(\w+)\(([^;]+)\);', content, re.IGNORECASE|re.MULTILINE)

for MTables in re.finditer(r'create table\s*(\w+)\(([^;]+)\);', content, re.IGNORECASE|re.MULTILINE):
	table = MTables.group(1)
	
	fileH = open(table+'.h', 'w')
	fileM = open(table+'.m', 'w')
	
	print "Found Matched: " + MTables.group(1) + ":\n"+ MTables.group(2)
	dict = {}
	
	
	MContent  = re.findall(r'(\w+)\s+([a-z]+)[()\s\w]+,', MTables.group(2), re.IGNORECASE)
	for m in MContent:
		if m[1] not in dict:
			dict[m[1]] = []
		dict[m[1]].append(m[0])
		#dict[m[0]] = m[1]
		
	print dict
	
	header(fileH, dict)
	implementation(fileM, dict)
	
	fileH.close()
	fileM.close()
