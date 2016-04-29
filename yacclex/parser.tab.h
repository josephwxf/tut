
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton interface for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.
   
   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     ACCESS = 258,
     ACK = 259,
     ADD = 260,
     ADMIN = 261,
     AES = 262,
     AGING = 263,
     ALERT = 264,
     ALL = 265,
     ALLOC = 266,
     ALLOCATION = 267,
     AND = 268,
     APPLY = 269,
     ARP = 270,
     ASSOCIATION_UD1 = 271,
     ASSOCIATION_UD2 = 272,
     ASSOCIATION_UD3 = 273,
     ASSOCIATION_UD4 = 274,
     AUTH = 275,
     AUTOBIND = 276,
     AUTODETECT = 277,
     BOARD = 278,
     BUILD = 279,
     CHECK = 280,
     CLEAR = 281,
     CLIENT = 282,
     COMPOUND_IPV4 = 283,
     COMPOUND_IPV6 = 284,
     COMPOUND_UD = 285,
     CONFIGURATION = 286,
     CONNECT = 287,
     CONSOLE = 288,
     COUNTER = 289,
     CRC = 290,
     CRC_16 = 291,
     CRC_32 = 292,
     CRIT = 293,
     CUSTOMER_RULE_ID = 294,
     D = 295,
     DDR = 296,
     DEBUG = 297,
     DEFAULT = 298,
     DELETE = 299,
     DES = 300,
     DESCRAMBLE = 301,
     DEVICE = 302,
     DIP = 303,
     DIRECTION = 304,
     DISABLE = 305,
     DOWN = 306,
     DPORT = 307,
     DROP = 308,
     EMERGENCY = 309,
     ENABLE = 310,
     ENTRYNUM = 311,
     EOS = 312,
     ERROR = 313,
     EXIT = 314,
     EXITSHELL = 315,
     EXPORT = 316,
     FAILOVER = 317,
     FATAL = 318,
     FILESIZE = 319,
     FILLHEAD = 320,
     FIN = 321,
     FLOAT = 322,
     FLOW = 323,
     FPGA = 324,
     FTP = 325,
     FW = 326,
     FWHEAD = 327,
     GENERAL = 328,
     GLOBAL_UD = 329,
     GW = 330,
     HASH = 331,
     HASHMODE = 332,
     HEAD = 333,
     HELP = 334,
     HOST = 335,
     ICMP = 336,
     ID = 337,
     IFCONFIG = 338,
     INFO = 339,
     INIT = 340,
     INSIDE = 341,
     INTERFACE = 342,
     INVALID_CHAR = 343,
     IP = 344,
     IP_POOL = 345,
     ISIS = 346,
     KEY = 347,
     L2 = 348,
     L3 = 349,
     L4 = 350,
     LEVEL = 351,
     LINK = 352,
     LIST = 353,
     LOCK = 354,
     LOG = 355,
     LOGIN = 356,
     MAC = 357,
     MAINTAINER = 358,
     MAINTENANCE = 359,
     MASK_IPV4 = 360,
     MASK_IPV6 = 361,
     MAX = 362,
     MD5 = 363,
     MIBINFO = 364,
     MODE = 365,
     MODULE = 366,
     MS = 367,
     NET = 368,
     NETFLOW = 369,
     NETMASK = 370,
     NO_MASK_RULE = 371,
     NO_SHUT = 372,
     NOAUTH = 373,
     NOMASK = 374,
     NONE = 375,
     NOTICE = 376,
     NTP = 377,
     NUM = 378,
     OFFSET = 379,
     OM = 380,
     OUTGROUP = 381,
     OUTPORT = 382,
     OUTSIDE = 383,
     OW3 = 384,
     PACKET = 385,
     PASSWD = 386,
     PASSWORD = 387,
     PATTERN = 388,
     PORT = 389,
     POS = 390,
     PRIORITY = 391,
     PRIV = 392,
     PRIVATE = 393,
     PROTOCOL = 394,
     PSH = 395,
     PUBLIC = 396,
     RCP = 397,
     REBOOT = 398,
     REDIRECT_IP = 399,
     REDIRECT_VLAN = 400,
     REMOVE = 401,
     RESET = 402,
     RESOURCE = 403,
     RESTART = 404,
     RESTORE = 405,
     RFC = 406,
     ROCOMMUNITY = 407,
     ROUTE = 408,
     ROUTING_PROTO = 409,
     RST = 410,
     RULE = 411,
     RWCOMMUNITY = 412,
     RX = 413,
     S = 414,
     SAMPLE = 415,
     SAVE = 416,
     SCALE = 417,
     SD = 418,
     SDSD = 419,
     SDSDP = 420,
     SE = 421,
     SEARCH = 422,
     SERVER = 423,
     SET = 424,
     SHA = 425,
     SHOW = 426,
     SHUTDOWN = 427,
     SINGLE_FIBER = 428,
     SIP = 429,
     SIZE = 430,
     SLOT = 431,
     SNMP = 432,
     SPORT = 433,
     SSH = 434,
     START = 435,
     STATE = 436,
     STATIC = 437,
     STATUS = 438,
     STOP = 439,
     STREAM = 440,
     STRIP = 441,
     SWITCHOVER = 442,
     SYN = 443,
     SYNC = 444,
     SYSCONTACT = 445,
     SYSLOCATION = 446,
     SYSLOG = 447,
     SYSNAME = 448,
     SYSTEM = 449,
     TABLE = 450,
     TCP = 451,
     TCPFLAG = 452,
     TELNET = 453,
     TFTP = 454,
     THRESHOLD = 455,
     TIME = 456,
     TIMEFORMAT = 457,
     TOK = 458,
     TRANSMIT = 459,
     TRAP = 460,
     TYPE = 461,
     UD = 462,
     UD0 = 463,
     UD1 = 464,
     UD10 = 465,
     UD11 = 466,
     UD12 = 467,
     UD13 = 468,
     UD14 = 469,
     UD15 = 470,
     UD16 = 471,
     UD17 = 472,
     UD18 = 473,
     UD19 = 474,
     UD2 = 475,
     UD20 = 476,
     UD21 = 477,
     UD22 = 478,
     UD23 = 479,
     UD24 = 480,
     UD25 = 481,
     UD26 = 482,
     UD27 = 483,
     UD28 = 484,
     UD29 = 485,
     UD3 = 486,
     UD30 = 487,
     UD31 = 488,
     UD32 = 489,
     UD33 = 490,
     UD34 = 491,
     UD35 = 492,
     UD4 = 493,
     UD5 = 494,
     UD6 = 495,
     UD7 = 496,
     UD8 = 497,
     UD9 = 498,
     UDP = 499,
     UNKNOWN = 500,
     UNLOCK = 501,
     UP = 502,
     UPDATE = 503,
     URG = 504,
     USER = 505,
     USERDATA = 506,
     USERNAME = 507,
     VERBOSE = 508,
     VERSION = 509,
     VLAN_POOL = 510,
     WARN = 511,
     WGET = 512,
     WIN_OFFSET = 513,
     WIN_UD = 514,
     WIN_WIDTH = 515,
     XGE_LAN = 516,
     XGE_WAN = 517,
     YEAR = 518,
     _INT_ = 519,
     _NAME_ = 520,
     _STRING_ = 521,
     _HELP_ = 522,
     _URL_ = 523,
     _IPADDR_ = 524,
     _IPV6ADDR_ = 525,
     _SMP_ = 526,
     _SM_ = 527,
     _MAC_ = 528
   };
#endif



#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 1676 of yacc.c  */
#line 3 "parser.y.footer"

    char *sptr;
    void *vptr;
    unsigned int ipaddr;
    unsigned short ipv6addr[8];
    unsigned long ival;
    int _smp_3d[3];
    int _sm_3d[2];
    unsigned char mac[6];



/* Line 1676 of yacc.c  */
#line 338 "parser.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


