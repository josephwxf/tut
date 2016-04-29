%{

#define YYERROR_VERBOSE

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include <termios.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <readline/readline.h>
#include <readline/history.h>

#include "my_parser.h"
#include "my_lexer.h"
#include "appdefs.h"
#include "def.h"
#include "ruledefs.h"
#include "log.h"
#include "hyphy20g_common.h"
static int EN;
extern char text_cmd[MAX_CLI_CMD_LEN];
#define printPrompt()   do {                        \
    if (load_config_end && !hy_is_interactive()) {  \
        printf("\004%3d\n", EN);                    \
    }                                              \
    fflush(stdout);                                 \
} while (0)

#define printEnq(str)   do {                        \
    if (hy_is_interactive())                       \
        printf(str);                                \
	else                                          \
        printf("\005%s\n", str);                    \
    fflush(stdout);                                 \
} while (0)

#define CHECK_SMP_VALID(slots, modules, ports) do {     \
    if (slots == 0 || modules == 0 || ports == 0) {     \
        printf("Invalid input.\n");                   \
        EN = OW_RST_INVLD_PRM;                          \
        YYERROR;                                        \
    }                                                   \
} while (0)

static int EN = 0;
static int load_config_end = 0;
extern int g_load_file_flag;
int g_compound_ud = 0;

int end_of_line = 0;

struct class_entry_t g_class_entry;
struct Pool_B g_pool;
struct LogShowFilter_B g_log_show_filter;

int yyerror(const char *s)
{
    EN = OW_RST_INVLD_PRM;
    fprintf(stderr, "%s\n", s);
    return 0;
}

static void cli_reset_command(void);

%}


%token ACCESS ACK ADD ADMIN AES AGING ALERT ALL ALLOC ALLOCATION AND APPLY ARP ASSOCIATION_UD1 ASSOCIATION_UD2 ASSOCIATION_UD3 ASSOCIATION_UD4 AUTH AUTOBIND AUTODETECT
%token BOARD BUILD
%token CHECK CLEAR CLIENT COMPOUND_IPV4 COMPOUND_IPV6 COMPOUND_UD CONFIGURATION CONNECT CONSOLE COUNTER CRC CRC_16 CRC_32 CRIT CUSTOMER_RULE_ID
%token D DDR DEBUG DEFAULT DELETE DES DESCRAMBLE DEVICE DIP DIRECTION DISABLE DOWN DPORT DROP
%token EMERGENCY ENABLE ENTRYNUM EOS ERROR EXIT EXITSHELL EXPORT
%token FAILOVER FATAL FILESIZE FILLHEAD FIN FLOAT FLOW FPGA FTP FW FWHEAD
%token GENERAL GLOBAL_UD GW
%token HASH HASHMODE HEAD HELP HOST
%token ICMP ID IFCONFIG INFO INIT INSIDE INTERFACE INVALID_CHAR IP IP_POOL ISIS
%token KEY
%token L2 L3 L4 LEVEL LINK LIST LOCK LOG LOGIN
%token MAC MAINTAINER MAINTENANCE MASK_IPV4 MASK_IPV6 MAX MD5 MIBINFO MODE MODULE MS
%token NET NETFLOW NETMASK NO_MASK_RULE NO_SHUT NOAUTH NOMASK NONE NOTICE NTP NUM
%token OFFSET OM OUTGROUP OUTPORT OUTSIDE OW3
%token PACKET PASSWD PASSWORD PATTERN PORT POS PRIORITY PRIV PRIVATE PROTOCOL PSH PUBLIC
%token RCP REBOOT REDIRECT_IP REDIRECT_VLAN REMOVE RESET RESOURCE RESTART RESTORE RFC ROCOMMUNITY ROUTE ROUTING_PROTO RST RULE RWCOMMUNITY RX
%token S SAMPLE SAVE SCALE SD SDSD SDSDP SE SEARCH SERVER SET SHA SHOW SHUTDOWN SINGLE_FIBER SIP SIZE SLOT SNMP SPORT SSH START STATE STATIC STATUS STOP STREAM STRIP SWITCHOVER SYN SYNC SYSCONTACT SYSLOCATION SYSLOG SYSNAME SYSTEM
%token TABLE TCP TCPFLAG TELNET TFTP THRESHOLD TIME TIMEFORMAT TOK TRANSMIT TRAP TYPE
%token UD UD0 UD1 UD10 UD11 UD12 UD13 UD14 UD15 UD16 UD17 UD18 UD19 UD2 UD20 UD21 UD22 UD23 UD24 UD25 UD26 UD27 UD28 UD29 UD3 UD30 UD31 UD32 UD33 UD34 UD35 UD4 UD5 UD6 UD7 UD8 UD9 UDP UNKNOWN UNLOCK UP UPDATE URG USER USERDATA USERNAME
%token VERBOSE VERSION VLAN_POOL
%token WARN WGET WIN_OFFSET WIN_UD WIN_WIDTH
%token XGE_LAN XGE_WAN
%token YEAR
#line 2 "parser.y.footer"

%union {
    char *sptr;
    void *vptr;
    unsigned int ipaddr;
    unsigned short ipv6addr[8];
    unsigned long ival;
    int _smp_3d[3];
    int _sm_3d[2];
    unsigned char mac[6];
}

%token <ival> _INT_ 
%token <sptr> _NAME_ _STRING_ _HELP_ _URL_
%token <ipaddr> _IPADDR_
%token <ipv6addr> _IPV6ADDR_
%token <_smp_3d> _SMP_
%token <_sm_3d> _SM_
%token <mac> _MAC_

%type <ival> command syscmds rulecmds octencmds ifcmds dbgcmds upgradecmds logcmds snmpcmds testcmds

%type <ival> able all_user association_id associate_ud shutdown
%type <ival> ce ce_dip ce_dport ce_floatud ce_protocol ce_routing_proto ce_sip ce_size ce_sport ce_tcpflag ce_userdata ce_userdatas class_entry crctype customer_id
%type <ival> device_id ddr_table_type ddr_table_types direction_type 
%type <ival> entry_num
%type <ival> hash_mode
%type <ival> iftype ip ip_search_mode pool
%type <ival> log_user log_pri login_tool 
%type <ival> mibinfo_type
%type <ival> outgroup_id offset
%type <ival> rule_type redirect_ip redirect_vlan
%type <ival> slot_id static snmp_op snmp_param snmp_community snmp_auth_type snmp_priv_type snmp_access
%type <ival> table_id table_start_addr tcpflag tcpflags time_format
%type <ival> ud_id user_id ud_mode
%type <ival> tid


%type <vptr> smp sm
%left ':'
%left '-'
%left ','
%left '/'

%%	

input:
    |  input line
    {
        printPrompt();
    } 
    ;

line:
    EOS
    {
        cli_reset_command();
    }
    |  command
    {
        cli_reset_command();
    }
    | error EOS
    {
        cli_reset_command();
        yyerrok;
    }
    ;

command:
       syscmds
    |   rulecmds
    |   octencmds
    |   ifcmds
    |   dbgcmds
    |    logcmds
    |   upgradecmds
    {
        fprintf(stdout,"cli_log_cmd(EN,LV_INFO,text_cmd)\n");
    }
    |   snmpcmds
	|   testcmds
    |   EXIT EOS
    {
        fprintf(stdout,"cli_log_cmd(EN,LV_INFO,text_cmd)\n");
        YYACCEPT;
    }
    ;

