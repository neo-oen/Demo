/**
 * FILE: SyncErr.h
 * PURPOSE:  sync engine lib error code  file
 * DATE: 20100201
 * NOTE: Copyright (c) 2010 . All rights reserved.
 */

/*************************************************************************
 *  Definitions
 *************************************************************************/
#define ERR_VALUE  0x0000
/**
 * No error, success code
 **/
#define SYNC_ERR_OK   0x0000					// OK
#define SML_ERR_OK    0x0000     	    // OK
/**
 *General error code
 **/
#define SYNC_ERR_UNKNOWN           (ERR_VALUE+0x1000)
#define GENERAL_ERR_NOT_ENOUGH_SPACE     (ERR_VALUE+0x1001)
#define GENERAL_ERR_FAIL_FILE_OPEN       (ERR_VALUE+0x1002)
#define GENERAL_ERR_FAIL_FILE_CLOSE  	 (ERR_VALUE+0x1003)
#define GENERAL_ERR_FAIL_FILE_CREATE 	 (ERR_VALUE+0x1004)
#define GENERAL_ERR_FAIL_FILE_WRITE  	 (ERR_VALUE+0x1005)
#define GENERAL_ERR_FAIL_FILE_READ   	 (ERR_VALUE+0x1006)
#define GENERAL_ERR_FAIL_FILE_GETSIZE  	 (ERR_VALUE+0x1007)
#define GENERAL_ERR_FAIL_FILE_DELETE   	 (ERR_VALUE+0x1008)
#define GENERAL_ERR_FAIL_FILE_SIZEOVER   (ERR_VALUE+0x1009)
#define GENERAL_ERR_FILE_NOT_EXIST		 (ERR_VALUE+0x100a)
#define GENERAL_ERR_FAIL_FILE_SEEK  	 (ERR_VALUE+0x100b)
#define GENERAL_ERR_FAIL_FILE_EOF		 (ERR_VALUE+0x100c)
#define GENERAL_ERR_GPRS_CONNECT         (ERR_VALUE+0x100d)
#define GENERAL_ERR_GPRS_OTHER_USED      (ERR_VALUE+0x100e)
#define GENERAL_ERR_CREATE_TASK          (ERR_VALUE+0x100f)
#define GENERAL_ERR_NO_PORT              (ERR_VALUE+0x1010)
#define GENERAL_ERR_NO_USERNAME         (ERR_VALUE+0x1011)
#define GENERAL_ERR_NO_SERVER_ADDRESS   (ERR_VALUE+0x1012)
#define GENERAL_ERR_NO_USERPAS         (ERR_VALUE+0x1013)
#define GENERAL_ERR_NO_SYNC_TARGET      (ERR_VALUE+0x1014)
#define GENERAL_ERR_FAIL_RECEIVE_DATA    (ERR_VALUE+0x1015)
#define GENERAL_ERROR_PASSWORD            (ERR_VALUE+0x1016)
#define GENERAL_ERR_DATABASE_OPERATION  (ERR_VALUE+0x1017)
#define GENERAL_ERR_UNKNOW 			 	(ERR_VALUE+0x1018)
#define GENERAL_ERR_USER_CANCEL                  (ERR_VALUE+0x1019)

/**
 *  error of  SOCKET  transmit
 */
#define SOCKET_FAIL_CREATE                 (ERR_VALUE+0x1020)
#define SOCKET_FAIL_DNS                      (ERR_VALUE+0x1021)
#define SOCKET_FAIL_WRITE                  (ERR_VALUE+0x1022)
#define SOCKET_FAIL_READ                    (ERR_VALUE+0x1023)
#define SOCKET_FAIL_CONNECT              (ERR_VALUE+0x1024)
#define SOCKET_FAIL_CLOSE                   (ERR_VALUE+0x1025)
#define SOCKET_NO_ACCESS_POINT	  (ERR_VALUE+0x1026) // access point table is empty in mobile
#define SOCKET_USER_CANCEL				(ERR_VALUE+0x1027)

#define SOCKET_SYNCML_DATA_RESEND   (ERR_VALUE+0x1028) //用来重发数据


/**
 * SyncML Common Error Codes
 **/

// general errors
#define SML_ERR_UNSPECIFIC      	(ERR_VALUE+0x2101)      // unspecific error
#define SML_ERR_NOT_ENOUGH_SPACE	(ERR_VALUE+0x2102)      // not enough memory to perform this operation
#define SML_ERR_WRONG_USAGE     	(ERR_VALUE+0x2103)      // function was called in wrong context


// wrong parameters
#define SML_ERR_WRONG_PARAM        (ERR_VALUE+0x2201)      // wrong parameter
#define SML_ERR_INVALID_SIZE     (ERR_VALUE+0x2202)      // param has an invalid size
#define SML_ERR_INVALID_HANDLE   (ERR_VALUE+0x2203)      // if handle is invalid/unknown
#define SML_ERR_INVALID_OPTIONS  (ERR_VALUE+0x2204)      // unkown or unallowed options
/**
 * SyncML Mgr Error Codes
 **/
#define SML_ERR_A_MGR_ERROR      	(ERR_VALUE+0x2301)   // a template
#define SML_ERR_MGR_INVALID_INSTANCE_INFO	(ERR_VALUE+0x2302)   // a invalid Instance Info structure is used
#define SML_ERR_COMMAND_NOT_HANDLED      	(ERR_VALUE+0x2303)   // no callback function is available to handle this command
#define SML_ERR_ALREADY_INITIALIZED      	(ERR_VALUE+0x2304)   // Mgr allready initialized
/**
 * SyncML Xlt Error Codes
 **/
