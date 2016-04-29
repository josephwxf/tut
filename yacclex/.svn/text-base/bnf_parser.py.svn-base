#!/usr/bin/python
# This Python file uses the following encoding: utf-8

"""
   bnf_parser.py -- 一个cli工具,帮助自动生成yacc文件的token声明.

   Usage: python bnf_parser.py -i input_file [-l lookup_file] [-p parser_file] [-a ahelp_file]

   -i 输入bnf文件
   -p 生成yacc文件的token声明
   -l 生成lex文件需要的关键词查找表，lookup.c
   -a 生成readline tab键自动补齐需要的关键词查找表，ahelp.c

"""

import sys
import getopt
import string
import re
import parser_tools

"""
    命令行参数解析 
"""
def parser_argument(argv):

    try:
        opts, args = getopt.getopt(argv, "i:l:p:a:", ["input_file", "lookup_file", "parser_file", "ahelp_file"])
    except getopt.GetoptError:
        return "", "", "", ""

    input_file = ""
    lookup_file = ""
    parser_file = ""
    ahelp_file = ""

    for opt, arg in opts:
        if opt in ["-i", "--input_file"]:
            input_file = arg
        elif opt in ["-l", "--lookup_file"]:
            lookup_file = arg
        elif opt in ["-p", "--parser_file"]:
            parser_file = arg
        elif opt in ["-a", "--ahelp_file"]:
            ahelp_file = arg

    return (input_file, lookup_file, parser_file, ahelp_file)


def parser_input_file(input_file):
    return parser_tools.parser_clibnf_file(input_file)

"""
    自动生成 parser.y and lookup.c 
"""

def gen_lookup_parser_file(lookup_file, parser_file, toks ):
    if lookup_file != "":
        fout_lookup = open(lookup_file, "w")
        if fout_lookup != None:
            fout_lookup.writelines(open(lookup_file + ".header").readlines())
            fout_lookup.writelines(parser_tools.gen_lookup_file(toks))
            fout_lookup.writelines(open(lookup_file + ".footer").readlines())
            fout_lookup.close()
    
    if parser_file != "" :
        fout_parser = open(parser_file, "w")
        if fout_parser is not None:
            fout_parser.writelines(open(parser_file + ".header").readlines())
            fout_parser.writelines(parser_tools.gen_parser_file(toks))
            fout_parser.writelines(open(parser_file + ".footer").readlines())
            fout_parser.close()
    
"""
    自动生成 ahelp.c
"""

def gen_ahelp_file(ahelp_file, cmd ):
    c = parser_tools.gen_ahelp_file(cmd)
    if ahelp_file != "":
        fout_ahelp = open(ahelp_file, "w")
        if fout_ahelp is not None:
           fout_ahelp.writelines(c)
           fout_ahelp.close()


if __name__ == '__main__':

    input_file, lookup_file, parser_file, ahelp_file = parser_argument(sys.argv[1:])
    if input_file != "":
        cmd_list ,token_list = parser_input_file(input_file)
    else:
        sys.stderr.write(__doc__)
        sys.exit(1)

    token_list_fix= [ "ack", "association_ud1", "association_ud2" , "association_ud3", "association_ud4",
            "compound_ipv4", "compound_ipv6", "compound_ud", "crc_16", "crc_32", "customer_rule_id",
            "dip", "dport", "eos", "fatal", "fin", "global_ud", "icmp", "invalid_char", "ip_pool",
            "isis", "key", "l2", "l3", "l4", "maintainer", "mask_ipv4", "mask_ipv6", "md5", "no_mask_rule",
	        "no_shut", "ow3", "protocol", "psh", "redirect_ip", "redirect_vlan", "routing_proto", "rst",
            "sip", "sport", "ssh", "syn", "size", "single_fiber", "table", "tcpflag", "ud", "ud0", "ud1",
            "ud2", "ud3", "ud4", "ud5", "ud6", "ud7", "ud8", "ud9", "ud10", "ud11", "ud12", "ud13", "ud14",
            "ud15", "ud16", "ud17", "ud18", "ud19", "ud20", "ud21", "ud22", "ud23", "ud24", "ud25", "ud26",
            "ud27", "ud28", "ud29", "ud30", "ud31", "ud32", "ud33", "ud34", "ud35", "urg", "vlan_pool", "win_offset",
            "win_ud", "win_width", "xge_lan", "xge_wan" ]
    token_list.extend( token_list_fix) 

    if lookup_file != "" or parser_file != "":
        gen_lookup_parser_file(lookup_file, parser_file, token_list )

    if ahelp_file != "":
        gen_ahelp_file(ahelp_file, cmd_list)

# vim:expandtab

