 /*
  * @file rule.c
  * @brief 
  * @author LeiShi,kuku.whu@gmail.com
  * @version 
  * @date 2012-02-13 
  */
#ifndef _RULEDEFS_H_
#define _RULEDEFS_H_

#include <stdint.h>

#define UD_NUM 36
#define MAX_DDR_RULE_TYPE 6
#define MAX_CAM_RULE_TYPE 6		//ipv4,ipv6,ud,ipv4 complex ,ipv6 complex,tcp_flag
#define CAM_NUMBER_PER_BOARD 2
#define PER_CAM_BLOCK_NUMBER 128
#define PER_BLOCK_ENTRY_NUMBER 2048
#define PER_USER_BLOCK_NUMBER (PER_CAM_BLOCK_NUMBER/2)
#define PER_USER_CAM_ENTRY_NUMBER (PER_BLOCK_ENTRY_NUMBER*PER_USER_BLOCK_NUMBER)
#define PER_CAM_ENTRY_NUMBER (PER_CAM_BLOCK_NUMBER*PER_BLOCK_ENTRY_NUMBER)
#define MAX_COMPLEX_RULE 1000
#define MAX_SIZE_NUM 16
#define DDR_CHIPS_NUMBER 4
#define DDR_HASH_ARRAY DDR_CHIPS_NUMBER/2
#define INVALID_ENTRY_ID 0
#define DEFAULT_HASH_BUCKET_INDEX 26
#define DEFAULT_DDR_ENTRY_INDEX 21	//HASHB里面256bit的ddr entry数，2^23,由于用不了这么多规则，暂定21
#define MAX_DDR_RULE_NUM 1800000
#define MAX_CAM_INDEX (0x3ffff+ MAX_DDR_RULE_NUM+1)
#define IPTAB_SZ 20000
#define BUCKET_LENGTH 60
#define MAX_HASH_VALUE 100
#define MAX_CLASH_INDEX 30
#define MAX_FLOAT_UD_NUMBER 10000
#define MAX_TCP_FLAG_NUMBSER 16
#define MAX_FLOAT_UD_ID_START (MAX_CAM_INDEX+1)	/*index from 1*/
#define MAX_RULE_NUMBER (MAX_FLOAT_UD_ID_START+MAX_FLOAT_UD_NUMBER)  /*default rule index is 0*/
#define MAX_FLOAT_UD_WIND_NUM 2
#define MAX_FLOAT_UD_KEY_NUM 2
#define MAX_FLOAT_UD_KEY_BYTE 64
#define MAX_FLOAT_UD_KEY_LEN ((MAX_FLOAT_UD_KEY_BYTE)*4+1) //257
#define MAX_IP_POOL_NUM 16
#define MAX_VLAN_POOL_NUM 16
#define MAX_REDIRECT_NUM 256
#define MAX_REDIRECT_VLAN 2048
#define IP_POOL_FLAG 0
#define VLAN_POOL_FLAG 1

#ifdef _PLATFORM_MIPS_
#define HFA_CONFIG_PATH "/usr/local/hfa_config"
#define HFA_CONFIG_TOOL "/usr/local/bin/hfac"
#else
#define HFA_CONFIG_PATH "/usr/local/ow3/hfa_config"
#define HFA_CONFIG_TOOL "/usr/local/ow3/bin/hfac"
#endif
#define HFA_CONFIG_FILE HFA_CONFIG_PATH"/hfa.conf"
#define HFA_GRAPH_FILE		HFA_CONFIG_PATH"/hfa.out"
enum{
    APPLY_INIT,
	NO_APPLY,
	APPLYED
};

enum {
	CHECK_RULE_IPV4,
	CHECK_RULE_IPV6,
	CHECK_RULE_CAM_UD,
	CHECK_RULE_TCPFLAG,
	CHECK_RULE_WIN_FLOAT_UD,
	CHECK_RULE_GLOBAL_FLOAT_UD
};

enum {
	USER0,						//PUBLIC
	USER1,
	USER2,
	USER3,
	USER4,
	MAX_USER_NUMBER
};

enum {
	DDR_TUPLE_0,  //0
	DDR_TUPLE_1,  //1
	DDR_TUPLE_2,  //2
	DDR_TUPLE_3,  //3
	DDR_TUPLE_4,  //4
	DDR_TUPLE_5,  //5
	CAM_IPV4,     //6
	CAM_IPV6,     //7
	CAM_UD,       //8
	CAM_IPV4_UD,  //9
	CAM_IPV6_UD,  //10
	CAM_TCP_FLAG, //11
	FLOAT_UD,     //12
	FLOAT_GLOBAL_UD, //13
	MAX_RULE_TYPE   //14
};
enum {
	CAM_IPV4_REGION = CAM_IPV4,
	CAM_IPV6_REGION = CAM_IPV6,
	CAM_UD_REGION = CAM_UD,
	CAM_IPV4_UD_IP_REGION = CAM_IPV4_UD,
	CAM_IPV6_UD_IP_REGION = CAM_IPV6_UD,
	CAM_UDC_REGION = CAM_IPV6_UD+1,		//IPV4和IPV6复合规则的UD区间,不含普通UD
	MAX_REGION_TYPE = CAM_UDC_REGION+1
};