#define SML_ERR_XLT_MISSING_CONT         	(ERR_VALUE+0x2401)   // required field content missing
#define SML_ERR_XLT_BUF_ERR              	(ERR_VALUE+0x2402)  // Buffer too small
#define SML_ERR_XLT_INVAL_PCDATA_TYPE    	(ERR_VALUE+0x2403)   // Invalid (WBXML) Element Type (STR_I etc.)
#define SML_ERR_XLT_INVAL_LIST_TYPE      	(ERR_VALUE+0x2404)   // Invalid List Type (COL_LIST etc.)
#define SML_ERR_XLT_INVAL_TAG_TYPE       	(ERR_VALUE+0x2405) // Invalid Tag Type (TT_BEG etc.)
#define SML_ERR_XLT_ENC_UNK	            	(ERR_VALUE+0x2407)  // Unknown Encoding (WBXML, XML)
#define SML_ERR_XLT_INVAL_PROTO_ELEM    	(ERR_VALUE+0x2408)  // Invalid Protocol Element (ADD, Delete, ...)
#define SML_ERR_MISSING_LIST_ELEM       	(ERR_VALUE+0x2409)   // Missing Content of List Elements
#define SML_ERR_XLT_INCOMP_WBXML_VERS   	(ERR_VALUE+0x240A)  // Incompatible WBXML Content Format Version
#define SML_ERR_XLT_INVAL_SYNCML_DOC    	(ERR_VALUE+0x240B)  // Document does not conform to SyncML DTD
#define SML_ERR_XLT_INVAL_PCDATA        	(ERR_VALUE+0x240C)  // Invalid PCData elem (e.g. not encoded as OPAQUE data)
#define SML_ERR_XLT_TOKENIZER_ERROR         (ERR_VALUE+0x240D)  // Unspecified tokenizer error
#define SML_ERR_XLT_INVAL_WBXML_DOC         (ERR_VALUE+0x240E)  // Document does not conform to WBXML specification
#define SML_ERR_XLT_WBXML_UKN_TOK           (ERR_VALUE+0x240F)   // Document contains unknown WBXML token
#define SML_ERR_XLT_MISSING_END_TAG         (ERR_VALUE+0x2410)  // Non-empty start tag without matching end tag
#define SML_ERR_XLT_INVALID_CODEPAGE        (ERR_VALUE+0x2411)   // WBXML document uses unspecified code page
#define SML_ERR_XLT_END_OF_BUFFER           (ERR_VALUE+0x2412)   // End of buffer reached
#define SML_ERR_XLT_INVAL_XML_DOC           (ERR_VALUE+0x2413)   // Document does not conform to XML 1.0 specification
#define SML_ERR_XLT_XML_UKN_TAG             (ERR_VALUE+0x2414)   // Document contains unknown XML tag
#define SML_ERR_XLT_INVAL_PUB_IDENT         (ERR_VALUE+0x2415)   // Invalid Public Identifier
#define SML_ERR_XLT_INVAL_EXT               (ERR_VALUE+0x2416)   // Invalid Codepage Extension
#define SML_ERR_XLT_NO_MATCHING_CODEPAGE    (ERR_VALUE+0x2417)  // No matching Codepage could be found
#define SML_ERR_XLT_INVAL_INPUT_DATA        (ERR_VALUE+0x2418)   // Data missing in input structure
/**
 * SyncML Wsm Error Codes
 **/
#define SML_ERR_WSM_BUF_TABLE_FULL          (ERR_VALUE+0x2501)   // no more empty entries in buffer table available
/**
 * SyncML Util Error Codes
 **/
#define SML_ERR_A_UTI_UNKNOWN_PROTO_ELEMENT 	(ERR_VALUE+0x2601)
/**
 *SyncML self_defination Error Codes from SDA_ERR_XXX
 **/
#define SYNC_OK                     			(ERR_VALUE+0x0000)        

#define SYNC_SYNCMETHOD_UNSUPPORTED 			(ERR_VALUE+0x3001)
#define SYNC_INCOMPLETE_SYNCINFO    			(ERR_VALUE+0x3002)
#define SYNC_ERR_WRONG_PARAM        			(ERR_VALUE+0x3003)
#define SYNC_ERR_NOT_ENOUGH_SPACE   			(ERR_VALUE+0x3004)     // not enough memory to perform this operation

#define SYNC_ERR_DBA_DB_NOT_FOUND   			(ERR_VALUE+0x3005)
#define SYNC_ERR_DBA_DB_OPEN_FAILED 			(ERR_VALUE+0x3006)
#define SYNC_ERR_DBA_INTERNAL       			(ERR_VALUE+0x3007)

#define SYNC_ERR_DBACCESS           			(ERR_VALUE+0x3008)
#define SYNC_ERR_DATAEXCHANGE       			(ERR_VALUE+0x3009)
#define SYNC_ERR_CREATE_DATA        			(ERR_VALUE+0x3010)
#define SYNC_ERR_HANDLE_DATA        			(ERR_VALUE+0x3011)
#define SYNC_ERR_RUNTIME            			(ERR_VALUE+0x3012)
#define SYNC_ERR_CL_INTERNAL	  				(ERR_VALUE+0x3013)
#define SYNC_ERR_WORKSPACE_FULL					(ERR_VALUE+0x3014)
/* official SymcML Status codes */
#define SYNC_ERR_SYNC_ENGINE_STATE				(ERR_VALUE+0x3502)
#define SYNC_ERR_XLT_MISSING_CONT				(ERR_VALUE+0x3503)
#define SYNC_ERR_SYNC_ENGINE_STATE_NOT_CHANGE	(ERR_VALUE+0x3504)

#define	SYNC_ERROR_USERSTOP			 			(ERR_VALUE+0x3505)			 //用户取消同步
#define	SYNC_ERROR_USERSETTING		 			(ERR_VALUE+0x3506)			 //用户设置错误
#define SYNC_ERROR_INCALL						(ERR_VALUE+0x3507)

#define SYNC_PAYMENT_FAILED				        (ERR_VALUE+0x3800)           //付费失败

/**
 *HTTP error code
 **/