syscmds:
    SHOW OM SWITCHOVER STATE EOS
    {
        fprintf(stdout,"cli_show_om_switchover_state()\n");
        fprintf(stdout,"cli_log_cmd(EN,LV_INFO,text_cmd)\n");
    }
    |   SET NTP SERVER IP _IPADDR_ EOS
    {
        fprintf(stdout,"cli_set_ntp_server_ip($5)\n");
        fprintf(stdout,"cli_log_cmd(EN,LV_INFO,text_cmd)\n");
    }
    |   SET NTP DISABLE EOS
    {
        fprintf(stdout,"cli_disable_ntp()\n");
        fprintf(stdout,"cli_log_cmd(EN,LV_INFO,text_cmd)\n");
    }
    |   SHOW NTP CONFIGURATION EOS
    {
        fprintf(stdout,"cli_show_ntp_config()\n");
        fprintf(stdout,"cli_log_cmd(EN,LV_INFO,text_cmd)\n");
    }
    |   SET SYSTEM TIME _STRING_ EOS
    {
        fprintf(stdout,"cli_set_system_time($4)\n");
        fprintf(stdout,"cli_log_cmd(EN,LV_INFO,text_cmd)\n");
    }
    |   SHOW SYSTEM EOS
    {
        fprintf(stdout,"cli_show_system()\n");
    }
    |   SHOW SLOT slot_id INFO EOS
    {
        fprintf(stdout,"cli_show_slot_info($3)\n");
    }
    |    SHOW BOARD INFO EOS
    {
        fprintf(stdout,"cli_show_board_info()\n");
    }
    |   SHOW BOARD STATUS EOS
    {
        fprintf(stdout,"cli_show_board_status()\n");
    }
    |   PASSWD EOS
    {
        fprintf(stdout,"cli_set_user_passwd(buf)\n");
    }
    |   OW3 SET USER all_user EOS
    {
        fprintf(stdout,"cli_set_user($4)\n");
    }
    |   SET USER all_user LOGIN login_tool able EOS
    {
        if ($3 == 0 && $5 == LOGIN_MODE_CONSOLE) {
            printf("Invalid arguement.\n");
        } else {
            fprintf(stdout,"cli_set_user_login($3, $5, $6)\n");
        }
    }
    |   RESET USER all_user PASSWD EOS
    {
        fprintf(stdout,"cli_reset_user_passwd($3)\n");
    }
    |   SET DEVICE ID device_id EOS
    {
        fprintf(stdout,"cli_set_device_id($4)\n");
    }
    |   SHOW CONFIGURATION EOS
    {
        fprintf(stdout,"cli_show_config()\n");
    }
    |   SAVE CONFIGURATION EOS
    {
        fprintf(stdout,"cli_save_config()\n");
    }
    |   RESTORE CONFIGURATION EOS
    {
        char *answer = NULL;
        printf(PROMPT("Restore the configuration.\n"));
        printEnq(PROMPT("Do you want to continue? (y/n): "));
        answer = readline("");
        if ((answer[0] == 'Y') || (answer[0] == 'y'))
            fprintf(stdout,"cli_restore_config()\n");
        free(answer);
    }
    |   SHOW RULE EOS
    {
        fprintf(stdout,"cli_show_rule()\n");
    }
    |    SHOW USER ACCESS EOS
    {
        fprintf(stdout,"cli_show_user_access()\n");
    }
    |   EXITSHELL EOS
    {
        fprintf(stdout,"cli_log_cmd(EN,LV_INFO,text_cmd)\n");
        fprintf(stdout,"cli_exit_shell()\n");
    }
    |   RESTART EOS
    {
        char *answer = NULL;
        printf(PROMPT("Restart the server.\n"));
        printEnq(PROMPT("Do you want to continue? (y/n): "));
        answer = readline("");
        if ((answer[0] == 'Y') || (answer[0] == 'y'))
            fprintf(stdout,"cli_restart()\n");
            fprintf(stdout,"cli_log_cmd(EN,LV_INFO,text_cmd)\n");
        free(answer);
    }
    |   REBOOT EOS
    {
        char *answer = NULL;
        printf(PROMPT("Reboot the system.\n"));
        printEnq(PROMPT("Do you want to continue? (y/n): "));
        answer = readline("");
        if ((answer[0] == 'Y') || (answer[0] == 'y'))
            fprintf(stdout,"cli_reboot()\n");
            fprintf(stdout,"cli_log_cmd(EN,LV_INFO,text_cmd)\n");
        free(answer);
    }
    |   REBOOT SLOT slot_id EOS
    {
        char *answer = NULL;
        printf(PROMPT("Reboot the slot %ld.\n"), $3);
        printEnq(PROMPT("Do you want to continue? (y/n): "));
        answer = readline("");
        if ((answer[0] == 'Y') || (answer[0] == 'y'))
            fprintf(stdout,"cli_reboot_slot($3)\n");
        free(answer);
    }
    |   REBOOT SLOT ALL EOS
    {
        char *answer = NULL;
        printf(PROMPT("Reboot all slot.\n"));
        printEnq(PROMPT("Do you want to continue? (y/n): "));
        answer = readline("");
        if ((answer[0] == 'Y') || (answer[0] == 'y'))
            fprintf(stdout,"cli_reboot_slot(0)\n");
        free(answer);
    }
    |   ARP SHOW EOS
    {
        fprintf(stdout,"cli_arp_show()\n");
        fprintf(stdout,"cli_log_cmd(EN,LV_INFO,text_cmd)\n");
    }
    |   ARP ADD _IPADDR_ _MAC_ EOS
    {
        fprintf(stdout,"cli_arp_add($3, $4)\n");
        fprintf(stdout,"cli_log_cmd(EN,LV_INFO,text_cmd)\n");
    }
    |   ARP DELETE _IPADDR_ EOS
    {
        fprintf(stdout,"cli_arp_delete($3)\n");
        fprintf(stdout,"cli_log_cmd(EN,LV_INFO,text_cmd)\n");
    }
    |   IFCONFIG _IPADDR_ NETMASK _IPADDR_ EOS
    {
        fprintf(stdout,"cli_set_ip_addr($2, $4)\n");
        fprintf(stdout,"cli_log_cmd(EN,LV_INFO,text_cmd)\n");
    }
    |   ROUTE SHOW EOS
    {
        fprintf(stdout,"cli_route_show()\n");
        fprintf(stdout,"cli_log_cmd(EN,LV_INFO,text_cmd)\n");
    }
    |   ROUTE ADD NET _IPADDR_ NETMASK _IPADDR_ GW _IPADDR_ EOS
    {
        fprintf(stdout,"cli_route_add_net($4, $6, $8)\n");
        fprintf(stdout,"cli_log_cmd(EN,LV_INFO,text_cmd)\n");
    }
    |   ROUTE ADD HOST _IPADDR_ GW _IPADDR_ EOS
    {
        fprintf(stdout,"cli_route_add_host($4, $6)\n");
        fprintf(stdout,"cli_log_cmd(EN,LV_INFO,text_cmd)\n");
    }
    |   ROUTE DELETE NET _IPADDR_ NETMASK _IPADDR_ GW _IPADDR_ EOS
    {
        fprintf(stdout,"cli_route_del_net($4, $6, $8)\n");
        fprintf(stdout,"cli_log_cmd(EN,LV_INFO,text_cmd)\n");
    }
    |   ROUTE DELETE HOST _IPADDR_ GW _IPADDR_ EOS
    {
        fprintf(stdout,"cli_route_del_host($4, $6)\n");
        fprintf(stdout,"cli_log_cmd(EN,LV_INFO,text_cmd)\n");
    }
    |   SHOW USER all_user PASSWD EOS
    {
        fprintf(stdout,"cli_show_user_passwd($3)\n");
    }
    |    SET CLIENT CONNECT MAX _INT_ EOS
    {
        fprintf(stdout,"cli_set_connect_max($5)\n");
    }
    |    SHOW CLIENT CONNECT MAX EOS
    {
        fprintf(stdout,"cli_show_connect_max()\n");
    }
    ;

rulecmds:
    SHOW PUBLIC RESOURCE ALLOCATION EOS
    {
        fprintf(stdout,"cli_show_user_resource_allocation(0, 0)\n");
    }
    |   SHOW USER user_id RESOURCE ALLOCATION EOS
    {
        fprintf(stdout,"cli_show_user_resource_allocation($3, 0)\n");
    }
    |   SHOW USER user_id RESOURCE ALLOCATION VERBOSE EOS
    {
        fprintf(stdout,"cli_show_user_resource_allocation($3, 1)\n");
    }
    |   ADD static RULE class_entry DROP customer_id EOS
    {
        fprintf(stdout,"cli_add_class_entry(&g_class_entry, 0, $2)\n");
    }
    |   ADD static RULE class_entry FW OUTGROUP outgroup_id pool customer_id EOS
    {
        fprintf(stdout,"cli_add_class_entry(&g_class_entry, ((1<<8)|$7), $2)\n");
    }
    |   ADD static RULE class_entry  HEAD FW OUTGROUP outgroup_id pool customer_id EOS
    {
        fprintf(stdout,"cli_add_class_entry(&g_class_entry, ((2<<8)|$8), $2)\n");
    }
    |   DELETE RULE class_entry EOS
    {
        fprintf(stdout,"cli_delete_class_entry(&g_class_entry)\n");
    }
    |   DELETE RULE ALL EOS
    {
        fprintf(stdout,"cli_delete_all_class_entry()\n");
    }
    |   CHECK RULE class_entry EOS
    {
        fprintf(stdout,"cli_check_class_entry(&g_class_entry)\n");
    }
    |   SET FLOAT USERDATA  RULE APPLY EOS
    {
        fprintf(stdout,"cli_set_float_ud_rule_apply()\n");
    }
    |   SET IP SEARCH MODE ip_search_mode EOS
    {
        fprintf(stdout,"cli_set_ip_search_mode($5)\n");
    }
    |   SET ud_id MODE ud_mode OFFSET offset EOS
    {
        fprintf(stdout,"cli_set_ud_offset($2,$4,$6)\n");
    }
    |   SET DDR TABLE table_id able able ddr_table_types table_start_addr EOS
    {   
        fprintf(stdout,"cli_set_nomask_rule_complex_table_type($4, $5, $6, $7, $8)\n");
    }
    |   ALLOC RULE ENTRYNUM APPLY EOS
    {
        fprintf(stdout,"cli_alloc_rule_entrynum_apply()\n");
    }
    |   ALLOC PUBLIC RULE TYPE rule_type ENTRYNUM entry_num EOS
    {
        fprintf(stdout,"cli_alloc_user_rule_type_entrynum(0, $5, $7)\n");
    }
    |   ALLOC USER user_id RULE TYPE rule_type ENTRYNUM entry_num EOS
    {
        fprintf(stdout,"cli_alloc_user_rule_type_entrynum($3, $6, $8)\n");
    }
    |   ALLOC RULE ENTRYNUM DEFAULT EOS
    {
        fprintf(stdout,"cli_alloc_rule_entrynum_default()\n");
    }
    |   SET RULE NOMASK PATTERN table_id DISABLE EOS
    {   
        fprintf(stdout,"cli_set_nomask_rule_complex_table_type($5, 0, 0, 0, 0)\n");
    }
    |   SHOW RULE NOMASK CONFIGURATION EOS
    {
        fprintf(stdout,"cli_show_rule_nomask_config()\n");
    }
    |   SET RULE NOMASK PATTERN table_id ddr_table_types EOS
    {   
        fprintf(stdout,"cli_set_nomask_rule_complex_table_type($5, 1, 0, $6, tmp[$5-1])\n");
    }
    |   INIT EOS
    {
        fprintf(stdout,"cli_init_rule()\n");
    }
    |   SYNC EOS
    {
        fprintf(stdout,"cli_sync_rule()\n");
    }
    |   SHOW COUNTER _INT_
    {
        if ($3 < 1 || $3 > 2) {
            printf("the int must be 1 or 2. means ac2240 or ac2820.\n");
            break;
        }
        fprintf(stdout,"cli_show_counter($3)\n");
    }
    |   CLEAR COUNTER _INT_
    {
        if ($3 < 1 || $3 > 2) {
            printf("the int must be 1 or 2. means ac2240 or ac2820.\n");
            break;
        }
        fprintf(stdout,"cli_clear_counter($3)\n");
    }
    |    SHOW class_entry OUTGROUP outgroup_id OUTPORT EOS
    {
        fprintf(stdout,"cli_show_class_entry_outport(&g_class_entry, $4)\n");
    }
    ;