enum {
	IPV4 = 0,
	IPV6 = 1
};
/**
 * @brief hash桶定义（暂时存放规则表的id）
 */
typedef struct hash_bucket_s {
	int32_t entry_id;			/* 第一条规则的entry id */
	int32_t entry_num;			/* HASH桶中five tuple rule 规则的个数 */
} hash_bucket_t;

struct ud_status_t {
	int mode;					/*mode: 0(head) 1(L2 IP) 2(L3 TCP) 3(L4 payload) */
	int offset;					/* offset: 0-1023 单位为16bit */
};

/**
 * @brief HASH表数据结构
 */
typedef struct hash_table_s {
	int8_t name[32];			/* hash表名称 */
	uint32_t bucket_num;		/* hash桶的个数 */
	uint32_t entry_num;			/* 规则表项的总数 */
	uint32_t bytes_per_entry_id;	/* 一级HASH表里每个entry id占用的字节数，也就是CRC32的大小 */
	// TODO
	// 添加hash表锁
	hash_bucket_t *buckets;		/* hash表头部指针 */
	uint32_t used_entry_num;	/*five tuple rule number */
	void *rule_table_p;			/* 规则表指针 */
} hash_table_t;

struct ow_sys_info_t {
	uint8_t save;				/*0:重启保存 1:重启不保存*/
	uint8_t hit_statistics;
	uint8_t action;
	uint8_t complex_ud;			/*0:ud规则不被其他规则复合 1:ud规则别其他规则复合*/
	//uint8_t window_num;
	//uint16_t window_width;
	//uint16_t window_start_addr;
	uint16_t key_offset;
	uint16_t key_len;
	uint16_t keyword[32];
	uint16_t mask[32];
	uint32_t ud_rule_index[4];
	uint32_t custom_rule_id;	//用户加规则时的rule id,仅对客户有意义
	uint32_t rule_config_time;	//from 1970.0101 0hour 0second
	uint32_t host_ip;
	uint16_t ip_pool;
	uint16_t vlan_pool;
};

struct ow_ud_status_t {
	unsigned int mode;			//0,1,2,3
	unsigned int offset;
};
struct ow_ud_t {
	unsigned short data;
	unsigned short mask;
};

struct ow_float_ud_t {
	unsigned char keyword[MAX_FLOAT_UD_KEY_NUM][MAX_FLOAT_UD_KEY_LEN];
	uint8_t key_num;
	uint8_t window_num;
	unsigned short window_width[MAX_FLOAT_UD_WIND_NUM];
	unsigned short window_offset[MAX_FLOAT_UD_WIND_NUM];
};

struct ddr_table_t {
	unsigned short valid;
	unsigned short segment_is_output;
	unsigned short fivetuple_taken_mask;	//bit4-0:SIP、DIP、SPORT、DPORT、Protocol
	unsigned short hash_bucket_deep;	//2的幂，比如0x19表示32M
	int offset;
};

struct rule_size_t{
	unsigned short min_size;
	unsigned short max_size;	
};

struct class_entry_t {
	unsigned int size;
	unsigned int key_mask;
	unsigned int protocol;
	unsigned int protocol_mask;
	unsigned int sip;
	unsigned int sip_mask;
	unsigned int dip;
	unsigned int dip_mask;
	unsigned short sport;
	unsigned short sport_mask;
	unsigned short dport;
	unsigned short dport_mask;
	unsigned short tcp_flag;
	struct rule_size_t size_range;   //for fpga
	unsigned short sipv6[8];
	unsigned short sipv6_mask[8];
	unsigned short dipv6[8];
	unsigned short dipv6_mask[8];
	unsigned short ip_version;	//0: ipv4,1:ipv6  
	struct ow_sys_info_t sys_info;
	long long ud_mask;
	struct ow_ud_t uds[UD_NUM];
	struct ow_float_ud_t float_ud;
};

struct cam_class_entry_t {
	unsigned int key_mask;
	unsigned int protocol;
	unsigned int protocol_mask;
	unsigned int sip;
	unsigned int sip_mask;
	unsigned int dip;
	unsigned int dip_mask;
	unsigned short sport;
	unsigned short sport_mask;
	unsigned short dport;
	unsigned short dport_mask;
	unsigned short sipv6[8];
	unsigned short sipv6_mask[8];
	unsigned short dipv6[8];
	unsigned short dipv6_mask[8];
	unsigned short tcp_flag;
	struct rule_size_t size_range;   //for fpga
	unsigned short size_id;
	long long ud_mask;
	struct ow_ud_t uds[UD_NUM];
	unsigned short ip_version;	//0: ipv4,1:ipv6   
	struct ow_sys_info_t sys_info;
};