#define   HTTP_ERR_BADREQUEST               	(ERR_VALUE+0x4400)//400 请求出现语法错误。
#define   HTTP_ERR_UNAUTHORIZED             	(ERR_VALUE+0x4401)//401 客户试图未经授权访问受密码保护的页面。
#define   HTTP_ERR_FORBIDDEN                	(ERR_VALUE+0x4403)//403 资源不可用。服务器理解客户的请求，但拒绝处理它。通常由于服务器上文件或目录的权限设置导致。
#define   HTTP_ERR_NOTFOUND                 	(ERR_VALUE+0x4404)//404 无法找到指定位置的资源。这也是一个常用的应答。
#define   HTTP_ERR_METHODNOTALLOWED         	(ERR_VALUE+0x4405)//405 请求方法（GET、POST、HEAD、DELETE、PUT、TRACE等）对指定的资源不适用。（HTTP 1.1新）
#define   HTTP_ERR_NOTACCEPTABLE            	(ERR_VALUE+0x4406)//406 指定的资源已经找到，但它的MIME类型和客户在Accpet头中所指定的不兼容（HTTP 1.1新）。
#define   HTTP_ERR_PROXYAUTHENTICATIONREQUIRED	(ERR_VALUE+0x4407)//407 类似于401，表示客户必须先经过代理服务器的授权。（HTTP 1.1新）
#define   HTTP_ERR_REQUESTTIMEOUT             	(ERR_VALUE+0x4408)//408 在服务器许可的等待时间内，客户一直没有发出任何请求。客户可以在以后重复同一请求。（HTTP 1.1新）
#define   HTTP_ERR_CONFLICT                   	(ERR_VALUE+0x4409)//409 通常和PUT请求有关。由于请求和资源的当前状态相冲突，因此请求不能成功。（HTTP 1.1新）
#define   HTTP_ERR_GONE                       	(ERR_VALUE+0x4410)//410 所请求的文档已经不再可用，而且服务器不知道应该重定向到哪一个地址。
#define   HTTP_ERR_LENGTH_REQUIRED            	(ERR_VALUE+0x4411)//411 服务器不能处理请求，除非客户发送一个Content-Length头。
#define   HTTP_ERR_PRECONDITIONFAILED         	(ERR_VALUE+0x4412)//412 请求头中指定的一些前提条件失败（HTTP 1.1新）。
#define   HTTP_ERR_REQUESTENTITYTOOLARGE      	(ERR_VALUE+0x4413)//413 目标文档的大小超过服务器当前愿意处理的大小
#define   HTTP_ERR_REQUESTURITOOLONG          	(ERR_VALUE+0x4414)//414 URI太长（HTTP 1.1新）。
#define   HTTP_ERR_REQUESTEDRANGENOTSATISFIABLE	(ERR_VALUE+0x4416)//416 服务器不能满足客户在请求中指定的Range头。
#define   HTTP_ERR_INTERNALSERVERERROR          (ERR_VALUE+0x4500)//500 服务器遇到了意料不到的情况，不能完成客户的请求
#define   HTTP_ERR_NOTIMPLEMENTED               (ERR_VALUE+0x4501)//501 服务器不支持实现请求所需要的功能。
#define   HTTP_ERR_BADGATEWAY                   (ERR_VALUE+0x4502)//502 服务器作为网关或者代理时，为了完成请求访问下一个服务器，但该服务器返回了非法的应答
#define   HTTP_ERR_SERVICEUNAVAILABLE           (ERR_VALUE+0x4503)//503 服务器由于维护或者负载过重未能应答。
#define   HTTP_ERR_GATEWAYTIMEOUT               (ERR_VALUE+0x4504)//504 由作为代理或网关的服务器使用，表示不能及时地从远程服务器获得应答
#define   HTTP_ERR_HTTPVERSIONNOTSUPPORTED      (ERR_VALUE+0x4505)//505 服务器不支持请求中所指明的HTTP版本
#define	  HTTP_ERR_RESPONSEHEADER				(ERR_VALUE+0x4506)//	  服务器发回的Repsonse头内容有错误
#define   HTTP_ERR_SENDLENGTHERROR				(ERR_VALUE+0x4507)//		Socket发送的包出错
#define   HTTP_ERR_FAILTOCREATEHEAD				(ERR_VALUE+0x4508)//		Socket发送的包出错
#define   HTTP_ERR_SOCKET_ABORT					(ERR_VALUE+0x4509)//		网络出错											
#define  HTTP_ERR_NEED_GETNEXTDATA							(ERR_VALUE+0x450A)
#define   HTTP_ERR_PARSE_DNS                    (ERR_VALUE+0x450B)  //dns 解析出错
#define   HTTP_ERR_READ_FROM_SERVER             (ERR_VALUE+0x450C)  //网络接收数据失败
#define   HTTP_ERR_WRITE_TO_SERVER              (ERR_VALUE+0x450D)  //网络发送数据失败
#define   HTTP_ERR_CONNECT_TO_SERVER            (ERR_VALUE+0x450E)  //连接服务器失败
#define   HTTP_ERR_CLOSE_FROM_SERVER            (ERR_VALUE+0x450F)  //服务器关闭了连接
#define   HTTP_ERR_RECV_DATA_TOOLONG               (ERR_VALUE+0x4510)  //接收的数据包太大无法接收
/**
 *Vcard error code
 **/
#define    VCARD_ERR_FAIL_INIT              	(ERR_VALUE+0x5001)
#define    VCARD_ERR_FAIL_DESTROY           	(ERR_VALUE+0x5002)
#define    VCARD_ERR_FAIL_INVALID_FILENAME  	(ERR_VALUE+0x5003)
#define    VCARD_ERR_FAIL_INVALID_PROPERTY  	(ERR_VALUE+0x5004)
#define    VCARD_ERR_FAIL_INPUT_VALUE           (ERR_VALUE+0x5005)
#define    VCARD_ERR_FAIL_PARSE_PACKAGE         (ERR_VALUE+0x5006)
#define    VCARD_ERR_FAIL_PACK					(ERR_VALUE+0x5007)
#define    VCARD_ERR_DATA_TOO_LONG				(ERR_VALUE+0x5008)
/**
 *Vcalendar error code
 **/
#define    VCALENDAR_ERR_FAIL_INIT              (ERR_VALUE+0x5101)
#define    VCALENDAR_ERR_FAIL_DESTROY           (ERR_VALUE+0x5102)
#define    VCALENDAR_ERR_FAIL_INVALID_FILENAME  (ERR_VALUE+0x5103)
#define    VCALENDAR_ERR_FAIL_INVALID_PROPERTY  (ERR_VALUE+0x5104)
#define    VCALENDAR_ERR_FAIL_INVALID_TIMEFORMAT (ERR_VALUE+0x5105)
/**
 *Listen error code
 **/
#define    LISTEN_ERR_FAIL_WRITE_LOGFILE       	(ERR_VALUE+0x5201)
#define    LISTEN_ERR_FAIL_WRITE_EVENTFILE     	(ERR_VALUE+0x5202)
#define    LISTEN_ERR_FAIL_RECREATE_FILE       	(ERR_VALUE+0x5203)
#define    LISTEN_ERR_FAIL_RESET_LISTENMSG		(ERR_VALUE+0x5204)
#define    LISTEN_ERR_FAIL_SWICH_SYNC			(ERR_VALUE+0x5205)
/***Data operation error code
 **/
#define    DATA_ERR_FAIL_INIT_RECORD			(ERR_VALUE+0x5300)
#define    DATA_ERR_FAIL_DELETE_RECORD      	(ERR_VALUE+0x5301)
#define    DATA_ERR_FAIL_ADD_RECORD      		(ERR_VALUE+0x5302)
#define    DATA_ERR_FAIL_REPLACE_RECORD  		(ERR_VALUE+0x5303)
#define    DATA_ERR_FAIL_GET_RECORD      		(ERR_VALUE+0x5304)
#define    DATA_ERR_PIM_UNAVAILABLE	 			(ERR_VALUE+0x5305)
#define    DATA_ERR_PIM_BAD_RECNR	 			(ERR_VALUE+0x5306)
#define    DATA_ERR_PIM_BAD_NAME				(ERR_VALUE+0x5307)
#define    DATA_ERR_PIM_BAD_TELNR	 			(ERR_VALUE+0x5308)
#define    DATA_ERR_PIM_NOT_FOUND	 			(ERR_VALUE+0x5309)
#define    DATA_ERR_PIM_EMPTY	 			    (ERR_VALUE+0x530A)
#define    DATA_ERR_PIM_FULL					(ERR_VALUE+0x530B)		// 空
#define    DATA_ERR_PIM_OCCUPIED				(ERR_VALUE+0x530C)	// 已经被使用了--添加时，这个位置应该没有	
#define    DATA_ERR_PIM_DUP_NAME				(ERR_VALUE+0x530E)	// 姓名重复(通讯簿将不允许姓名重复的现象发生)
#define    DATA_ERR_PIM_OPEN_CONTACTS              (ERR_VALUE+0x530F)