octencmds:
    SET STREAM AGING TIME UDP _INT_ TCP _INT_ EOS
    {
        if ($6 < 1 || $6 > 600 || $8 < 1 || $8 > 600) {
            printf("the time should be from 1 to 600 s.\n");
            break;
        }
        fprintf(stdout,"cli_set_stream_aging_time($6, $8)\n");
    }
    |   SET USER all_user able EOS
    {
        fprintf(stdout,"cli_set_user_enable($3, $4)\n");
    }
    |   SET USER AUTOBIND able EOS
    {
        fprintf(stdout,"cli_set_user_autobind_enable($4)\n");
    }
    |   SET FILLHEAD able EOS
    {
        fprintf(stdout,"cli_set_user_fillhead_enable($3)\n");
    }
    |   SET FWHEAD able EOS
    {
        fprintf(stdout,"cli_set_user_fwhead_enable($3)\n");
    }
    |   SET FWHEAD OUTGROUP outgroup_id redirect_ip redirect_vlan EOS
    {
        fprintf(stdout,"cli_set_fwhead_outgroup($4, $5, $6)\n");
    }
    |   SET USER AUTOBIND AGING TIME _INT_ EOS
    {
        if ($6 < 1 || $6 > 160) {
            printf("the time should be from 1 to 160 s.\n");
            break;
        }
        fprintf(stdout,"cli_set_user_autobind_aging_time($6)\n");
    }    
    |   SET PACKET SAMPLE able EOS
    {
        fprintf(stdout,"cli_set_packet_sample_enable($4)\n");
    }
    |   SET PACKET SAMPLE SCALE _INT_ HASH UPDATE TIME _INT_ EOS
    {
        if ($5 < 100 || $5 > 1000) {
            printf("the packet sample scale should be from 100 to 1000.\n");
            break;
        }
        if ( $9 > 65535) {
            printf("the packet sample hash update time should be from 0 to 65535 s.\n");
            break;
        }
        fprintf(stdout,"cli_set_packet_sample_scale($5, $9)\n");
    }
    |   SET PACKET SAMPLE OUTGROUP outgroup_id redirect_ip redirect_vlan EOS
    {
        fprintf(stdout,"cli_set_packet_sample_outgroup($5, $6, $7)\n");
    }
    |   SET NETFLOW able EOS
    {
        fprintf(stdout,"cli_set_netflow_enable($3)\n");
    }
    |   SET NETFLOW SERVER MAC _MAC_ IP _IPADDR_ PORT _INT_ EOS
    {
        if ( $9 > 65535) {
            printf("the netflow server port should be from 0 to 65535.\n");
            break;
        }
        fprintf(stdout,"cli_set_netflow_server($5, $7, $9)\n");
    }
    |   SET NETFLOW SAMPLE SCALE _INT_ EOS
    {
        if ($5 < 1 || $5 > 4096) {
            printf("the netflow sample scale should be from 1 to 4096.\n");
            break;
        }
        fprintf(stdout,"cli_set_netflow_sample_scale($5)\n");
    }
    |   SET NETFLOW SAMPLE OUTGROUP outgroup_id EOS
    {
        fprintf(stdout,"cli_set_netflow_sample_port($5)\n");
    }
    |   SET INTERFACE smp DIRECTION direction_type EOS
    {
        fprintf(stdout,"cli_set_interface_data_direction($3, $5)\n");
        free($3);
    }
    |   SET OUTGROUP outgroup_id HASHMODE direction_type hash_mode EOS
    {
        fprintf(stdout,"cli_set_outgroup_hashmode($3, $5, $6)\n");
    }
    |   ADD OUTGROUP outgroup_id smp EOS
    {
        fprintf(stdout,"cli_add_outgroup($3, $4)\n");
        free($4);
    }
    |   DELETE OUTGROUP outgroup_id smp EOS
    {
        fprintf(stdout,"cli_del_outgroup($3, $4)\n");
        free($4);
    }
    |   DELETE OUTGROUP outgroup_id ALL EOS
    {
        fprintf(stdout,"cli_del_outgroup_all($3)\n");
    }
    |   ALLOC PUBLIC OUTPORT smp EOS
    {
        fprintf(stdout,"cli_alloc_user_outport(0, $4)\n");
        free($4);
    }
    |   ALLOC USER user_id OUTPORT smp EOS
    {
        fprintf(stdout,"cli_alloc_user_outport($3, $5)\n");
        free($5);
    }
    |   CLEAR PUBLIC OUTPORT EOS
    {
        char *answer = NULL;
        printf(PROMPT("The outgroups of public would be cleared after this operation.\n"));
        printf(PROMPT("The outgroups's hashmode of public would be reset after this operation.\n"));
        printEnq(PROMPT("Do you want to continue? (y/n): "));
        answer = readline("");
        if ((answer[0] == 'Y') || (answer[0] == 'y'))
            fprintf(stdout,"cli_alloc_user_outport_none(0)\n");
        free(answer);
    }
    |   CLEAR USER user_id OUTPORT EOS
    {
        char *answer = NULL;
        printf(PROMPT("The outgroups of this user would be cleared after this operation.\n"));
        printf(PROMPT("The outgroups's hashmode of this user would be reset after this operation.\n"));
        printEnq(PROMPT("Do you want to continue? (y/n): "));
        answer = readline("");
        if ((answer[0] == 'Y') || (answer[0] == 'y'))
            fprintf(stdout,"cli_alloc_user_outport_none($3)\n");
        free(answer);
    }
    |    ADD IP_POOL _INT_ pool_ip  EOS
    {
        if ($3 <= 0 || $3 > MAX_IP_POOL_NUM) {
            printf("Pool id should be from 1 to %d.\n", MAX_IP_POOL_NUM);
            break;
        }
        fprintf(stdout,"cli_add_ip_pool($3, &g_pool)\n");
    }
    |    DELETE IP_POOL _INT_ pool_ip  EOS
    {
        if ($3 <= 0 || $3 > MAX_IP_POOL_NUM) {
            printf("Pool id should be from 1 to %d.\n", MAX_IP_POOL_NUM);
            break;
        }
        fprintf(stdout,"cli_del_ip_pool($3, &g_pool)\n");
    }
    |    DELETE IP_POOL _INT_ ALL EOS
    {
        if ($3 > MAX_IP_POOL_NUM || $3 < 1) {
            printf("Pool id should be from 1 to %d.\n", MAX_IP_POOL_NUM);
            break;
        }
        fprintf(stdout,"cli_del_ip_pool_all($3)\n");
    }
    |    ADD VLAN_POOL _INT_ _INT_  EOS
    {
        if ($3 > MAX_VLAN_POOL_NUM || $3 < 1) {
            printf("Pool id should be from 1 to %d.\n", MAX_VLAN_POOL_NUM);
            break;
        }
        if ($4 > MAX_REDIRECT_VLAN || $4 < 1) {
            printf("Vlan should be from 1 to %d.\n", MAX_REDIRECT_VLAN);
            break;
        }
        fprintf(stdout,"cli_add_vlan_pool($3, $4)\n");
    }
    |    DELETE VLAN_POOL _INT_ _INT_  EOS
    {
        if ($3 > MAX_VLAN_POOL_NUM || $3 < 1) {
            printf("Pool id should be from 1 to %d.\n", MAX_VLAN_POOL_NUM);
            break;
        }
        if ($4 > MAX_REDIRECT_VLAN || $4 < 1) {
            printf("Vlan should be from 1 to %d.\n", MAX_REDIRECT_VLAN);
            break;
        }
        fprintf(stdout,"cli_del_vlan_pool($3, $4)\n");
    }
    |    DELETE VLAN_POOL _INT_ ALL EOS
    {
        if ($3 > MAX_VLAN_POOL_NUM || $3 < 1) {
            printf("Pool id should be from 1 to %d.\n", MAX_VLAN_POOL_NUM);
            break;
        }
        fprintf(stdout,"cli_del_vlan_pool_all($3)\n");
    }
    |   SET USER DEFAULT DROP EOS
    {
        fprintf(stdout,"cli_set_default_fw(0, 0, 0, 0)\n");
    }
    |   SET USER DEFAULT FW OUTGROUP outgroup_id redirect_ip redirect_vlan EOS
    {
        fprintf(stdout,"cli_set_default_fw(1, $6, $7, $8)\n");
    }
    |   SET STRIP HEAD able EOS
    {
        fprintf(stdout,"cli_set_strip_head_enable($4)\n");
    }
    |  LOCK class_entry EOS
    {
        if ((g_class_entry.key_mask&OW_KEY_MASK_PROTOCOL) == 0
            || (g_class_entry.key_mask&OW_KEY_MASK_SIP) == 0
            || (g_class_entry.key_mask&OW_KEY_MASK_DIP) == 0
            || (g_class_entry.key_mask&OW_KEY_MASK_SPORT) == 0
            || (g_class_entry.key_mask&OW_KEY_MASK_DPORT) == 0) {
            printf("the lock should set the protocol, sip, dip, sport and dport.\n");
            break;
        }
        fprintf(stdout,"cli_lock_five_tuple(&g_class_entry)\n");
    }
    |  UNLOCK class_entry EOS
    {
        if ((g_class_entry.key_mask&OW_KEY_MASK_PROTOCOL) == 0
            || (g_class_entry.key_mask&OW_KEY_MASK_SIP) == 0
            || (g_class_entry.key_mask&OW_KEY_MASK_DIP) == 0
            || (g_class_entry.key_mask&OW_KEY_MASK_SPORT) == 0
            || (g_class_entry.key_mask&OW_KEY_MASK_DPORT) == 0) {
            printf("the lock should set the protocol, sip, dip, sport and dport.\n");
            break;
        }
        fprintf(stdout,"cli_unlock_five_tuple(&g_class_entry)\n");
    }
    |  SET STREAM DEFAULT FW NUM _INT_ EOS
    {
        if ($6 < 1 || $6>255) {
            printf("the stream default fw num should be from 1 to 255.\n");
            break;
        }
        fprintf(stdout,"cli_set_stream_default_fw_num($6)\n");
    }
    |  SET STREAM able EOS
    {
        fprintf(stdout,"cli_set_stream_enable($3)\n");
    }
    |   SET LOCK OUTGROUP outgroup_id redirect_ip redirect_vlan EOS
    {
        fprintf(stdout,"cli_set_lock_outport($4, $5, $6)\n");
    }
    |   SHOW class_entry LOCK STATUS EOS
    {
        if ((g_class_entry.key_mask&OW_KEY_MASK_PROTOCOL) == 0
            || (g_class_entry.key_mask&OW_KEY_MASK_SIP) == 0
            || (g_class_entry.key_mask&OW_KEY_MASK_DIP) == 0
            || (g_class_entry.key_mask&OW_KEY_MASK_SPORT) == 0
            || (g_class_entry.key_mask&OW_KEY_MASK_DPORT) == 0) {
            printf("the lock should set the protocol, sip, dip, sport and dport.\n");
            break;
        }
        fprintf(stdout,"cli_show_lock_status(&g_class_entry)\n");
    }
    |   SET UNKNOWN PACKET DROP EOS
    {
        fprintf(stdout,"cli_set_unknown_packet_process(0, 0)\n");
    }
    |   SET UNKNOWN PACKET FW OUTGROUP outgroup_id EOS
    {
        fprintf(stdout,"cli_set_unknown_packet_process(1, $6)\n");
    }
    |   SHOW STREAM COUNTER EOS
    {
        fprintf(stdout,"cli_show_stream_counter()\n");
    }
    |   CLEAR STREAM COUNTER EOS
    {
        fprintf(stdout,"cli_clear_stream_counter()\n");
    }
    |   SET FAILOVER able EOS
    {
        fprintf(stdout,"cli_set_failover_enable($3)\n");
    }
    |   SET FAILOVER STATUS UPDATE TIME _INT_ EOS
    {
        if ($6 < 5 || $6>50) {
            printf("the failover status update time should be from 5 to 50.\n");
            break;
        }
        fprintf(stdout,"cli_set_failover_status_update_time($6)\n");
    }
    |   SHOW SE BUILD TIME EOS
    {
        fprintf(stdout,"cli_show_se_build_time()\n");
    }
    |    SET USER AUTOBIND MAX NUM _INT_ EOS
    {
        fprintf(stdout,"cli_set_autobind_max_num($6)\n");
    }
    ;

