#include <stdio.h>
#include <string.h>
#include <ctype.h>

#include "parser.tab.h"

typedef struct {
	char *name;
	int token;
	unsigned match_len;
} token_ent;

token_ent token_table[] = {

    { "access"            , ACCESS              , 3 }, 
    { "ack"               , ACK                 , 3 }, 
    { "add"               , ADD                 , 3 }, 
    { "admin"             , ADMIN               , 3 }, 
    { "aes"               , AES                 , 2 }, 
    { "aging"             , AGING               , 2 }, 
    { "alert"             , ALERT               , 3 }, 
    { "all"               , ALL                 , 3 }, 
    { "alloc"             , ALLOC               , 5 }, 
    { "allocation"        , ALLOCATION          , 6 }, 
    { "and"               , AND                 , 2 }, 
    { "apply"             , APPLY               , 2 }, 
    { "arp"               , ARP                 , 2 }, 
    { "association_ud1"   , ASSOCIATION_UD1     , 15 }, 
    { "association_ud2"   , ASSOCIATION_UD2     , 15 }, 
    { "association_ud3"   , ASSOCIATION_UD3     , 15 }, 
    { "association_ud4"   , ASSOCIATION_UD4     , 15 }, 
    { "auth"              , AUTH                , 4 }, 
    { "autobind"          , AUTOBIND            , 5 }, 
    { "autodetect"        , AUTODETECT          , 5 }, 
    { "board"             , BOARD               , 2 }, 
    { "build"             , BUILD               , 2 }, 
    { "check"             , CHECK               , 2 }, 
    { "clear"             , CLEAR               , 3 }, 
    { "client"            , CLIENT              , 3 }, 
    { "compound_ipv4"     , COMPOUND_IPV4       , 13 }, 
    { "compound_ipv6"     , COMPOUND_IPV6       , 13 }, 
    { "compound_ud"       , COMPOUND_UD         , 10 }, 
    { "configuration"     , CONFIGURATION       , 4 }, 
    { "connect"           , CONNECT             , 4 }, 
    { "console"           , CONSOLE             , 4 }, 
    { "counter"           , COUNTER             , 3 }, 
    { "crc"               , CRC                 , 3 }, 
    { "crc_16"            , CRC_16              , 5 }, 
    { "crc_32"            , CRC_32              , 5 }, 
    { "crit"              , CRIT                , 3 }, 
    { "customer_rule_id"  , CUSTOMER_RULE_ID    , 2 }, 
    { "d"                 , D                   , 1 }, 
    { "ddr"               , DDR                 , 2 }, 
    { "debug"             , DEBUG               , 3 }, 
    { "default"           , DEFAULT             , 3 }, 
    { "delete"            , DELETE              , 3 }, 
    { "des"               , DES                 , 3 }, 
    { "descramble"        , DESCRAMBLE          , 4 }, 
    { "device"            , DEVICE              , 3 }, 
    { "dip"               , DIP                 , 3 }, 
    { "direction"         , DIRECTION           , 3 }, 
    { "disable"           , DISABLE             , 3 }, 
    { "down"              , DOWN                , 2 }, 
    { "dport"             , DPORT               , 2 }, 
    { "drop"              , DROP                , 2 }, 
    { "emergency"         , EMERGENCY           , 2 }, 
    { "enable"            , ENABLE              , 3 }, 
    { "entrynum"          , ENTRYNUM            , 3 }, 
    { "eos"               , EOS                 , 2 }, 
    { "error"             , ERROR               , 2 }, 
    { "exit"              , EXIT                , 4 }, 
    { "exitshell"         , EXITSHELL           , 5 }, 
    { "export"            , EXPORT              , 3 }, 
    { "failover"          , FAILOVER            , 3 }, 
    { "fatal"             , FATAL               , 3 }, 
    { "filesize"          , FILESIZE            , 4 }, 
    { "fillhead"          , FILLHEAD            , 4 }, 
    { "fin"               , FIN                 , 3 }, 
    { "float"             , FLOAT               , 4 }, 
    { "flow"              , FLOW                , 4 }, 
    { "fpga"              , FPGA                , 2 }, 
    { "ftp"               , FTP                 , 2 }, 
    { "fw"                , FW                  , 2 }, 
    { "fwhead"            , FWHEAD              , 3 }, 
    { "general"           , GENERAL             , 2 }, 
    { "global_ud"         , GLOBAL_UD           , 2 }, 
    { "gw"                , GW                  , 2 }, 
    { "hash"              , HASH                , 4 }, 
    { "hashmode"          , HASHMODE            , 5 }, 
    { "head"              , HEAD                , 3 }, 
    { "help"              , HELP                , 3 }, 
    { "host"              , HOST                , 2 }, 
    { "icmp"              , ICMP                , 2 }, 
    { "id"                , ID                  , 2 }, 
    { "ifconfig"          , IFCONFIG            , 2 }, 
    { "info"              , INFO                , 3 }, 
    { "init"              , INIT                , 3 }, 
    { "inside"            , INSIDE              , 3 }, 
    { "interface"         , INTERFACE           , 3 }, 
    { "invalid_char"      , INVALID_CHAR        , 3 }, 
    { "ip"                , IP                  , 2 }, 
    { "ip_pool"           , IP_POOL             , 3 }, 
    { "isis"              , ISIS                , 2 }, 
    { "key"               , KEY                 , 1 }, 
    { "l2"                , L2                  , 2 }, 
    { "l3"                , L3                  , 2 }, 
    { "l4"                , L4                  , 2 }, 
    { "level"             , LEVEL               , 2 }, 
    { "link"              , LINK                , 3 }, 
    { "list"              , LIST                , 3 }, 
    { "lock"              , LOCK                , 3 }, 
    { "log"               , LOG                 , 3 }, 
    { "login"             , LOGIN               , 4 }, 
    { "mac"               , MAC                 , 3 }, 
    { "maintainer"        , MAINTAINER          , 6 }, 
    { "maintenance"       , MAINTENANCE         , 6 }, 
    { "mask_ipv4"         , MASK_IPV4           , 9 }, 
    { "mask_ipv6"         , MASK_IPV6           , 9 }, 
    { "max"               , MAX                 , 3 }, 
    { "md5"               , MD5                 , 2 }, 
    { "mibinfo"           , MIBINFO             , 2 }, 
    { "mode"              , MODE                , 4 }, 
    { "module"            , MODULE              , 4 }, 
    { "ms"                , MS                  , 2 }, 
    { "net"               , NET                 , 3 }, 
    { "netflow"           , NETFLOW             , 4 }, 
    { "netmask"           , NETMASK             , 4 }, 
    { "no_mask_rule"      , NO_MASK_RULE        , 4 }, 
    { "no_shut"           , NO_SHUT             , 4 }, 
    { "noauth"            , NOAUTH              , 3 }, 
    { "nomask"            , NOMASK              , 3 }, 
    { "none"              , NONE                , 3 }, 
    { "notice"            , NOTICE              , 3 }, 
    { "ntp"               , NTP                 , 2 }, 
    { "num"               , NUM                 , 2 }, 
    { "offset"            , OFFSET              , 2 }, 
    { "om"                , OM                  , 2 }, 
    { "outgroup"          , OUTGROUP            , 4 }, 
    { "outport"           , OUTPORT             , 4 }, 
    { "outside"           , OUTSIDE             , 4 }, 
    { "ow3"               , OW3                 , 2 }, 
    { "packet"            , PACKET              , 3 }, 
    { "passwd"            , PASSWD              , 6 }, 
    { "password"          , PASSWORD            , 6 }, 
    { "pattern"           , PATTERN             , 3 }, 
    { "port"              , PORT                , 3 }, 
    { "pos"               , POS                 , 3 }, 
    { "priority"          , PRIORITY            , 4 }, 
    { "priv"              , PRIV                , 4 }, 
    { "private"           , PRIVATE             , 5 }, 
    { "protocol"          , PROTOCOL            , 3 }, 
    { "psh"               , PSH                 , 2 }, 
    { "public"            , PUBLIC              , 2 }, 
    { "rcp"               , RCP                 , 2 }, 
    { "reboot"            , REBOOT              , 3 }, 
    { "redirect_ip"       , REDIRECT_IP         , 10 }, 
    { "redirect_vlan"     , REDIRECT_VLAN       , 10 }, 
    { "remove"            , REMOVE              , 3 }, 
    { "reset"             , RESET               , 4 }, 
    { "resource"          , RESOURCE            , 4 }, 
    { "restart"           , RESTART             , 5 }, 
    { "restore"           , RESTORE             , 5 }, 
    { "rfc"               , RFC                 , 2 }, 
    { "rocommunity"       , ROCOMMUNITY         , 3 }, 
    { "route"             , ROUTE               , 5 }, 
    { "routing_proto"     , ROUTING_PROTO       , 5 }, 
    { "rst"               , RST                 , 2 }, 
    { "rule"              , RULE                , 2 }, 
    { "rwcommunity"       , RWCOMMUNITY         , 2 }, 
    { "rx"                , RX                  , 2 }, 
    { "s"                 , S                   , 1 }, 
    { "sample"            , SAMPLE              , 3 }, 
    { "save"              , SAVE                , 3 }, 
    { "scale"             , SCALE               , 2 }, 
    { "sd"                , SD                  , 2 }, 
    { "sdsd"              , SDSD                , 4 }, 
    { "sdsdp"             , SDSDP               , 5 }, 
    { "se"                , SE                  , 2 }, 
    { "search"            , SEARCH              , 3 }, 
    { "server"            , SERVER              , 3 }, 
    { "set"               , SET                 , 3 }, 
    { "sha"               , SHA                 , 3 }, 
    { "show"              , SHOW                , 3 }, 
    { "shutdown"          , SHUTDOWN            , 3 }, 
    { "single_fiber"      , SINGLE_FIBER        , 3 }, 
    { "sip"               , SIP                 , 3 }, 
    { "size"              , SIZE                , 3 }, 
    { "slot"              , SLOT                , 2 }, 
    { "snmp"              , SNMP                , 2 }, 
    { "sport"             , SPORT               , 2 }, 
    { "ssh"               , SSH                 , 2 }, 
    { "start"             , START               , 4 }, 
    { "state"             , STATE               , 5 }, 
    { "static"            , STATIC              , 5 }, 
    { "status"            , STATUS              , 5 }, 
    { "stop"              , STOP                , 3 }, 
    { "stream"            , STREAM              , 4 }, 
    { "strip"             , STRIP               , 4 }, 
    { "switchover"        , SWITCHOVER          , 2 }, 
    { "syn"               , SYN                 , 3 }, 
    { "sync"              , SYNC                , 4 }, 
    { "syscontact"        , SYSCONTACT          , 4 }, 
    { "syslocation"       , SYSLOCATION         , 6 }, 
    { "syslog"            , SYSLOG              , 6 }, 
    { "sysname"           , SYSNAME             , 4 }, 
    { "system"            , SYSTEM              , 4 }, 
    { "table"             , TABLE               , 2 }, 
    { "tcp"               , TCP                 , 3 }, 
    { "tcpflag"           , TCPFLAG             , 4 }, 
    { "telnet"            , TELNET              , 2 }, 
    { "tftp"              , TFTP                , 2 }, 
    { "threshold"         , THRESHOLD           , 2 }, 
    { "time"              , TIME                , 4 }, 
    { "timeformat"        , TIMEFORMAT          , 5 }, 
    { "tok"               , TOK                 , 2 }, 
    { "transmit"          , TRANSMIT            , 4 }, 
    { "trap"              , TRAP                , 4 }, 
    { "type"              , TYPE                , 2 }, 
    { "ud"                , UD                  , 2 }, 
    { "ud0"               , UD0                 , 3 }, 
    { "ud1"               , UD1                 , 3 }, 
    { "ud10"              , UD10                , 4 }, 
    { "ud11"              , UD11                , 4 }, 
    { "ud12"              , UD12                , 4 }, 
    { "ud13"              , UD13                , 4 }, 
    { "ud14"              , UD14                , 4 }, 
    { "ud15"              , UD15                , 4 }, 
    { "ud16"              , UD16                , 4 }, 
    { "ud17"              , UD17                , 4 }, 
    { "ud18"              , UD18                , 4 }, 
    { "ud19"              , UD19                , 4 }, 
    { "ud2"               , UD2                 , 3 }, 
    { "ud20"              , UD20                , 4 }, 
    { "ud21"              , UD21                , 4 }, 
    { "ud22"              , UD22                , 4 }, 
    { "ud23"              , UD23                , 4 }, 
    { "ud24"              , UD24                , 4 }, 
    { "ud25"              , UD25                , 4 }, 
    { "ud26"              , UD26                , 4 }, 
    { "ud27"              , UD27                , 4 }, 
    { "ud28"              , UD28                , 4 }, 
    { "ud29"              , UD29                , 4 }, 
    { "ud3"               , UD3                 , 3 }, 
    { "ud30"              , UD30                , 4 }, 
    { "ud31"              , UD31                , 4 }, 
    { "ud32"              , UD32                , 4 }, 
    { "ud33"              , UD33                , 4 }, 
    { "ud34"              , UD34                , 4 }, 
    { "ud35"              , UD35                , 4 }, 
    { "ud4"               , UD4                 , 3 }, 
    { "ud5"               , UD5                 , 3 }, 
    { "ud6"               , UD6                 , 3 }, 
    { "ud7"               , UD7                 , 3 }, 
    { "ud8"               , UD8                 , 3 }, 
    { "ud9"               , UD9                 , 3 }, 
    { "udp"               , UDP                 , 3 }, 
    { "unknown"           , UNKNOWN             , 3 }, 
    { "unlock"            , UNLOCK              , 3 }, 
    { "up"                , UP                  , 2 }, 
    { "update"            , UPDATE              , 3 }, 
    { "urg"               , URG                 , 2 }, 
    { "user"              , USER                , 4 }, 
    { "userdata"          , USERDATA            , 5 }, 
    { "username"          , USERNAME            , 5 }, 
    { "verbose"           , VERBOSE             , 4 }, 
    { "version"           , VERSION             , 4 }, 
    { "vlan_pool"         , VLAN_POOL           , 2 }, 
    { "warn"              , WARN                , 2 }, 
    { "wget"              , WGET                , 2 }, 
    { "win_offset"        , WIN_OFFSET          , 5 }, 
    { "win_ud"            , WIN_UD              , 5 }, 
    { "win_width"         , WIN_WIDTH           , 5 }, 
    { "xge_lan"           , XGE_LAN             , 5 }, 
    { "xge_wan"           , XGE_WAN             , 5 }, 
    { "year"              , YEAR                , 1 }, 
    { NULL                , 0                   , 0 }

};

int str_match(char *str1, char *str2, int min_match)
{
	int len = 0;

	while ((*str1 != '\0') && (*str2 != '\0')) {
		if (toupper(*str1) != toupper(*str2)) {
			return 1;
		}
		str1++;
		str2++;
		len++;
	}

	if ((*str1 == '\0') && (*str2 != '\0')) {
		return 2;
	}

	return !(len >= min_match);
}

int find_token(char *input)
{
	token_ent *token;

	token = token_table;
	while (token->match_len != 0) {
		if (tolower(input[0]) == token->name[0]) {
			if (!str_match(token->name, input, token->match_len)) {
				return token->token;
			}
		}
		if (tolower(input[0]) < token->name[0])
			break;
		token++;
	}

	return 0;
}

char *back_token_str(char *input)
{
	token_ent *token;

	token = token_table;
	while (token->match_len != 0) {
		if (tolower(input[0]) == token->name[0]) {
			if (!str_match (token->name, input, token->match_len)) {
				return token->name;
			}
		}
		if (tolower(input[0]) < token->name[0])
			break;
		token++;
	}

	return (char *)NULL;
}