#define    DATA_ERR_LOG_MOBILE_FULL             (ERR_VALUE+0x5310)//   log_mobile_full 4		//手机日程已满
#define    DATA_ERR_LOG_MOBILE_EMPTY            (ERR_VALUE+0x5311)//log_mobile_empty 5	        //日程为空
#define    DATA_ERR_LOG_ID_OUTRANGE             (ERR_VALUE+0x5312)// log_id_outrange 6		    //输入id超出手机数据删除范围

#define	   DATA_ERR_FAIL_GET_LISTEN_LOG			(ERR_VALUE+0x5313) //获取监听信息出错
#define	   DATA_ERR_FAIL_SET_LISTEN_LOG			(ERR_VALUE+0x5314) //设置监听信息出错
#define	   DATA_ERR_FAIL_DEL_LISTEN_LOG			(ERR_VALUE+0x5315) //删除监听信息出错

#define      DATA_ERR_PIM_ADD_WAIT                            (ERR_VALUE+0x5316)
#define      DATA_ERR_PIM_REPLACE_WAIT                            (ERR_VALUE+0x5317)
#define      DATA_ERR_PIM_DEL_WAIT                            (ERR_VALUE+0x5318)

#define      DATA_ERR_PIM_DIED_WAIT			     (ERR_VALUE+0x5319)  //数据库被占用或死掉,需要等待时间再重新开始
#define      DATA_ERR_FAIL_ADD_RECORD_RECORD_EXIST    (ERR_VALUE+0x5320)

/**
 *SyncML state code
 */
#define SYNC_STATE_RESPONSE_IN_PROGRESS 		(ERR_VALUE+0x6101)
#define SYNC_STATE_RESPONSE_OK	        		(ERR_VALUE+0x6200)
#define SYNC_STATE_RESPONSE_ITEM_ADDED			(ERR_VALUE+0x6201)
#define SYNC_STATE_RESPONSE_ACCEPTED_FOR_PROCESSING	    (ERR_VALUE+0x6202)
#define SYNC_STATE_RESPONSE_NONAUTHORIATATIVE_RESPONSE	(ERR_VALUE+0x6203)
#define SYNC_STATE_RESPONSE_NO_CONTENT	          (ERR_VALUE+0x6204)
#define SYNC_STATE_RESPONSE_RESET_CONTENT	     (ERR_VALUE+0x6205)
#define SYNC_STATE_RESPONSE_PARTIAL_CONTENT	     (ERR_VALUE+0x6206)
#define SYNC_STATE_RESPONSE_CONFLICT_RESOLVED_WITH_MERGE	(ERR_VALUE+0x6207)
#define SYNC_STATE_RESPONSE_CONFLICT_RESOLVED_WITH_CLIENT_WINNING	(ERR_VALUE+0x6208)
#define SYNC_STATE_RESPONSE_CONFILCT_RESOLVED_WITH_DUPLICATE	(ERR_VALUE+0x6209)
#define SYNC_STATE_RESPONSE_DELETE_WITHOUT_ARCHIVE	      	(ERR_VALUE+0x6210)
#define SYNC_STATE_RESPONSE_ITEM_NO_DELETED	   	(ERR_VALUE+0x6211)
#define SYNC_STATE_RESPONSE_AUTHENTICATION_ACCEPTED	          				(ERR_VALUE+0x6212)
#define SYNC_STATE_RESPONSE_CHUNKED_ITEM_ACCEPTED_AND_BUFFERED	  			(ERR_VALUE+0x6213)
#define SYNC_STATE_RESPONSE_OPERATION_CANCELED	                  			(ERR_VALUE+0x6214)
#define SYNC_STATE_RESPONSE_NO_EXECUTED	                          			(ERR_VALUE+0x6215)
#define SYNC_STATE_RESPONSE_ATOMIC_ROLL_BACK_OK	                  			(ERR_VALUE+0x6216)
#define SYNC_STATE_RESPONSE_MULTIPLE_CHOICES	        					(ERR_VALUE+0x6300)
#define SYNC_STATE_RESPONSE_MOVED_PERMANENTLY	        					(ERR_VALUE+0x6301)
#define SYNC_STATE_RESPONSE_TMPORARITY_FOUND	        					(ERR_VALUE+0x6302)
#define SYNC_STATE_RESPONSE_SEE_OTHER	                					(ERR_VALUE+0x6303)
#define SYNC_STATE_RESPONSE_NOT_MODIFIED	        						(ERR_VALUE+0x6304)
#define SYNC_STATE_RESPONSE_USE_PROXY	                					(ERR_VALUE+0x6305)
#define SYNC_STATE_RESPONSE_BAD_REQUEST	                  					(ERR_VALUE+0x6400)
#define SYNC_STATE_RESPONSE_INVALID_CREDENTIALS	          					(ERR_VALUE+0x6401)
#define SYNC_STATE_RESPONSE_INVALID_PAYMENT	          						(ERR_VALUE+0x6402)
#define SYNC_STATE_RESPONSE_COMMAND_FORBIDDEN	          					(ERR_VALUE+0x6403)
#define SYNC_STATE_RESPONSE_NOT_FOUND	                  					(ERR_VALUE+0x6404)
#define SYNC_STATE_RESPONSE_COMMAND_NOT_ALLOWED	          					(ERR_VALUE+0x6405)
#define SYNC_STATE_RESPONSE_OPTIONAL_NOT_SUPPORTED	  						(ERR_VALUE+0x6406)
#define SYNC_STATE_RESPONSE_MISSING_CREDENTIALS	          					(ERR_VALUE+0x6407)
#define SYNC_STATE_RESPONSE_REQUEST_TIMEOUT	          						(ERR_VALUE+0x6408)
#define SYNC_STATE_RESPONSE_REQUEST_CONFLICT	          					(ERR_VALUE+0x6409)
#define SYNC_STATE_RESPONSE_REQUESTED_TARGET_GONE	  						(ERR_VALUE+0x6410)
#define SYNC_STATE_RESPONSE_SIZE_REQUIRED	          						(ERR_VALUE+0x6411)
#define SYNC_STATE_RESPONSE_INCOMPLETE_COMMAND	          					(ERR_VALUE+0x6412)
#define SYNC_STATE_RESPONSE_ENTITY_TOO_LARGE	          					(ERR_VALUE+0x6413)
#define SYNC_STATE_RESPONSE_URI_TOO_LONG	          						(ERR_VALUE+0x6414)
#define SYNC_STATE_RESPONSE_UNSUPPORTED_MEDIA	          					(ERR_VALUE+0x6415)
#define SYNC_STATE_RESPONSE_REQUEST_SIZE_TOO_BIG	  						(ERR_VALUE+0x6416)
#define SYNC_STATE_RESPONSE_RETRY_LATER	                  					(ERR_VALUE+0x6417)
#define SYNC_STATE_RESPONSE_ALREADY_EXISTS	          						(ERR_VALUE+0x6418)
#define SYNC_STATE_RESPONSE_CONFLICT_WITH_SERVER_DATA	  					(ERR_VALUE+0x6419)
#define SYNC_STATE_RESPONSE_DEVICE_FULL	                  					(ERR_VALUE+0x6420)
#define SYNC_STATE_RESPONSE_UNKNOWN_SEARCH_GRAMMAR	  						(ERR_VALUE+0x6421)
#define SYNC_STATE_RESPONSE_BAD_CGI_SCRIPT	          						(ERR_VALUE+0x6422)
#define SYNC_STATE_RESPONSE_SOFT_DELETE_CONFLICT	  						(ERR_VALUE+0x6423)
#define SYNC_STATE_RESPONSE_SIZE_MISMATCH	          						(ERR_VALUE+0x6424)
#define SYNC_STATE_RESPONSE_GROUP_EXIST	          						(ERR_VALUE+0x6426)
#define SYNC_STATE_RESPONSE_COMMAND_FAILED	             					(ERR_VALUE+0x6500)
#define SYNC_STATE_RESPONSE_COMMAND_NOT_IMPLEMENTED	     					(ERR_VALUE+0x6501)
#define SYNC_STATE_RESPONSE_BAD_GATEWAY	                     				(ERR_VALUE+0x6502)
#define SYNC_STATE_RESPONSE_SERVICE_UNAVAILABLE	             				(ERR_VALUE+0x6503)
#define SYNC_STATE_RESPONSE_GATEWAY_TIMEOUT	             					(ERR_VALUE+0x6504)
#define SYNC_STATE_RESPONSE_DTD_NOT_SUPPORTED	             				(ERR_VALUE+0x6505)
#define SYNC_STATE_RESPONSE_PROCESSING_ERROR	             				(ERR_VALUE+0x6506)
#define SYNC_STATE_RESPONSE_ATOMIC_FAILED	             					(ERR_VALUE+0x6507)
#define SYNC_STATE_RESPONSE_REFRESH_REQUIRED	             				(ERR_VALUE+0x6508)
#define SYNC_STATE_RESPONSE_DATA_STORE_FAILURE	             				(ERR_VALUE+0x6510)
#define SYNC_STATE_RESPONSE_SERVER_FAILURE	             					(ERR_VALUE+0x6511)
#define SYNC_STATE_RESPONSE_SYNCHRONIZATION_FAILED	     					(ERR_VALUE+0x6512)
#define SYNC_STATE_RESPONSE_PROTOCOL_VERSION_NOT_SUPPORTED		   			(ERR_VALUE+0x6513)
#define SYNC_STATE_RESPONSE_OPERATION_SUCCESS_CANCELED	       				(ERR_VALUE+0x6514)
#define SYNC_STATE_RESPONSE_OPERATION_FAIL_CANCELLED                        (ERR_VALUE+0x6515)
#define SYNC_STATE_RESPONSE_ATOMIC_ROLL_BACK_FAILED							(ERR_VALUE+0x6516)
#define SYNC_STATE_RESPONSE_UNKNOWN_ERROR							        (ERR_VALUE+0x6517)