ifcmds:
    SET INTERFACE POS smp RX DESCRAMBLE able EOS
    {
        fprintf(stdout,"cli_set_interface_pos_rx_descramble_enable($4, $7)\n");
        free($4);
    }
    |
    SET INTERFACE smp shutdown EOS
    {
        fprintf(stdout,"cli_set_interface_shutdown($3, $4)\n");
        free($3);
    }
    |
    SET INTERFACE smp SINGLE_FIBER TRANSMIT able EOS
    {
        fprintf(stdout,"cli_set_interface_single_fiber_transmit_enable($3, $6)\n");
        free($3);
    }
    |   SET INTERFACE POS smp RX CRC crctype EOS
    {
        fprintf(stdout,"cli_set_interface_pos_rx_crc_type($4, $7)\n");
        free($4);
    }
    |   SET INTERFACE smp TYPE iftype EOS
    {
        fprintf(stdout,"cli_set_interface_type($3, $5)\n");
        free($3);
    }
    |   SET INTERFACE TYPE iftype EOS
    {
        fprintf(stdout,"cli_set_interface_type_octeon($4)\n");
    }
    |   SET LINK STATUS AUTODETECT able EOS
    {
        fprintf(stdout,"cli_set_link_status_autodetect_enable($5)\n");
    }
    |   SHOW INTERFACE smp STATUS EOS
    {
        fprintf(stdout,"cli_show_interface_status($3)\n");
        free($3);
    }
    |   SHOW INTERFACE smp COUNTER EOS
    {
        fprintf(stdout,"cli_show_interface_counter($3)\n");
    free($3);
    }
    |   SHOW MODULE sm FPGA COUNTER EOS
    {
        fprintf(stdout,"cli_show_fpga_counter($3)\n");
    free($3);
    }
    |   SHOW MODULE sm DDR COUNTER EOS
    {
        fprintf(stdout,"cli_show_ddr_counter($3)\n");
    free($3);
    }
    |   CLEAR INTERFACE smp COUNTER EOS
    {
        fprintf(stdout,"cli_clear_interface_counter($3)\n");
    free($3);
    }
    |   CLEAR MODULE sm FPGA COUNTER EOS
    {
        fprintf(stdout,"cli_clear_fpga_counter($3)\n");
    free($3);
    }
    |   CLEAR MODULE sm DDR COUNTER EOS
    {
        fprintf(stdout,"cli_clear_ddr_counter($3)\n");
    free($3);
    }
    |   SHOW INTERFACE smp INFO EOS
    {
        fprintf(stdout,"cli_show_interface_sfp($3)\n");
        free($3);
    }
    ;
    |    SET INTERFACE smp FW FLOW THRESHOLD _INT_ EOS
    {
        if ($7 <= 0 || $7 > 10000000) {
            printf("the threshold should be from 1 to 10000000 kbps.\n");
            free($3);
            break;
        }
        fprintf(stdout,"cli_set_interface_flow($3, $7)\n");
        free($3);
    }
    |    SHOW INTERFACE smp FW FLOW THRESHOLD EOS
    {
        fprintf(stdout,"cli_show_interface_flow($3)\n");
        free($3);
    }
    |    SHOW INTERFACE STATUS EOS
    {
        fprintf(stdout,"cli_show_all_interface_status()\n");
    }
    ;

