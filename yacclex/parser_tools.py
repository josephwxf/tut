#!/usr/bin/python
# This Python file uses the following encoding: utf-8

"""
   parser_tools.py -- 一个cli工具,帮助自动生成yacc文件的token声明.

"""

import sys
import os
import getopt
import string
import re
import itertools
import pprint

def is_token(str):
    return ( str.isalnum() and str[0].isalpha() )

def not_debug(l):
    return False if l[0] == '&' else True

#
#  generate lookup.c
#
def gen_lookup_file( toks ):
    toks = list(set(toks))
    toks.sort()
    toks.append(" ");
    r = []
    r.append("token_ent token_table[] = {\n")
    match_len=0
    for i in range(len(toks)-1):
        cstr = os.path.commonprefix(toks[i:i+2])
        cmatch_len = len(cstr)
        lens = max( match_len, cmatch_len )
        if lens < len(toks[i]) :
            lens = lens+1
        else:
            lens = len(toks[i])
        match_len = cmatch_len
        r.append('\n    {{ {0:20}, {1:20}, {2} }}, '.format('"'+toks[i].lower()+'"', toks[i].upper(), lens ))
    r.append('\n    {{ {0:20}, {1:<20}, {2} }}\n'.format("NULL",  0, 0))
    r.append('\n};\n')
    return r

#
#  generate parser.y
#
def gen_parser_file( toks ):
    toks = list(set(toks))
    toks.sort()
    r = []
    for m, n in itertools.groupby( toks, lambda x:x[0]):
        r.append('\n%token '+" ".join([i.upper() for i in list(n)]))
    r.append("\n")
    return r

#
#   generate ahelp.c
#
def gen_ahelp_file( cmds ):
    r=[]
    r.append('#include "my_parser.h"\n\n')
    r.append('char *helplist[MAX_CMD_NUM][MAX_CMD_WORD_NUM] = {\n')
    for c in cmds:
        c.insert(0,str(len(c)))
        r.append('\t{')
        r.append( ', '.join([ "\"{0}\"".format(re.sub(r'"',r'\"',x)) for x in c ]))
        r.append('},\n')
    r.append('};\n\n')

    r.append('char *tokenlist[MAX_CMD_WORD_NUM][MAX_CMD_NUM] = {\n')
    cols = make_help_list(cmds)
    for c in cols:
        r.append('\t{')
        r.append('"{0}"'.format(len(c)))
        if len(c) > 0 :
            r.append(',')
            rr=[]
            for x in [c[i:i+6] for i in range(0,len(c),6)]:
                rr.append(', '.join([ "\"{0}\"".format(xx) for xx in x])) 
            r.append('\n\t\t,'.join(rr))
        r.append('},\n')
    r.append('};\n')
    return r


#
# make help list from cmd list
#
def make_help_list(cmds):

    n = max( [ len(c) for c in cmds ] )
    cols = [[] for x in range(n)]
    for c in cmds:
        [cols[i].append(c[i]) for i in range(len(c)) if c[i] not in cols[i] ]
    cols = [ filter( is_token, c ) for c in cols ]
    return cols

#
# make token list from cmd list
#
def make_token_list(cmds):
    toks = list(itertools.chain.from_iterable(cmds))
    toks = filter( is_token, toks ) 
    toks = list(set(toks))
    toks.sort()
    return toks

'''
 解析cli.bnf文件

 文件格式:
 内部命令第一个string='&',之后是命令序列
 行首&表示内部命令,&与后边单词之间可以无空格
 TODO:支持注释

 参数：
 - input_file: 文件名
 - nodebug: True 返回的cmds中无内部命令

 返回值:
 - cmds: 命令列表,每个命令是一个字符串列表。
 - toks：token列表
'''
def parser_clibnf_file(input_file, nodebug=True ):

    cmds = [i.strip().split() for i in open(input_file).readlines()]
    cmds = filter( None, cmds ) 

    for x in cmds:
        if len(x[0]) >1 and x[0][0] == '&':
            x[0]=x[0].lstrip('&')
            x.insert(0,'&')

    toks = make_token_list(cmds)

    if nodebug :
        cmds = filter(not_debug,cmds)

    return cmds, toks


'''
 解析parser.output文件
 返回值:
 - cmds: 命令列表,每个命令是一个字符串列表。
 - toks：token列表
 - notoks：未使用的token列表
'''
def parser_output_file():
    cmds=""
    toks=""
    notoks=""
    r = open("parser.output").read() 
    m = re.search(r"Terminals unused in grammar\n(.*?)\n{3}",r, re.S )
    if m != None:
        c = m.group(1)
        notoks = filter(None,[i.strip() for i in c.split('\n')])

    m = re.search(r"Grammar\n(.*?)\n{3}",r,re.S)
    if m != None:
        c = m.group(1)
        cm = re.findall(r"\d+ \w+cmds:(.*?)\n{2}",c,re.S)
        cstring = "\n".join(cm) if cm != None else ""
        cstring = re.sub("\d+\s+\|","",cstring)
        cstring = re.sub("EOS","",cstring)
        cmds = [ i.strip().split(' ') for i in  cstring.split('\n') ]

    m = re.search(r"Terminals, with rules where they appear\n(.*?)\n{3}", r , re.S)
    if m != None:
        c = m.group(1)
        toks = re.findall(r"^[A-Z][A-Z_]*",c,re.M);
        toks.remove("INVALID_CHAR")
        toks.remove("EOS")

    return cmds,toks,notoks

def parser_parsery_file(parseryfile):
    c = open(parseryfile).read()
    m = re.search(r"\n%%(.*)\n%%",c,re.S)
    c = m.group(1)
    c = re.sub(r"\n\s+\}\|","\n\t}\n\t|",c, flags=re.S)
    c = re.sub(r"\{.*?\}\s+[;|]","",c, flags=re.S)
    t = re.findall(r"\b[A-Z]\w*",c, flags=re.S)
    t= list(set(t))
    t.sort()
    return t

#
# main
#
if __name__ == '__main__':
    c, t = parser_clibnf_file("cli.bnf")
    sys.stdout.writelines(gen_ahelp_file(c))
    sys.stdout.writelines(gen_parser_file(t))
    sys.stdout.writelines(gen_lookup_file(t))