/**
 *SyncML alert error code
 **/
#define SYNC_ALERT_DISPLAY 			 										(ERR_VALUE+0x7100)

#define SYNC_ALERT_TWO_WAY 			 										(ERR_VALUE+0x7200)
#define SYNC_ALERT_SLOW_SYNC			 									(ERR_VALUE+0x7201)
#define SYNC_ALERT_ONE_WAY_FROM_CLIENT	         							(ERR_VALUE+0x7202)
#define SYNC_ALERT_REFRESH_FROM_CLIENT	         							(ERR_VALUE+0x7203)
#define SYNC_ALERT_ONE_WAY_FROM_SERVER	         							(ERR_VALUE+0x7204)
#define SYNC_ALERT_REFRESH_FROM_SERVER	         							(ERR_VALUE+0x7205)

#define SYNC_ALERT_TWO_WAY_BY_SERVER	         							(ERR_VALUE+0x7206)
#define SYNC_ALERT_ONE_WAY_FROM_CLIENT_BY_SERVER 							(ERR_VALUE+0x7207)
#define SYNC_ALERT_REFRESH_FROM_CLIENT_BY_SERVER 							(ERR_VALUE+0x7208)
#define SYNC_ALERT_ONE_WAY_FROM_SERVER_BY_SERVER 							(ERR_VALUE+0x7209)
#define SYNC_ALERT_REFRESH_FROM_SERVER_BY_SERVER 							(ERR_VALUE+0x7210)

#define SYNC_ALERT_RESULT_ALERT		   	 									(ERR_VALUE+0x7221)
#define SYNC_ALERT_NEXT_MESSAGE		   	 									(ERR_VALUE+0x7222)
#define SYNC_ALERT_NO_END_OF_DATA		 									(ERR_VALUE+0x7223)

#define SYNC_ALERT_USER_DISPLAY		   	 									(ERR_VALUE+0x7B00)
#define SYNC_ALERT_USER_CONTINUE_OR_ABORT	 								(ERR_VALUE+0x7B01)
#define SYNC_ALERT_USER_TEXT_INPUT		 									(ERR_VALUE+0x7B02)
#define SYNC_ALERT_USER_SINGLE_CHOICE	   	 								(ERR_VALUE+0x7B03)
#define SYNC_ALERT_USER_MULTIPLE_CHOICE	   	 								(ERR_VALUE+0x7B04)
#define SYNC_ALERT_USER_SERVER_INITIATEDMGMT	 							(ERR_VALUE+0x7C00)
#define SYNC_ALERT_USER_CLIENT_INITIATEDMGMT	 							(ERR_VALUE+0x7C01)
#define SYNC_ALERT_USER_RESULT_ALERT		 								(ERR_VALUE+0x7C21)
#define SYNC_ALERT_USER_NEXT_MESSAGE		 								(ERR_VALUE+0x7C22)
#define SYNC_ALERT_USER_SESSION_ABORT	   	 								(ERR_VALUE+0x7C23)
#define SYNC_ALERT_BADNETWORK_ABORT   	 								    (ERR_VALUE+0x7C24)
#define SYNC_DNSERROR                                                       (ERR_VALUE+0x7C25)
#define SYNC_FAILED_TO_SEND_SMS											    (ERR_VALUE+0x7C26)

#define UDB_ACCOUNT_USER_NOT_FOUND  (ERR_VALUE+0x8401)
#define UDB_ACCOUNT_PSW_ERR         (ERR_VALUE+0x8402)