logcmds:
    SET LOG log_user ENABLE EOS
    {
        fprintf(stdout,"cli_set_log_enable($3,1)\n");
    }
    |    SET LOG log_user DISABLE EOS
    {
        fprintf(stdout,"cli_set_log_enable($3,0)\n");
    }
    |    SHOW LOG log_show_filter EOS
    {
        fprintf(stdout,"cli_show_user_log(&g_log_show_filter)\n");
    }
    |   SET LOG TIMEFORMAT time_format EOS
    {
        fprintf(stdout,"cli_set_log_time_format($4)\n");
    }
    |    SET LOG MIBINFO TYPE mibinfo_type EOS
    {
        fprintf(stdout,"cli_set_log_mibinfo_type($5)\n");
    }
    |    SET TRAP LOG ENABLE EOS
    {
        fprintf(stdout,"cli_set_trap_log_en_sw(1)\n");
    }
    |    SET TRAP LOG DISABLE EOS
    {
        fprintf(stdout,"cli_set_trap_log_en_sw(0)\n");
    }
    |    SET LOG USER FILESIZE _INT_ EOS
    {
        if($5 < 35 || $5 > (35 << 11))
        {
            fprintf(stderr,"size should be from 35k to 71680k.\n");
        }
        else
        {
            fprintf(stdout,"cli_set_log_filesize(LOG_USER1, $5)\n");//every none LOG_PUB is ok,just the same effect
        }
    }
    |    SET LOG SYSTEM FILESIZE _INT_ EOS
    {
        if($5 < 5 || $5 > (5 << 11))
        {
            fprintf(stderr,"size should be from 5k to 10240k.\n");            
        }
        else
        {
            fprintf(stdout,"cli_set_log_filesize(LOG_PUB, $5)\n");
        }
    }
    |    EXPORT LOG log_user FTP _IPADDR_ _STRING_ _STRING_ EOS
    {
        fprintf(stdout,"cli_set_log_ftp($3,$5,$6,$7)\n");
    }
    |    EXPORT LOG log_user FTP _IPADDR_ _STRING_ _STRING_ _STRING_ EOS
    {
        fprintf(stdout,"cli_set_log_ftp($3,$5,$6,$7,$8)\n");
    }
    |    EXPORT LOG log_user SYSLOG _IPADDR_ EOS
    {
        fprintf(stdout,"cli_set_log_syslog($3, $5, 514)\n");
    }
    |    EXPORT LOG log_user SYSLOG _IPADDR_ _INT_ EOS
    {
        fprintf(stdout,"cli_set_log_syslog($3, $5, $6)\n");
    }
    |    SHOW LOG CONFIGURATION EOS
    {
        fprintf(stdout,"cli_show_log_config()\n");
    }
    ;

mibinfo_type:
    PUBLIC
    {
        $$ = PUBLIC_TYPE;
    }
    |    PRIVATE
    {
        $$ = PRIVATE_TYPE;
    }

time_format:
    NONE
    {
        $$ = NO_TIME;
    }
    |    RFC TIME
    {
        $$ = RFC_TIME;
    }
    |    RFC TIME AND YEAR
    {
        $$ = RFC_YEAR;
    }
    |    RFC TIME AND MS
    {
        $$ = RFC_MSEC;
    }
    |    RFC TIME YEAR AND MS
    {
        $$ = RFC_YEAR_MSEC;
    }
    |    GENERAL YEAR
    {
        $$ = HAS_YEAR;
    }
    |    GENERAL YEAR AND MS
    {
        $$ = HAS_YEAR_MSEC;
    }
    ;

log_user:
    {
        $$ = LOG_ADMIN;
    }
    |    USER ADMIN
    {
        $$ = LOG_ADMIN;
    }
    |    USER _INT_
    {
        switch($2)
        {
            case 1:
            $$ = LOG_USER1;
            break;
            case 2:
            $$ = LOG_USER2;
            break;
            case 3:
            $$ = LOG_USER3;
            break;
            case 4:
            $$ = LOG_USER4;
            break;
            default:
            fprintf(stderr,"user id should be from 1 to 4.\n");
            YYERROR;
            break;
        }
    }
    |    USER MAINTENANCE
    {
        $$ = LOG_MAIN;
    }
    |    USER DEBUG
    {
        $$ = LOG_DBG;
    }
    |    SYSTEM
    {
        $$ = LOG_PUB;
    }
    ;
log_pri:
    EMERGENCY
    {
        $$ = LV_FATAL;
    }
    |    ALERT
    {
        $$ = LV_ALERT;
    }
    |    CRIT
    {
        $$ = LV_CRIT;
    }
    |    ERROR
    {
        $$ = LV_ERROR;
    }
    |    WARN
    {
        $$ = LV_WARN;
    }
    |    NOTICE
    {
        $$ = LV_NOTICE;
    }
    |    INFO
    {
        $$ = LV_INFO;
    }
    |    DEBUG
    {
        $$ = LV_DEBUG;
    }
    ;
log_show_filter:
    log_user
    {
        g_log_show_filter.user_id = $1;
        g_log_show_filter.op = LSF_USERID;
    }
    |    log_user PRIORITY log_pri
    {
        g_log_show_filter.user_id = $1;
        g_log_show_filter.log_pri = $3;
        g_log_show_filter.op = LSF_USERID_PRI;
    }
    ;

dbgcmds:
    SET DEBUG LEVEL _INT_ EOS
    {
        fprintf(stdout,"cli_set_debug_level($4)\n");
    }
    ;

slot_id:
    _INT_
    {
        if (($1 < 1) || ($1 > SLOT_NUMBER_PER_SYSTEM)) {
            printf("slot id should be from 1 to %d.\n", SLOT_NUMBER_PER_SYSTEM);
            YYERROR;
        }

        $$ = $1;
    }
    ;

ip:
    _IPADDR_
    {
        $$ = $1;
    }
    ;

login_tool:
    SSH
    {
        $$ = LOGIN_MODE_SSH;
    }
    |   CONSOLE
    {
        $$ = LOGIN_MODE_CONSOLE;
    }
    |   TELNET
    {
        $$ = LOGIN_MODE_TELNET;
    }
    |   RCP
    {
        $$ = LOGIN_MODE_RCP;
    }
    |   SNMP
    {
        $$ = LOGIN_MODE_SNMP;
    }
    |   FTP
    {
        $$ = LOGIN_MODE_FTP;
    }
    |   TFTP
    {
        $$ = LOGIN_MODE_TFTP;
    }
    |   SYSLOG
    {
        $$ = LOGIN_MODE_SYSLOG;
    }
    ;

class_entry:
    ce
    {

    }
    |   class_entry ce
    {

    }
    |    class_entry association_id
    {
    }
    |    ce_routing_proto
    {
    }
	|    ce_floatud
	{
	}
	;

ce_floatud:
	    KEY '=' _STRING_
    {
        fprintf(stdout, " KEY '=' _STRING_ \n"); 
    }
    |   KEY '=' _STRING_ WIN_WIDTH '=' _INT_ WIN_OFFSET '=' _INT_  KEY '=' _STRING_ WIN_WIDTH '=' _INT_ WIN_OFFSET '=' _INT_
    {
        fprintf(stdout, " 2 * KEY '=' _STRING_ WIN_WIDTH \n"); 
    }
    |    KEY '=' _STRING_ WIN_WIDTH '=' _INT_ WIN_OFFSET '=' _INT_ 
    {
        fprintf(stdout, " 1 * KEY '=' _STRING_ WIN_WIDTH \n"); 
    }
    ;

ce:
    ce_protocol
    |   ce_sip
    |   ce_dip
    |   ce_sport
    |   ce_dport
    |   ce_tcpflag
    |   ce_userdatas
    |   ce_size
    {

    }
    ;

ce_routing_proto:
    ROUTING_PROTO '=' ISIS
    {
        g_class_entry.key_mask |= OW_KEY_MASK_PROTOCOL;
        g_class_entry.key_mask |= OW_KEY_MASK_PROTOCOL_MASK;
        g_class_entry.key_mask |= OW_KEY_MASK_SIP;
        g_class_entry.key_mask |= OW_KEY_MASK_SIP_MASK;
        g_class_entry.key_mask |= OW_KEY_MASK_DIP;
        g_class_entry.key_mask |= OW_KEY_MASK_DIP_MASK;
        g_class_entry.key_mask |= OW_KEY_MASK_SPORT;
        g_class_entry.key_mask |= OW_KEY_MASK_SPORT_MASK;
        g_class_entry.key_mask |= OW_KEY_MASK_DPORT;
        g_class_entry.key_mask |= OW_KEY_MASK_DPORT_MASK;
        g_class_entry.protocol = 0xfc;
        g_class_entry.protocol_mask = 0xff;
        g_class_entry.sip = 0;
        g_class_entry.sip_mask = 0xffffffff;
        g_class_entry.dip = 0;
        g_class_entry.dip_mask = 0xffffffff;
        g_class_entry.sport = 0;
        g_class_entry.sport_mask = 0xffff;
        g_class_entry.dport = 0;
        g_class_entry.dport_mask = 0xffff;
        g_class_entry.ip_version = 4; 
    }
    ;