struct ddr_class_entry_t {
	unsigned int key_mask;
	unsigned int protocol;
	unsigned int sip;
	unsigned int dip;
	unsigned short sport;
	unsigned short dport;
	unsigned short sipv6[8];	//sipv6[0]:sipv6[1]:sipv6[2]:sipv6[3]:sipv6[4]:sipv6[5]:sipv6[6]:sipv6[7]
	unsigned short dipv6[8];	//dipv6[0]:dipv6[1]:dipv6[2]:dipv6[3]:dipv6[4]:dipv6[5]:dipv6[6]:dipv6[7]
	unsigned short ip_version;	//0:ipv4 1:ipv6;
	struct ow_sys_info_t sys_info;
};

struct float_ud_class_entry_t {
	struct ow_float_ud_t float_ud;
	struct ow_sys_info_t sys_info;
};

struct ram_table_t {
	int cx_index;				//复合规则编号1-1000
	int value[2];				//ram表的值，默认情况下为cx_index ,其中value[0]表示五元组部分，value[1]表示UD部分
};

struct hash_info_t {
	int hash_value;
	int clash_index;
};

struct cam_rule_t {
	int rule_index;				//180W+CAM ADDRESS (如果是第二块CAM，地址从180w+256K开始)
	int dev_id;					//0为第一片CAM,1为第二片CAM
	int ip_addr;				//CAM的地址，由前一个节点确定此地址
	int ud_addr;				//just user in complex rule
	//struct hash_info_t hash_info;   //表示此规则在表cam_hash_table中的位置，用于check，add，delete规则
	struct ram_table_t ram_table;	//只有复合规则会用
	short rule_type;			//ddr0,ddr1,ddr2,ddr3,ddr4,ddr5,cam_ipv4,cam_ipv6,ud,cam_ipv4_ud,cam_ipv6_ud 
	short outgroup_id;
	struct cam_class_entry_t cam_class_entry;
	struct cam_rule_t *last_rule_p;
	struct cam_rule_t *next_rule_p;
};
struct ddr_rule_t {
	int rule_index;				//1-1500000 由DDR二维链表维护此ID的分配,0保留
	short rule_type;			//ddr0,ddr1,ddr2,ddr3,ddr4,ddr5,cam_5tuple,cam_ud,cam_complex 
	short outgroup_id;			//从1开始，因为初始化为0
	struct ddr_class_entry_t ddr_class_entry;
	struct ddr_rule_t *last_rule_p;
	struct ddr_rule_t *next_rule_p;
};

struct float_ud_rule_t {
	int rule_index;
	short outgroup_id;
	struct float_ud_class_entry_t float_ud_class_entry;
	struct float_ud_rule_t *last_rule_p;
	struct float_ud_rule_t *next_rule_p;
};

struct cam_region_t {
	int dev_id;					//0 or 1;
	int begin_block_id;			//单位是block_id
	int block_num;
};

struct ow_rule_t {				//此结构体仅用来处理client端的数据
	short rule_type;			//ddr0,ddr1,ddr2,ddr3,ddr4,ddr5,cam_ipv4,cam_ipv6,cam_ud,cam_ipv4_ud,cam_ipv6_ud
	short outgroup_id;
	struct class_entry_t *class_entry_p;
};

struct ow_user_t {
	int user_id;				//用户ID，0，1，2，3，4...
	int valid;					//1为enable ,0为disable
	int ip_sch_md;				//0为外层，1为内层，默认为0
	int rule_num[MAX_RULE_TYPE];	/*已添加规则数,依次对应ddr0,ddr1,ddr2,ddr3,ddr4,ddr5,cam_ipv4,cam_ipv6,cam_ud,cam_ipv4_complex,cam_ipv6_complex */
	int alloc_rule_num[MAX_RULE_TYPE];	/*可添加规则数,依次对应ddr0,ddr1,ddr2,ddr3,ddr4,ddr5,cam_ipv4,cam_ipv6,cam_ud,cam_ipv4_complex,cam_ipv6_complex */
	int rule_ddr_ipv6_num;
	struct cam_region_t cam_region[MAX_REGION_TYPE];	//分别ipv4,cx_ipv4,ipv6,cx_ipv6,ud,cx_ud
	//struct cam_rule_t  *cam_hash_table[MAX_CAM_RULE_TYPE][MAX_HASH_VALUE][MAX_CLASH_INDEX];
	struct ddr_rule_t *ddr_rule_p[MAX_DDR_RULE_TYPE];	//6种DDR规则的二维链表
	struct cam_rule_t *cam_rule_p[MAX_CAM_RULE_TYPE];	//CAM规则的二维链表
	int max_float_ud_rule_num;
	struct float_ud_rule_t *float_ud_rule_p;
	struct ow_user_t *next_user_p;
};

struct Pool_B {
	short pool_id;
	short redirect_vlan;
	int ip_version;
	int redirect_ip;
	short ipv6[8];
};

struct LogShowFilter_B
{
	unsigned char user_id;
	unsigned char log_pri;
	unsigned short op;
}
;
struct IfSmp_B {
	unsigned int  slot;
	unsigned int  module;
	unsigned int  port;
};
#endif