/**********************ERROR MESSAGE***************************/
/***************************************************************
 #define ERROR_INFO_LENGTH 50
 
 #define SYNC_INFO_SUCCESS   "同步成功"
 
 #define SYNC_INFO_NOT_ENOUGH_SPACE     "内存不足"
 #define SYNC_INFO_FAIL_FILE_OPERATION    "文件操作失败"
 
 #define SYNC_INFO_GPRS_CONNECT         "GPRS连接失败"
 #define SYNC_INFO_CREATE_TASK          "无法创建任务"
 #define SYNC_INFO_NO_PORT              "找不到端口号"
 #define  SYNC_INFO_NO_USERNAME         "找不到用户名"
 #define  SYNC_INFO_NO_SERVER_ADDRESS   "找不到服务器地址"
 #define   SYNC_INFO_NO_USERPAS         "找不到用户密码"
 #define   SYNC_INFO_NO_SYNC_TARGET      "找不到同步目标名"
 #define SYNC_INFO_FAIL_RECEIVE_DATA  "接收数据失败"
 #define SYNC_INFO_UNKNOW 			 	"未知错误"
 
 
 
 // general errors
 #define SYNC_INFO_SYSTEM     "系统内部错误"
 
 #define SYNC_INFO_XML    "XML或WBXML处理错误"
 
 #define SYNC_INFO_WSM_BUF_TABLE_FULL    "系统内部错误"   // no more empty entries in buffer table available
 
 #define SYNC_INFO_A_UTI_UNKNOWN_PROTO_ELEMENT 	"未知同步命令"
 
 
 
 #define SYNC_INFO_SYNCMETHOD_UNSUPPORTED 		"同步方法不被支持"
 #define SYNC_INFO_INCOMPLETE_SYNCINFO    		"同步信息不兼容"
 #define SYNC_INFO_WRONG_PARAM        			"系统内部错误"
 #define SYNC_INFO_NOT_ENOUGH_SPACE   			"内存不足"     // not enough memory to perform this operation
 
 #define SYNC_INFO_DBA_DB_NOT_FOUND   			"数据库不存在"
 #define SYNC_INFO_DBA_DB_OPEN_FAILED 			"数据库打开失败"
 #define SYNC_INFO_DBA_INTERNAL       			"添加记录失败"
 
 #define SYNC_INFO_DBACCESS           			"数据库访问失败"
 #define SYNC_INFO_DATAEXCHANGE       			"数据交换失败"
 #define SYNC_INFO_CREATE_DATA        			"数据建立失败"
 #define SYNC_INFO_HANDLE_DATA        			"数据处理失败"
 #define SYNC_INFO_RUNTIME            			"系统内部错误"
 #define SYNC_INFO_CL_INTERNAL	  				"系统内部错误"
 
 #define SYNC_INFO_SYNC_ENGINE_STATE				"同步状态错误"
 #define SYNC_INFO_XLT_MISSING_CONT				"同步数据错误"
 #define SYNC_INFO_SYNC_ENGINE_STATE_NOT_CHANGE	"同步状态无法转换"
 
 #define	SYNC_INFO_USERSTOP			 			"用户取消同步"	 //用户取消同步
 #define	SYNC_INFO_USERSETTING		 			"用户设置错误"			 //用户设置错误
 
 #define   SYNC_INFO_HTTP_ERR_BADREQUEST               "HTTP错误：400"//400 请求出现语法错误。
 #define   SYNC_INFO_HTTP_ERR_UNAUTHORIZED            "HTTP错误：401"//401 客户试图未经授权访问受密码保护的页面。
 #define   SYNC_INFO_HTTP_ERR_FORBIDDEN                "HTTP错误：403"//403 资源不可用。服务器理解客户的请求，但拒绝处理它。通常由于服务器上文件或目录的权限设置导致。
 #define   SYNC_INFO_HTTP_ERR_NOTFOUND                 "HTTP错误：404"//404 无法找到指定位置的资源。这也是一个常用的应答。
 #define   SYNC_INFO_HTTP_ERR_METHODNOTALLOWED         "HTTP错误：405"//405 请求方法（GET、POST、HEAD、DELETE、PUT、TRACE等）对指定的资源不适用。（HTTP 1.1新）
 #define   SYNC_INFO_HTTP_ERR_NOTACCEPTABLE            	"HTTP错误：406"//406 指定的资源已经找到，但它的MIME类型和客户在Accpet头中所指定的不兼容（HTTP 1.1新）。
 #define   SYNC_INFO_HTTP_ERR_PROXYAUTHENTICATIONREQUIRED	"HTTP错误：407"//407 类似于401，表示客户必须先经过代理服务器的授权。（HTTP 1.1新）
 #define   SYNC_INFO_HTTP_ERR_REQUESTTIMEOUT             	"HTTP错误：408"//408 在服务器许可的等待时间内，客户一直没有发出任何请求。客户可以在以后重复同一请求。（HTTP 1.1新）
 #define   SYNC_INFO_HTTP_ERR_CONFLICT                   	"HTTP错误：409"//409 通常和PUT请求有关。由于请求和资源的当前状态相冲突，因此请求不能成功。（HTTP 1.1新）
 #define   SYNC_INFO_HTTP_ERR_GONE                       	"HTTP错误：410"//410 所请求的文档已经不再可用，而且服务器不知道应该重定向到哪一个地址。
 #define   SYNC_INFO_HTTP_ERR_LENGTH_REQUIRED            "HTTP错误：411"//411 服务器不能处理请求，除非客户发送一个Content-Length头。
 #define   SYNC_INFO_HTTP_ERR_PRECONDITIONFAILED         	"HTTP错误：412"//412 请求头中指定的一些前提条件失败（HTTP 1.1新）。
 #define   SYNC_INFO_HTTP_ERR_REQUESTENTITYTOOLARGE      	"HTTP错误：413"//413 目标文档的大小超过服务器当前愿意处理的大小
 
 #define   SYNC_INFO_HTTP_ERR_REQUESTURITOOLONG          	"HTTP错误：414"//414 URI太长（HTTP 1.1新）。
 #define   SYNC_INFO_HTTP_ERR_REQUESTEDRANGENOTSATISFIABLE	"HTTP错误：416"//416 服务器不能满足客户在请求中指定的Range头。
 #define   SYNC_INFO_HTTP_ERR_INTERNALSERVERERROR          "HTTP错误：500"//500 服务器遇到了意料不到的情况，不能完成客户的请求
 #define   SYNC_INFO_HTTP_ERR_NOTIMPLEMENTED               "HTTP错误：501"//501 服务器不支持实现请求所需要的功能。
 #define   SYNC_INFO_HTTP_ERR_BADGATEWAY                   "HTTP错误：502"//502 服务器作为网关或者代理时，为了完成请求访问下一个服务器，但该服务器返回了非法的应答
 #define   SYNC_INFO_HTTP_ERR_SERVICEUNAVAILABLE           "HTTP错误：503"//503 服务器由于维护或者负载过重未能应答。
 #define   SYNC_INFO_HTTP_ERR_GATEWAYTIMEOUT               "HTTP错误：504"//504 由作为代理或网关的服务器使用，表示不能及时地从远程服务器获得应答
 #define   SYNC_INFO_HTTP_ERR_HTTPVERSIONNOTSUPPORTED      "HTTP错误：505"//505 服务器不支持请求中所指明的HTTP版本
 #define	  SYNC_INFO_HTTP_ERR_RESPONSEHEADER				"服务器返回信息错误"//	  服务器发回的Repsonse头内容有错误
 #define   SYNC_INFO_HTTP_ERR_SENDLENGTHERROR				"发送信息出错"//		Socket发送的包出错
 #define   SYNC_INFO_HTTP_ERR_FAILTOCREATEHEAD			"发送信息出错"//		Socket发送的包出错
 #define   SYNC_INFO_HTTP_ERR_SOCKET_ABORT					"网络出错"//		网络出错											
 
 #define    SYNC_INFO_VCARD_ERROR              	"vCard数据处理失败"
 
 
 #define    SYNC_INFO_VCALENDAR_ERROR              "vCalendar数据处理失败"
 
 
 #define    SYNC_INFO_LISTEN_ERROR       	"数据库监听失败"
 
 #define    SYNC_INFO_PIM_OPERATION			"通讯录操作失败"
 
 #define    SYNC_INFO_PIM_UNAVAILABLE	 	"通讯录不可用"
 
 #define    SYNC_INFO_PIM_NOT_FOUND	 		"通讯录不存在"
 #define    SYNC_INFO_PIM_EMPTY	 		"通讯录为空"
 #define    SYNC_INFO_PIM_FULL			"通讯录已满"		// 空
 
 #define    SYNC_INFO_PIM_DUP_NAME		"通讯录中姓名重复"	// 姓名重复(通讯簿将不允许姓名重复的现象发生)
 
 #define    SYNC_INFO_LOG_MOBILE_FULL     "日程表已满"//   log_mobile_full 4		//手机日程已满
 #define    SYNC_INFO_LOG_MOBILE_EMPTY    "日程表为空"//log_mobile_empty 5	        //日程为空
 #define    SYNC_INFO_LOG_ID_OUTRANGE     "输入id超出手机数据删除范围"// log_id_outrange 6		    //输入id超出手机数据删除范围
 
 #define	   SYNC_INFO_FAIL_GET_LISTEN_LOG	"获取监听信息出错" //获取监听信息出错
 #define	   SYNC_INFO_FAIL_SET_LISTEN_LOG		"设置监听信息出错" //设置监听信息出错
 #define	   SYNC_INFO_FAIL_DEL_LISTEN_LOG		"删除监听信息出错" //删除监听信息出错
 
 
 
 #define SYNC_INFO_STATE_RESPONSE_IN_PROGRESS 		"正在同步中:101"//(ERR_VALUE+0x6101)
 #define SYNC_INFO_STATE_RESPONSE_OK	        		"同步成功:200"//(ERR_VALUE+0x6200)
 #define SYNC_INFO_STATE_RESPONSE_ITEM_ADDED			"记录添加成功:201"//(ERR_VALUE+0x6201)
 #define SYNC_INFO_STATE_RESPONSE_ACCEPTED_FOR_PROCESSING	    "成功执行:202"//(ERR_VALUE+0x6202)
 #define SYNC_INFO_STATE_RESPONSE_NONAUTHORIATATIVE_RESPONSE	"没有验证响应:203"//(ERR_VALUE+0x6203)
 #define SYNC_INFO_STATE_RESPONSE_NO_CONTENT	          "没有数据:204"//(ERR_VALUE+0x6204)
 #define SYNC_INFO_STATE_RESPONSE_RESET_CONTENT	     "源数据要更新:205"//(ERR_VALUE+0x6205)
 #define SYNC_INFO_STATE_RESPONSE_PARTIAL_CONTENT	     "部份成功:206"//(ERR_VALUE+0x6206)
 #define SYNC_INFO_STATE_RESPONSE_CONFLICT_RESOLVED_WITH_MERGE	"数据合并冲突:207"//(ERR_VALUE+0x6207)
 #define SYNC_INFO_STATE_RESPONSE_CONFLICT_RESOLVED_WITH_CLIENT_WINNING	"数据处理冲突:208"//(ERR_VALUE+0x6208)
 #define SYNC_INFO_STATE_RESPONSE_CONFILCT_RESOLVED_WITH_DUPLICATE	"数据拷贝冲突:209"//(ERR_VALUE+0x6209)
 #define SYNC_INFO_STATE_RESPONSE_DELETE_WITHOUT_ARCHIVE	      	"删除成功但没对该操作存档:210"//(ERR_VALUE+0x6210)
 #define SYNC_INFO_STATE_RESPONSE_ITEM_NO_DELETED	   	"删除目标未找到:211"//(ERR_VALUE+0x6211)
 #define SYNC_INFO_STATE_RESPONSE_AUTHENTICATION_ACCEPTED	       "认证被接受:212"//(ERR_VALUE+0x6212)
 #define SYNC_INFO_STATE_RESPONSE_CHUNKED_ITEM "接收的数据太大:213"//(ERR_VALUE+0x6213)
 #define SYNC_INFO_STATE_RESPONSE_OPERATION_CANCELED	                  	"操作被取消:214"//(ERR_VALUE+0x6214)
 #define SYNC_INFO_STATE_RESPONSE_NO_EXECUTED	                          "操作没被执行:215"//(ERR_VALUE+0x6215)
 #define SYNC_INFO_STATE_RESPONSE_ATOMIC_ROLL_BACK_OK	                  "成功操作回滚:216"//(ERR_VALUE+0x6216)
 #define SYNC_INFO_STATE_RESPONSE_MULTIPLE_CHOICES	        			"同步目标需要被替换:300"//(ERR_VALUE+0x6300)
 #define SYNC_INFO_STATE_RESPONSE_MOVED_PERMANENTLY	        			"目标URL需要更新:301"//(ERR_VALUE+0x6301)
 #define SYNC_INFO_STATE_RESPONSE_TMPORARITY_FOUND	        			"同步目标暂时被转换到不同URL中:302"//(ERR_VALUE+0x6302)
 #define SYNC_INFO_STATE_RESPONSE_SEE_OTHER	                		"同步目标在其它URL中存在:303"//(ERR_VALUE+0x6303)
 #define SYNC_INFO_STATE_RESPONSE_NOT_MODIFIED	        				"同步命令未被执行:304"//(ERR_VALUE+0x6304)
 #define SYNC_INFO_STATE_RESPONSE_USE_PROXY	                			"同步目标要经过URL代理:305"//(ERR_VALUE+0x6305)
 #define SYNC_INFO_STATE_RESPONSE_BAD_REQUEST	                  		"同步请求错误:400"//(ERR_VALUE+0x6400)
 #define SYNC_INFO_STATE_RESPONSE_INVALID_CREDENTIALS	          			"认证未被通过:401"//(ERR_VALUE+0x6401)
 #define SYNC_INFO_STATE_RESPONSE_INVALID_PAYMENT	          				"需要付费:402"//(ERR_VALUE+0x6402)
 #define SYNC_INFO_STATE_RESPONSE_COMMAND_FORBIDDEN	          			"同步请求被禁止:403"//(ERR_VALUE+0x6403)
 #define SYNC_INFO_STATE_RESPONSE_NOT_FOUND	                  			"同步目标不存在:404"//(ERR_VALUE+0x6404)
 #define SYNC_INFO_STATE_RESPONSE_COMMAND_NOT_ALLOWED	          		"同步命令不被接受:405"//(ERR_VALUE+0x6405)
 #define SYNC_INFO_STATE_RESPONSE_OPTIONAL_NOT_SUPPORTED	  				"同步命令中的某些内容不被支持:406"//(ERR_VALUE+0x6406)
 #define SYNC_INFO_STATE_RESPONSE_MISSING_CREDENTIALS	          		"没有验证信息:407"//(ERR_VALUE+0x6407)
 #define SYNC_INFO_STATE_RESPONSE_REQUEST_TIMEOUT	          			"同步请求超时:408"//(ERR_VALUE+0x6408)
 #define SYNC_INFO_STATE_RESPONSE_REQUEST_CONFLICT	          			"数据更新冲突:409"//(ERR_VALUE+0x6409)
 #define SYNC_INFO_STATE_RESPONSE_REQUESTED_TARGET_GONE	  				"同步目标不再存在:410"//(ERR_VALUE+0x6410)
 #define SYNC_INFO_STATE_RESPONSE_SIZE_REQUIRED	          			"同步数据长度未找到:411"//(ERR_VALUE+0x6411)
 #define SYNC_INFO_STATE_RESPONSE_INCOMPLETE_COMMAND	          		"同步命令不完整:412"//(ERR_VALUE+0x6412)
 #define SYNC_INFO_STATE_RESPONSE_ENTITY_TOO_LARGE	          		"同步内容太长:413"//(ERR_VALUE+0x6413)
 #define SYNC_INFO_STATE_RESPONSE_URI_TOO_LONG	          			"URL太长:414"//(ERR_VALUE+0x6414)
 #define SYNC_INFO_STATE_RESPONSE_UNSUPPORTED_MEDIA	          		"数据格式不被支持:415"//	(ERR_VALUE+0x6415)
 #define SYNC_INFO_STATE_RESPONSE_REQUEST_SIZE_TOO_BIG	  			"同步请求的数据长度太长:416"//(ERR_VALUE+0x6416)
 #define SYNC_INFO_STATE_RESPONSE_RETRY_LATER	                  	"同步请求需要重试:417"//(ERR_VALUE+0x6417)
 #define SYNC_INFO_STATE_RESPONSE_ALREADY_EXISTS	          			"同步目标已经存在:418"//(ERR_VALUE+0x6418)
 #define SYNC_INFO_STATE_RESPONSE_CONFLICT_WITH_SERVER_DATA	  		"和服务器的数据发生冲突:419"//(ERR_VALUE+0x6419)
 #define SYNC_INFO_STATE_RESPONSE_DEVICE_FULL	                  	"数据已满:420"//(ERR_VALUE+0x6420)
 #define SYNC_INFO_STATE_RESPONSE_UNKNOWN_SEARCH_GRAMMAR	  			"搜索文法无法被识别:421"//(ERR_VALUE+0x6421)
 #define SYNC_INFO_STATE_RESPONSE_BAD_CGI_SCRIPT	          			"CGI脚本错误:422"//(ERR_VALUE+0x6422)
 #define SYNC_INFO_STATE_RESPONSE_SOFT_DELETE_CONFLICT	  			"软件删除发生冲突:423"//(ERR_VALUE+0x6423)
 #define SYNC_INFO_STATE_RESPONSE_SIZE_MISMATCH	          			"数据长度不一致:424"//(ERR_VALUE+0x6424)
 #define SYNC_INFO_STATE_RESPONSE_COMMAND_FAILED	             		"同步命令失败:500"//(ERR_VALUE+0x6500)
 #define SYNC_INFO_STATE_RESPONSE_COMMAND_NOT_IMPLEMENTED	     	"同步命令未被实现:501"//(ERR_VALUE+0x6501)
 #define SYNC_INFO_STATE_RESPONSE_BAD_GATEWAY	                     "网关错误:502"//(ERR_VALUE+0x6502)
 #define SYNC_INFO_STATE_RESPONSE_SERVICE_UNAVAILABLE	             "同步服务难以获得:503"//(ERR_VALUE+0x6503)
 #define SYNC_INFO_STATE_RESPONSE_GATEWAY_TIMEOUT	             	"网关处理超时:504"//(ERR_VALUE+0x6504)
 #define SYNC_INFO_STATE_RESPONSE_DTD_NOT_SUPPORTED	             	"DTD版本不被支持:505"//(ERR_VALUE+0x6505)
 #define SYNC_INFO_STATE_RESPONSE_PROCESSING_ERROR	             "处理同步请求是发生错误:506"//(ERR_VALUE+0x6506)
 #define SYNC_INFO_STATE_RESPONSE_ATOMIC_FAILED	             		"原子(Atomic)操作失败:507"//(ERR_VALUE+0x6507)
 #define SYNC_INFO_STATE_RESPONSE_REFRESH_REQUIRED	             	"同步刷新失败:508"//(ERR_VALUE+0x6508)
 #define SYNC_INFO_STATE_RESPONSE_DATA_STORE_FAILURE	             	"数据存储失败:510"//(ERR_VALUE+0x6510)
 #define SYNC_INFO_STATE_RESPONSE_SERVER_FAILURE	             		"服务器发生错误:511"//(ERR_VALUE+0x6511)
 #define SYNC_INFO_STATE_RESPONSE_SYNCHRONIZATION_FAILED	     		"同步失败:512"//(ERR_VALUE+0x6512)
 #define SYNC_INFO_STATE_RESPONSE_PROTOCOL_VERSION_NOT_SUPPORTED		  "SyncML版本不被支持:513"//(ERR_VALUE+0x6513)
 #define SYNC_INFO_STATE_RESPONSE_OPERATION_SUCCESS_CANCELED	       	"同步操作失败:514"//(ERR_VALUE+0x6514)
 #define SYNC_INFO_STATE_RESPONSE_OPERATION_FAIL_CANCELLED           "同步操作被取消:515" //(ERR_VALUE+0x6515)
 #define SYNC_INFO_STATE_RESPONSE_ATOMIC_ROLL_BACK_FAILED			"原子(Atomic)操作回滚失败:516"//(ERR_VALUE+0x6516)
 #define SYNC_INFO_STATE_RESPONSE_UNKNOWN_ERROR						"未知错误"//(ERR_VALUE+0x6517)
 
 
 ****************************************************************/

//char* smlGetSyncErrInfo(Ret_t rc);