ce_protocol:
    PROTOCOL '=' TCP
    {
        g_class_entry.key_mask |= OW_KEY_MASK_PROTOCOL;

        g_class_entry.protocol = 0x06;
        g_class_entry.protocol_mask = 0xff;
    }
    |   PROTOCOL '=' TCP '/' _INT_
    {
        if ( $5 > 255 ) {
            printf("protocol mask should be from 0 to 255.\n");
            YYERROR;
        }

        g_class_entry.key_mask |= OW_KEY_MASK_PROTOCOL;
        g_class_entry.key_mask |= OW_KEY_MASK_PROTOCOL_MASK;

        g_class_entry.protocol = 0x06;
        g_class_entry.protocol_mask = $5;
    }
    |   PROTOCOL '=' UDP
    {
        g_class_entry.key_mask |= OW_KEY_MASK_PROTOCOL;

        g_class_entry.protocol = 0x11;
        g_class_entry.protocol_mask = 0xff;
    }
    |   PROTOCOL '=' UDP '/' _INT_
    {
        if ( $5 > 255 ) {
            printf("protocol mask should be from 0 to 255.\n");
            YYERROR;
        }

        g_class_entry.key_mask |= OW_KEY_MASK_PROTOCOL;
        g_class_entry.key_mask |= OW_KEY_MASK_PROTOCOL_MASK;

        g_class_entry.protocol = 0x11;
        g_class_entry.protocol_mask = $5;
    }
    |   PROTOCOL '=' _INT_
    {
        if ( $3 > 255) {
            printf("protocol should be from 0 to 255.\n");
            YYERROR;
        }
    
        g_class_entry.key_mask |= OW_KEY_MASK_PROTOCOL;

        g_class_entry.protocol = $3;
        g_class_entry.protocol_mask = 0xff;
    }
    |   PROTOCOL '=' _INT_ '/' _INT_
    {
         if (( $3 > 255) ||( $5 > 255) ) {
            printf("protocol should be from 0 to 255.\n");
            YYERROR;
        }
    
        g_class_entry.key_mask |= OW_KEY_MASK_PROTOCOL;
        g_class_entry.key_mask |= OW_KEY_MASK_PROTOCOL_MASK;

        g_class_entry.protocol = $3;
        g_class_entry.protocol_mask = $5;
    }
    ;
        
ce_sip:
    SIP '=' ip
    {
        g_class_entry.key_mask |= OW_KEY_MASK_SIP;
        g_class_entry.sip = $3;
        g_class_entry.sip_mask = 0xffffffff;
        g_class_entry.ip_version = 4; 
    }
    |   SIP '=' ip '/' ip
    {
        g_class_entry.key_mask |= OW_KEY_MASK_SIP;
        g_class_entry.key_mask |= OW_KEY_MASK_SIP_MASK;
        g_class_entry.sip = $3;
        g_class_entry.sip_mask = $5;
        g_class_entry.ip_version = 4;
    }
    |   SIP '=' _IPV6ADDR_
    {
        g_class_entry.key_mask |= OW_KEY_MASK_SIP;
        memcpy(g_class_entry.sipv6, $3, sizeof(g_class_entry.sipv6));
        memset(g_class_entry.sipv6_mask, 0xff, sizeof(g_class_entry.sipv6));
        g_class_entry.ip_version = 6; 
    }
    |   SIP '=' _IPV6ADDR_ '/' _IPV6ADDR_
    {
        g_class_entry.key_mask |= OW_KEY_MASK_SIP;
        g_class_entry.key_mask |= OW_KEY_MASK_SIP_MASK;
        memcpy(g_class_entry.sipv6, $3, sizeof(g_class_entry.sipv6));
        memcpy(g_class_entry.sipv6_mask, $5, sizeof(g_class_entry.sipv6_mask));
        g_class_entry.ip_version = 6; 
    }
    ;

ce_dip:
    DIP '=' ip
    {
        g_class_entry.key_mask |= OW_KEY_MASK_DIP;

        g_class_entry.dip = $3;
        g_class_entry.dip_mask = 0xffffffff;
    }
    |   DIP '=' ip '/' ip
    {
        g_class_entry.key_mask |= OW_KEY_MASK_DIP;
        g_class_entry.key_mask |= OW_KEY_MASK_DIP_MASK;
        
        g_class_entry.dip = $3;
        g_class_entry.dip_mask = $5;
    }
    |   DIP '=' _IPV6ADDR_
    {
        g_class_entry.key_mask |= OW_KEY_MASK_DIP;
        memcpy(g_class_entry.dipv6, $3, sizeof(g_class_entry.dipv6));
        memset(g_class_entry.dipv6_mask, 0xff, sizeof(g_class_entry.dipv6));
        g_class_entry.ip_version = 6; 
    }
    |   DIP '=' _IPV6ADDR_ '/' _IPV6ADDR_
    {
        g_class_entry.key_mask |= OW_KEY_MASK_DIP;
        g_class_entry.key_mask |= OW_KEY_MASK_DIP_MASK;
        memcpy(g_class_entry.dipv6, $3, sizeof(g_class_entry.dipv6));
        memcpy(g_class_entry.dipv6_mask, $5, sizeof(g_class_entry.dipv6_mask));
        g_class_entry.ip_version = 6; 
    }
    ;

ce_sport:
    SPORT '=' _INT_
    {
        if ( $3 > 65535) {
            printf("sport should be from 0 to 65535.\n");
            YYERROR;
        }
        g_class_entry.key_mask |= OW_KEY_MASK_SPORT;
        
        g_class_entry.sport = $3;
        g_class_entry.sport_mask = 0xffff;         
    }
    |   SPORT '=' _INT_ '/' _INT_
    {
        if ( $3 > 65535) {
            printf("sport should be from 0 to 65535.\n");
            YYERROR;
        }
        g_class_entry.key_mask |= OW_KEY_MASK_SPORT;
        g_class_entry.key_mask |= OW_KEY_MASK_SPORT_MASK;
        
        g_class_entry.sport = $3;
        g_class_entry.sport_mask = $5;        
    }    
    ;

ce_dport:
    DPORT '=' _INT_
    {
        if ( $3 > 65535) {
            printf("dport should be from 0 to 65535.\n");
            YYERROR;
        }
        g_class_entry.key_mask |= OW_KEY_MASK_DPORT;
        g_class_entry.dport = $3;
        g_class_entry.dport_mask = 0xffff;      
    }
    |   DPORT '=' _INT_ '/' _INT_
    {
        if ( $3 > 65535) {
            printf("dport should be from 0 to 65535.\n");
            YYERROR;
        }
        g_class_entry.key_mask |= OW_KEY_MASK_DPORT;
        g_class_entry.key_mask |= OW_KEY_MASK_DPORT_MASK;
        
        g_class_entry.dport = $3;
        g_class_entry.dport_mask = $5;        
    }     
    ;
 
ce_tcpflag:
    TCPFLAG '=' tcpflags
    {
    }
    ;
 tcpflag:
    FIN
    {
        g_class_entry.key_mask |= OW_KEY_MASK_FIN;
        g_class_entry.tcp_flag |= 0x01;
    }
    |    SYN
    {
        g_class_entry.key_mask |= OW_KEY_MASK_SYN;
        g_class_entry.tcp_flag |= 0x02;
    }
    |    RST
    {
        g_class_entry.key_mask |= OW_KEY_MASK_RST;
        g_class_entry.tcp_flag |= 0x04;
    }
    |    PSH
    {
        g_class_entry.key_mask |= OW_KEY_MASK_PSH;
        g_class_entry.tcp_flag |= 0x08;
    }
    |    ACK
    {
        g_class_entry.key_mask |= OW_KEY_MASK_ACK;
        g_class_entry.tcp_flag |= 0x10;
    }
    |    URG
    {
        g_class_entry.key_mask |= OW_KEY_MASK_URG;
        g_class_entry.tcp_flag |= 0x20;
    }
    |   NONE
    {
        g_class_entry.key_mask |= OW_KEY_MASK_TCP_FLAG;
        g_class_entry.tcp_flag = 0;
    }
    ;

tcpflags:
    tcpflag
    |    tcpflags ',' tcpflag
    ;

ce_size:
    SIZE '=' _INT_
    {
        g_class_entry.key_mask |= OW_KEY_MASK_SIZE;
        
        g_class_entry.size_range.min_size = $3;
        g_class_entry.size_range.max_size = $3;
    }
    |   SIZE '=' _INT_ '-' _INT_
    {
        if ($3 > $5) {
            printf("Invalid param.\n");
            YYERROR;
        }

        g_class_entry.key_mask |= OW_KEY_MASK_SIZE;

        g_class_entry.size_range.min_size = $3;
        g_class_entry.size_range.max_size = $5;
    }
    ;

ud_id:
    UD0
    {
        $$=0;
    }|   UD1
    {
        $$=1;
    }|   UD2
    {
        $$=2;
    }|   UD3
    {
        $$=3;
    }|   UD4
    {
        $$=4;
    }|   UD5
    {
        $$=5;
    }|   UD6
    {
        $$=6;
    }|   UD7
    {
        $$=7;
    }|   UD8
    {
        $$=8;
    }|   UD9
    {
        $$=9;
    }|UD10
    {
        $$=10;
    }|   UD11
    {
        $$=11;
    }|   UD12
    {
        $$=12;
    }|   UD13
    {
        $$=13;
    }|   UD14
    {
        $$=14;
    }|   UD15
    {
        $$=15;
    }|   UD16
    {
        $$=16;
    }|   UD17
    {
        $$=17;
    }|   UD18
    {
        $$=18;
    }|   UD19
    {
        $$=19;
    }|UD20
    {
        $$=20;
    }|   UD21
    {
        $$=21;
    }|   UD22
    {
        $$=22;
    }|   UD23
    {
        $$=23;
    }|   UD24
    {
        $$=24;
    }|   UD25
    {
        $$=25;
    }|   UD26
    {
        $$=26;
    }|   UD27
    {
        $$=27;
    }|   UD28
    {
        $$=28;
    }|   UD29
    {
        $$=29;
    }|UD30
    {
        $$=30;
    }|   UD31
    {
        $$=31;
    }|   UD32
    {
        $$=32;
    }|   UD33
    {
        $$=33;
    }|   UD34
    {
        $$=34;
    }|   UD35
    {
        $$=35;
    }
    ;

ce_userdata:
    ud_id '='  _INT_ '/' _INT_
    {
        if ((g_class_entry.ud_mask & ((long long)1 << $1)) == 0) {
            g_class_entry.ud_mask |= ((long long)1 << $1);
            g_class_entry.uds[$1].data = $3;
            g_class_entry.uds[$1].mask = $5;
            break;
        }
    }
    ;

ce_userdatas:
    ce_userdata
    {
    }
    |   ce_userdatas ce_userdata
    {
        $$ = (long)(g_class_entry.uds);
    }
    |    ce_userdatas COMPOUND_UD '=' _INT_
    {
        if ($4 != 0 && $4 != 1) {
            printf("the compound_ud should be 0 or 1.\n");
            YYERROR;
        }
        g_class_entry.sys_info.complex_ud = $4;
        if ($4 == 0)
            g_compound_ud = 0; 
        else
            g_compound_ud = 1; 
        $$ = (long)(g_class_entry.uds);
    }
    ;

associate_ud:
    ASSOCIATION_UD1
    {
        $$ = 0;
    }
    |    ASSOCIATION_UD2
    {
        $$ = 1;
    }
    |    ASSOCIATION_UD3
    {
        $$ = 2;
    }
    |    ASSOCIATION_UD4
    {
        $$ = 3;
    }
    ;

association_id:
    associate_ud '=' _INT_
    {
        g_class_entry.sys_info.ud_rule_index[$1] = $3;
    }
    ;

direction_type:
    UP
    {
        $$ = DATA_DIRECTION_UP;
    }
    |   DOWN
    {
        $$ = DATA_DIRECTION_DOWN;
    }
    ;

hash_mode:
    S
    {
        $$ = HASH_MODE_SIP;
    }
    |   D
    {
        $$ = HASH_MODE_DIP;
    }
    |   SD
    {
        $$ = HASH_MODE_SDIP;
    }
    |   SDSD
    {
        $$ = HASH_MODE_SDIP_SDPORT;
    }
    |   SDSDP
    {
        $$ = HASH_MODE_SDIP_SDPORT_PROTO;
    }
    ;

outgroup_id:
    _INT_
    {
        if (g_compound_ud == 0) {
            if ($1 < 1 || $1 > 255) {
                printf("outgroup_id should be from 1 to 255.\n");
                YYERROR;            
            }    
            $$ = $1;
        } 
        else {
            if ($1 < 1 || $1 > 255) {
                printf("outgroup_id should be from 1 to 255.\n");
                YYERROR;            
            }    
            $$ = $1;
        }
    }
    ;

user_id:
    _INT_
    {
        if ($1 < 1 || $1 >4) {
            printf("user_id should be from 1 to 4.\n");
            YYERROR;            
        }    
        $$ = $1 + 1;
    }
    ;

all_user:
    user_id
    {
        $$ = $1;
    }
    |   ADMIN
    {
        $$ = 0;
    }
    |   MAINTENANCE
    {
        $$ = 1;
    }
    |   DEBUG
    {
        $$ = 6;
    }
    ;

device_id:
    _INT_
    {
        if ( $1 > 255) {
            printf("device_id should be from 1 to 255.\n");
            YYERROR;
        }
        $$ = $1;
    }
    ;

rule_type:
    NO_MASK_RULE
    {
        $$ = 0;
    }
    | MASK_IPV4
    {
        $$ = 6;
    }
    | MASK_IPV6
    {
        $$ = 7;
    }
    | UD
    {
        $$ = 8;
    }
    | COMPOUND_IPV4
    {
       $$ = 9;
    }
    | COMPOUND_IPV6
    {
       $$ = 10;
    }
    |   WIN_UD
    {
       $$ = 12;
    }
    |   GLOBAL_UD
    {
       $$ = 13;
    }
    ;   
entry_num:
    _INT_
    {
        if( $1 > 1500000) {
            printf("entry_num should be from 0 to 1500000.\n");
            YYERROR;
        }
        $$ = $1;
    }
    ;

able:
    ENABLE
    {
        $$ = 1;
    }
    |   DISABLE
    {
        $$ = 0;
    }
    ;
    
shutdown:
    SHUTDOWN
    {
        $$ = 0;
    }
    |   NO_SHUT
    {
        $$ = 1;
    }
    ;

smp:
    _SMP_
    {
        CHECK_SMP_VALID($1[0], $1[1], $1[2]);
        struct IfSmp_B *tmp_smp = malloc(sizeof(struct IfSmp_B));
        if (tmp_smp == NULL) {
            YYERROR;
        }
        tmp_smp->slot   = $1[0];
        tmp_smp->module = $1[1];
        tmp_smp->port   = $1[2];
        $$ = tmp_smp;
    }
    ;

sm:
    _SM_
    {
        struct IfSmp_B *tmp_smp = malloc(sizeof(struct IfSmp_B));
        if (tmp_smp == NULL) {
            YYERROR;
        }
        tmp_smp->slot   = $1[0];
        tmp_smp->module = $1[1];
        $$ = tmp_smp;
    }
    ;

crctype:
    CRC_16
    {
        $$ = CRC_MODE_16;
    }
    |    CRC_32
    {
        $$ = CRC_MODE_32;
    }
    ;

iftype:
    POS
    {
        $$ = XG_MODE_POS;
    }
    |   XGE_LAN
    {
        $$ = XG_MODE_LAN;
    }
    |   XGE_WAN
    {
        $$ = XG_MODE_WAN;
    }
    ;

ip_search_mode:
    INSIDE
    {
        $$ = 1;
    }
    |    OUTSIDE
    {
        $$ = 0;
    }
    ;
ud_mode:
    HEAD
    {   
        $$ = 0;
    }
    |   L2
    {
        $$ = 1;
    }
    |   L3
    {
        $$ = 2;
    }
    |   L4
    {
        $$ = 3;
    }
    ;
offset:
   _INT_
    {
        if ( $1 >1023) {
            printf("offset should be from 0 to 1023.\n");
            YYERROR;            
        }    
        $$ = $1;
    }
    ;
table_id:
    _INT_
    {
        if ($1 < 1 || $1 >6) {
            printf("id should be from 1 to 6.\n");
            YYERROR;            
        }    
        $$ = $1;
    }
    ;

ddr_table_type:
    PROTOCOL
    {
        $$ = 1 << 0;
    }
    |   DPORT
    {
        $$ = 1 << 1;
    }
    |   SPORT
    {
        $$ = 1 << 2;
    }
    |   DIP
    {
        $$ = 1 << 3;
    }
    |   SIP
    {
        $$ = 1 << 4;
    }
    ;

ddr_table_types:
    ddr_table_type
    {
        $$ = $1;
    }
    |   ddr_table_types ddr_table_type
    {
        $$ = $1 | $2;
    }
    ;

table_start_addr:
    _INT_
    {
        if ($1 < 1 || $1 >26) {
            printf("table_start_addr should be from 1 to 26.\n");
            YYERROR;            
        }    
        $$ = $1;
    }
    ;

static:
    {
        $$ = 0;
    }
    |   STATIC
    {
        $$ = 1;
    }
    ;

customer_id:
    {
        g_class_entry.sys_info.custom_rule_id = 0;
    }
    |    CUSTOMER_RULE_ID '=' _INT_
    {
        if ($3 <= 0 || $3 >= MAX_RULE_NUMBER) {
            printf("custom_rule_id should be from 1 to %d.\n", MAX_RULE_NUMBER - 1);
            YYERROR;
        }
        g_class_entry.sys_info.custom_rule_id = $3;
    }

pool:
    {
        g_class_entry.sys_info.vlan_pool = 0;
        g_class_entry.sys_info.ip_pool = 0;
    }
    |    IP_POOL _INT_
    {
        if ($2 <= 0 || $2 > MAX_IP_POOL_NUM) {
            printf("Ip pool should be from 1 to %d.\n", MAX_IP_POOL_NUM);
        }
        g_class_entry.sys_info.ip_pool = $2;
    }
    |    VLAN_POOL _INT_
    {
        if ($2 <= 0 || $2 > MAX_VLAN_POOL_NUM) {
            printf("Vlan pool should be from 1 to %d.\n", MAX_VLAN_POOL_NUM);
        }
        g_class_entry.sys_info.vlan_pool = $2;
    }
    |    IP_POOL _INT_ VLAN_POOL _INT_
    {
        if ($2 <= 0 || $2 > MAX_IP_POOL_NUM) {
            printf("Ip pool should be from 1 to %d.\n", MAX_IP_POOL_NUM);
        }
        g_class_entry.sys_info.ip_pool = $2;

        if ($4 <= 0 || $4 > MAX_VLAN_POOL_NUM) {
            printf("Vlan pool should be from 1 to %d.\n", MAX_VLAN_POOL_NUM);
        }
        g_class_entry.sys_info.vlan_pool = $4;
    }

pool_ip:
    _IPADDR_
    {
        g_pool.redirect_ip = $1;
        g_pool.ip_version = 4;
    }
    |    _IPV6ADDR_
    {
        memcpy(g_pool.ipv6, $1, sizeof(g_pool.ipv6));
        g_pool.ip_version = 6;
    }

redirect_ip:
    {
        $$ = 0;
    }
    |    IP_POOL _INT_
    {
        if ($2 <= 0 || $2 > MAX_IP_POOL_NUM) {
            printf("Ip pool should be from 1 to %d.\n", MAX_IP_POOL_NUM);
        }
        $$ = $2;
    }

redirect_vlan:
    {
        $$ = 0;
    }
    |    VLAN_POOL _INT_
    {
        if ($2 <= 0 || $2 > MAX_VLAN_POOL_NUM) {
            printf("Vlan pool should be from 1 to %d.\n", MAX_VLAN_POOL_NUM);
        }
        $$ = $2;
    }

upgradecmds:
    WGET _URL_ EOS 
    {
        fprintf(stdout,"cli_sys_wget($2)\n");
    }
    |  ENABLE VERSION OM EOS
    {
        fprintf(stdout,"cli_set_startup_version(0, 1, NULL)\n");
    }
    |  ENABLE VERSION slot_id EOS
    {
        fprintf(stdout,"cli_set_startup_version($3, 1, NULL)\n");
    }
    |  DISABLE VERSION OM EOS
    {
        fprintf(stdout,"cli_set_startup_version(0, 0, NULL)\n");
    }
    |  DISABLE VERSION slot_id EOS
    {
        fprintf(stdout,"cli_set_startup_version($3, 0, NULL)\n");
    }
    |  ENABLE VERSION OM _STRING_ EOS
    {
        fprintf(stdout,"cli_set_startup_version(0, 1, $4)\n");
    }
    |  ENABLE VERSION slot_id _STRING_ EOS
    {
        fprintf(stdout,"cli_set_startup_version($3, 1, $4)\n");
    }
    |  DISABLE VERSION OM _STRING_ EOS
    {
        fprintf(stdout,"cli_set_startup_version(0, 0, $4)\n");
    }
    |  DISABLE VERSION slot_id _STRING_ EOS
    {
        fprintf(stdout,"cli_set_startup_version($3, 0, $4)\n");
    }
    |  ENABLE VERSION slot_id '-' slot_id _STRING_ EOS
    {
        fprintf(stdout,"cli_set_startup_version(i, 1, $6)\n");
    }
    |  DISABLE VERSION slot_id '-' slot_id _STRING_ EOS
    {
        fprintf(stdout,"cli_set_startup_version(i, 0, $6)\n");
    }
    |  REMOVE VERSION _STRING_ EOS
    {
        fprintf(stdout,"cli_remove_version($3, 0)\n");
    }
    |  LIST VERSION EOS
    {
        fprintf(stdout,"cli_list_version(-1, NULL)\n");
    }
    |  LIST VERSION OM EOS
    {
        fprintf(stdout,"cli_list_version(0, NULL)\n");
    }
    |  LIST VERSION slot_id EOS
    {
        fprintf(stdout,"cli_list_version($3, NULL)\n");
    }
    |  LIST VERSION _STRING_ EOS
    {
        fprintf(stdout,"cli_list_version(0, $3)\n");
    }
    ;

snmpcmds:
    SNMP snmp_op EOS
    {
        fprintf(stdout,"cli_snmp_option($2)\n");
    }
    | SNMP STATUS EOS
    {
        fprintf(stdout,"cli_show_snmp_status()\n");
    }
    | SNMP SHOW CONFIGURATION EOS
    {
        fprintf(stdout,"cli_show_snmp_conf()\n");
    }
    | SNMP SET AUTH TYPE snmp_auth_type EOS
    {
        fprintf(stdout,"cli_set_snmp_conf(SNMP_AUTH_TYPE, $5)\n");
    }
    | SNMP SET PRIV TYPE snmp_priv_type EOS
    {
        fprintf(stdout,"cli_set_snmp_conf(SNMP_PRIV_TYPE, $5)\n");
    }
    | SNMP SET ACCESS snmp_access EOS
    {
        fprintf(stdout,"cli_set_snmp_conf(SNMP_ACCESS, $4)\n");
    }
    | SNMP SET snmp_param _STRING_ EOS
    {
        fprintf(stdout,"cli_set_snmp_conf($3, $4)\n");
    }
    | SNMP SET TRAP IP _IPADDR_ EOS
    {
        char ip[64] = {0};
        struct in_addr in;
        in.s_addr = htonl($5);

        strcpy(ip, (char *)inet_ntoa(in));
        fprintf(stdout,"cli_set_snmp_conf( SNMP_TRAP_IP, ip)\n");
    }
    | SNMP snmp_community _STRING_ EOS
    {
        fprintf(stdout,"cli_set_snmp_conf($2, $3)\n");
    }
    ;

snmp_op:
    START
    {
        $$ = SNMP_START;
    }
    |   RESTART
    {
        $$ = SNMP_RESTART;
    }
    |   STOP
    {
        $$ = SNMP_STOP;
    }
    | RESTORE CONFIGURATION
    {
        $$ = SNMP_RESTORE;
    }
    ;

snmp_param:
    SYSNAME
    {
        $$ = SNMP_SYSNAME;
    }
    | SYSCONTACT
    {
        $$ = SNMP_SYSCONTACT;
    }
    | SYSLOCATION
    {
        $$ = SNMP_SYSLOCATION;
    }
    | TRAP VERSION
    {
        $$ = SNMP_TRAP_VERSION;
    }
    | USERNAME
    {
        $$ = SNMP_USERNAME;
    }
    | AUTH PASSWORD
    {
        $$ = SNMP_AUTH_PASSWD;
    }
    | PRIV PASSWORD
    {
        $$ = SNMP_PRIV_PASSWD;
    }
    ;

snmp_community:
    ADD ROCOMMUNITY
    {
        $$ = SNMP_ADD_ROCOMMUNITY;
    }
    | DELETE ROCOMMUNITY
    {
        $$ = SNMP_DEL_ROCOMMUNITY;
    }
    | ADD RWCOMMUNITY
    {
        $$ = SNMP_ADD_RWCOMMUNITY;
    }
    | DELETE RWCOMMUNITY
    {
        $$ = SNMP_DEL_RWCOMMUNITY;
    }
    ;

snmp_auth_type:
    MD5
    {
        $$ = 0;
    }
    | SHA
    {
        $$ = 1;
    }
    ;

snmp_priv_type:
    DES
    {
        $$ = 0;
    }
    | AES
    {
        $$ = 1;
    }
    ;

snmp_access:
    NOAUTH
    {
        $$ = 0;
    }
    | AUTH
    {
        $$ = 1;
    }
    | PRIV
    {
        $$ = 2;
    }
    ;

//add by flowingcity start
testcmds:
	SHOW TOK EOS
	{		
		fprintf(stdout, "cli_show_tok()\n");
	}
	| SHOW TOK _INT_ EOS
	{
		fprintf(stdout, "cli_show_tok(%lu)\n", $3);
	}
	| SHOW TOK _INT_ able EOS
	{
		fprintf(stdout, "cli_show_tok_e(%lu, %lu)\n", $3, $4);	
	}
	| SHOW TOK log_show_filter EOS 
	{
		fprintf(stdout, "cli_show_tok_filter()\n");
	}
	| SHOW TOK USER all_user able EOS
	{
		fprintf(stdout, "cli_show_tok_all_user()\n");		
	}
	;
tid:
	_INT_
	{
		$$ = $1;
	}
	;
//add by flowingcity end

%%

static void cli_reset_command(void)
{
    clear_name_table();
    memset(&g_class_entry, 0, sizeof(struct class_entry_t));
    memset(&g_pool, 0, sizeof(struct Pool_B));
    memset(&g_log_show_filter,0,sizeof(struct LogShowFilter_B));
    g_compound_ud = 0;
}

int start_cli(void)
{
    using_history();
    stifle_history(20);

    printf("\nOptiway3.0  Software\nCopyright (C) 2012, EmbedWay Inc.\n");

    printPrompt();
    yyparse();

    return 0;
}

// vim:ft=yacc
