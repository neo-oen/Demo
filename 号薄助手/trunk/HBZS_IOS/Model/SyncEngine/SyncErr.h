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

#define SOCKET_SYNCML_DATA_RESEND   (ERR_VALUE+0x1028) //�����ط�����


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

#define	SYNC_ERROR_USERSTOP			 			(ERR_VALUE+0x3505)			 //�û�ȡ��ͬ��
#define	SYNC_ERROR_USERSETTING		 			(ERR_VALUE+0x3506)			 //�û����ô���
#define SYNC_ERROR_INCALL						(ERR_VALUE+0x3507)

#define SYNC_PAYMENT_FAILED				        (ERR_VALUE+0x3800)           //����ʧ��

/**
 *HTTP error code
 **/
#define   HTTP_ERR_BADREQUEST               	(ERR_VALUE+0x4400)//400 ��������﷨����
#define   HTTP_ERR_UNAUTHORIZED             	(ERR_VALUE+0x4401)//401 �ͻ���ͼδ����Ȩ���������뱣����ҳ�档
#define   HTTP_ERR_FORBIDDEN                	(ERR_VALUE+0x4403)//403 ��Դ�����á����������ͻ������󣬵��ܾ���������ͨ�����ڷ��������ļ���Ŀ¼��Ȩ�����õ��¡�
#define   HTTP_ERR_NOTFOUND                 	(ERR_VALUE+0x4404)//404 �޷��ҵ�ָ��λ�õ���Դ����Ҳ��һ�����õ�Ӧ��
#define   HTTP_ERR_METHODNOTALLOWED         	(ERR_VALUE+0x4405)//405 ���󷽷���GET��POST��HEAD��DELETE��PUT��TRACE�ȣ���ָ������Դ�����á���HTTP 1.1�£�
#define   HTTP_ERR_NOTACCEPTABLE            	(ERR_VALUE+0x4406)//406 ָ������Դ�Ѿ��ҵ���������MIME���ͺͿͻ���Accpetͷ����ָ���Ĳ����ݣ�HTTP 1.1�£���
#define   HTTP_ERR_PROXYAUTHENTICATIONREQUIRED	(ERR_VALUE+0x4407)//407 ������401����ʾ�ͻ������Ⱦ����������������Ȩ����HTTP 1.1�£�
#define   HTTP_ERR_REQUESTTIMEOUT             	(ERR_VALUE+0x4408)//408 �ڷ�������ɵĵȴ�ʱ���ڣ��ͻ�һֱû�з����κ����󡣿ͻ��������Ժ��ظ�ͬһ���󡣣�HTTP 1.1�£�
#define   HTTP_ERR_CONFLICT                   	(ERR_VALUE+0x4409)//409 ͨ����PUT�����йء������������Դ�ĵ�ǰ״̬���ͻ����������ܳɹ�����HTTP 1.1�£�
#define   HTTP_ERR_GONE                       	(ERR_VALUE+0x4410)//410 ��������ĵ��Ѿ����ٿ��ã����ҷ�������֪��Ӧ���ض�����һ����ַ��
#define   HTTP_ERR_LENGTH_REQUIRED            	(ERR_VALUE+0x4411)//411 ���������ܴ������󣬳��ǿͻ�����һ��Content-Lengthͷ��
#define   HTTP_ERR_PRECONDITIONFAILED         	(ERR_VALUE+0x4412)//412 ����ͷ��ָ����һЩǰ������ʧ�ܣ�HTTP 1.1�£���
#define   HTTP_ERR_REQUESTENTITYTOOLARGE      	(ERR_VALUE+0x4413)//413 Ŀ���ĵ��Ĵ�С������������ǰԸ�⴦��Ĵ�С
#define   HTTP_ERR_REQUESTURITOOLONG          	(ERR_VALUE+0x4414)//414 URI̫����HTTP 1.1�£���
#define   HTTP_ERR_REQUESTEDRANGENOTSATISFIABLE	(ERR_VALUE+0x4416)//416 ��������������ͻ���������ָ����Rangeͷ��
#define   HTTP_ERR_INTERNALSERVERERROR          (ERR_VALUE+0x4500)//500 ���������������ϲ����������������ɿͻ�������
#define   HTTP_ERR_NOTIMPLEMENTED               (ERR_VALUE+0x4501)//501 ��������֧��ʵ����������Ҫ�Ĺ��ܡ�
#define   HTTP_ERR_BADGATEWAY                   (ERR_VALUE+0x4502)//502 ��������Ϊ���ػ��ߴ���ʱ��Ϊ��������������һ�������������÷����������˷Ƿ���Ӧ��
#define   HTTP_ERR_SERVICEUNAVAILABLE           (ERR_VALUE+0x4503)//503 ����������ά�����߸��ع���δ��Ӧ��
#define   HTTP_ERR_GATEWAYTIMEOUT               (ERR_VALUE+0x4504)//504 ����Ϊ��������صķ�����ʹ�ã���ʾ���ܼ�ʱ�ش�Զ�̷��������Ӧ��
#define   HTTP_ERR_HTTPVERSIONNOTSUPPORTED      (ERR_VALUE+0x4505)//505 ��������֧����������ָ����HTTP�汾
#define	  HTTP_ERR_RESPONSEHEADER				(ERR_VALUE+0x4506)//	  ���������ص�Repsonseͷ�����д���
#define   HTTP_ERR_SENDLENGTHERROR				(ERR_VALUE+0x4507)//		Socket���͵İ�����
#define   HTTP_ERR_FAILTOCREATEHEAD				(ERR_VALUE+0x4508)//		Socket���͵İ�����
#define   HTTP_ERR_SOCKET_ABORT					(ERR_VALUE+0x4509)//		�������											
#define  HTTP_ERR_NEED_GETNEXTDATA							(ERR_VALUE+0x450A)
#define   HTTP_ERR_PARSE_DNS                    (ERR_VALUE+0x450B)  //dns ��������
#define   HTTP_ERR_READ_FROM_SERVER             (ERR_VALUE+0x450C)  //�����������ʧ��
#define   HTTP_ERR_WRITE_TO_SERVER              (ERR_VALUE+0x450D)  //���緢������ʧ��
#define   HTTP_ERR_CONNECT_TO_SERVER            (ERR_VALUE+0x450E)  //���ӷ�����ʧ��
#define   HTTP_ERR_CLOSE_FROM_SERVER            (ERR_VALUE+0x450F)  //�������ر�������
#define   HTTP_ERR_RECV_DATA_TOOLONG               (ERR_VALUE+0x4510)  //���յ����ݰ�̫���޷�����
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
#define    DATA_ERR_PIM_FULL					(ERR_VALUE+0x530B)		// ��
#define    DATA_ERR_PIM_OCCUPIED				(ERR_VALUE+0x530C)	// �Ѿ���ʹ����--���ʱ�����λ��Ӧ��û��	
#define    DATA_ERR_PIM_DUP_NAME				(ERR_VALUE+0x530E)	// �����ظ�(ͨѶ���������������ظ���������)
#define    DATA_ERR_PIM_OPEN_CONTACTS              (ERR_VALUE+0x530F)

#define    DATA_ERR_LOG_MOBILE_FULL             (ERR_VALUE+0x5310)//   log_mobile_full 4		//�ֻ��ճ�����
#define    DATA_ERR_LOG_MOBILE_EMPTY            (ERR_VALUE+0x5311)//log_mobile_empty 5	        //�ճ�Ϊ��
#define    DATA_ERR_LOG_ID_OUTRANGE             (ERR_VALUE+0x5312)// log_id_outrange 6		    //����id�����ֻ�����ɾ����Χ

#define	   DATA_ERR_FAIL_GET_LISTEN_LOG			(ERR_VALUE+0x5313) //��ȡ������Ϣ����
#define	   DATA_ERR_FAIL_SET_LISTEN_LOG			(ERR_VALUE+0x5314) //���ü�����Ϣ����
#define	   DATA_ERR_FAIL_DEL_LISTEN_LOG			(ERR_VALUE+0x5315) //ɾ��������Ϣ����

#define      DATA_ERR_PIM_ADD_WAIT                            (ERR_VALUE+0x5316)
#define      DATA_ERR_PIM_REPLACE_WAIT                            (ERR_VALUE+0x5317)
#define      DATA_ERR_PIM_DEL_WAIT                            (ERR_VALUE+0x5318)

#define      DATA_ERR_PIM_DIED_WAIT			     (ERR_VALUE+0x5319)  //���ݿⱻռ�û�����,��Ҫ�ȴ�ʱ�������¿�ʼ
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
 
 #define SYNC_INFO_SUCCESS   "ͬ���ɹ�"
 
 #define SYNC_INFO_NOT_ENOUGH_SPACE     "�ڴ治��"
 #define SYNC_INFO_FAIL_FILE_OPERATION    "�ļ�����ʧ��"
 
 #define SYNC_INFO_GPRS_CONNECT         "GPRS����ʧ��"
 #define SYNC_INFO_CREATE_TASK          "�޷���������"
 #define SYNC_INFO_NO_PORT              "�Ҳ����˿ں�"
 #define  SYNC_INFO_NO_USERNAME         "�Ҳ����û���"
 #define  SYNC_INFO_NO_SERVER_ADDRESS   "�Ҳ�����������ַ"
 #define   SYNC_INFO_NO_USERPAS         "�Ҳ����û�����"
 #define   SYNC_INFO_NO_SYNC_TARGET      "�Ҳ���ͬ��Ŀ����"
 #define SYNC_INFO_FAIL_RECEIVE_DATA  "��������ʧ��"
 #define SYNC_INFO_UNKNOW 			 	"δ֪����"
 
 
 
 // general errors
 #define SYNC_INFO_SYSTEM     "ϵͳ�ڲ�����"
 
 #define SYNC_INFO_XML    "XML��WBXML�������"
 
 #define SYNC_INFO_WSM_BUF_TABLE_FULL    "ϵͳ�ڲ�����"   // no more empty entries in buffer table available
 
 #define SYNC_INFO_A_UTI_UNKNOWN_PROTO_ELEMENT 	"δ֪ͬ������"
 
 
 
 #define SYNC_INFO_SYNCMETHOD_UNSUPPORTED 		"ͬ����������֧��"
 #define SYNC_INFO_INCOMPLETE_SYNCINFO    		"ͬ����Ϣ������"
 #define SYNC_INFO_WRONG_PARAM        			"ϵͳ�ڲ�����"
 #define SYNC_INFO_NOT_ENOUGH_SPACE   			"�ڴ治��"     // not enough memory to perform this operation
 
 #define SYNC_INFO_DBA_DB_NOT_FOUND   			"���ݿⲻ����"
 #define SYNC_INFO_DBA_DB_OPEN_FAILED 			"���ݿ��ʧ��"
 #define SYNC_INFO_DBA_INTERNAL       			"��Ӽ�¼ʧ��"
 
 #define SYNC_INFO_DBACCESS           			"���ݿ����ʧ��"
 #define SYNC_INFO_DATAEXCHANGE       			"���ݽ���ʧ��"
 #define SYNC_INFO_CREATE_DATA        			"���ݽ���ʧ��"
 #define SYNC_INFO_HANDLE_DATA        			"���ݴ���ʧ��"
 #define SYNC_INFO_RUNTIME            			"ϵͳ�ڲ�����"
 #define SYNC_INFO_CL_INTERNAL	  				"ϵͳ�ڲ�����"
 
 #define SYNC_INFO_SYNC_ENGINE_STATE				"ͬ��״̬����"
 #define SYNC_INFO_XLT_MISSING_CONT				"ͬ�����ݴ���"
 #define SYNC_INFO_SYNC_ENGINE_STATE_NOT_CHANGE	"ͬ��״̬�޷�ת��"
 
 #define	SYNC_INFO_USERSTOP			 			"�û�ȡ��ͬ��"	 //�û�ȡ��ͬ��
 #define	SYNC_INFO_USERSETTING		 			"�û����ô���"			 //�û����ô���
 
 #define   SYNC_INFO_HTTP_ERR_BADREQUEST               "HTTP����400"//400 ��������﷨����
 #define   SYNC_INFO_HTTP_ERR_UNAUTHORIZED            "HTTP����401"//401 �ͻ���ͼδ����Ȩ���������뱣����ҳ�档
 #define   SYNC_INFO_HTTP_ERR_FORBIDDEN                "HTTP����403"//403 ��Դ�����á����������ͻ������󣬵��ܾ���������ͨ�����ڷ��������ļ���Ŀ¼��Ȩ�����õ��¡�
 #define   SYNC_INFO_HTTP_ERR_NOTFOUND                 "HTTP����404"//404 �޷��ҵ�ָ��λ�õ���Դ����Ҳ��һ�����õ�Ӧ��
 #define   SYNC_INFO_HTTP_ERR_METHODNOTALLOWED         "HTTP����405"//405 ���󷽷���GET��POST��HEAD��DELETE��PUT��TRACE�ȣ���ָ������Դ�����á���HTTP 1.1�£�
 #define   SYNC_INFO_HTTP_ERR_NOTACCEPTABLE            	"HTTP����406"//406 ָ������Դ�Ѿ��ҵ���������MIME���ͺͿͻ���Accpetͷ����ָ���Ĳ����ݣ�HTTP 1.1�£���
 #define   SYNC_INFO_HTTP_ERR_PROXYAUTHENTICATIONREQUIRED	"HTTP����407"//407 ������401����ʾ�ͻ������Ⱦ����������������Ȩ����HTTP 1.1�£�
 #define   SYNC_INFO_HTTP_ERR_REQUESTTIMEOUT             	"HTTP����408"//408 �ڷ�������ɵĵȴ�ʱ���ڣ��ͻ�һֱû�з����κ����󡣿ͻ��������Ժ��ظ�ͬһ���󡣣�HTTP 1.1�£�
 #define   SYNC_INFO_HTTP_ERR_CONFLICT                   	"HTTP����409"//409 ͨ����PUT�����йء������������Դ�ĵ�ǰ״̬���ͻ����������ܳɹ�����HTTP 1.1�£�
 #define   SYNC_INFO_HTTP_ERR_GONE                       	"HTTP����410"//410 ��������ĵ��Ѿ����ٿ��ã����ҷ�������֪��Ӧ���ض�����һ����ַ��
 #define   SYNC_INFO_HTTP_ERR_LENGTH_REQUIRED            "HTTP����411"//411 ���������ܴ������󣬳��ǿͻ�����һ��Content-Lengthͷ��
 #define   SYNC_INFO_HTTP_ERR_PRECONDITIONFAILED         	"HTTP����412"//412 ����ͷ��ָ����һЩǰ������ʧ�ܣ�HTTP 1.1�£���
 #define   SYNC_INFO_HTTP_ERR_REQUESTENTITYTOOLARGE      	"HTTP����413"//413 Ŀ���ĵ��Ĵ�С������������ǰԸ�⴦��Ĵ�С
 
 #define   SYNC_INFO_HTTP_ERR_REQUESTURITOOLONG          	"HTTP����414"//414 URI̫����HTTP 1.1�£���
 #define   SYNC_INFO_HTTP_ERR_REQUESTEDRANGENOTSATISFIABLE	"HTTP����416"//416 ��������������ͻ���������ָ����Rangeͷ��
 #define   SYNC_INFO_HTTP_ERR_INTERNALSERVERERROR          "HTTP����500"//500 ���������������ϲ����������������ɿͻ�������
 #define   SYNC_INFO_HTTP_ERR_NOTIMPLEMENTED               "HTTP����501"//501 ��������֧��ʵ����������Ҫ�Ĺ��ܡ�
 #define   SYNC_INFO_HTTP_ERR_BADGATEWAY                   "HTTP����502"//502 ��������Ϊ���ػ��ߴ���ʱ��Ϊ��������������һ�������������÷����������˷Ƿ���Ӧ��
 #define   SYNC_INFO_HTTP_ERR_SERVICEUNAVAILABLE           "HTTP����503"//503 ����������ά�����߸��ع���δ��Ӧ��
 #define   SYNC_INFO_HTTP_ERR_GATEWAYTIMEOUT               "HTTP����504"//504 ����Ϊ��������صķ�����ʹ�ã���ʾ���ܼ�ʱ�ش�Զ�̷��������Ӧ��
 #define   SYNC_INFO_HTTP_ERR_HTTPVERSIONNOTSUPPORTED      "HTTP����505"//505 ��������֧����������ָ����HTTP�汾
 #define	  SYNC_INFO_HTTP_ERR_RESPONSEHEADER				"������������Ϣ����"//	  ���������ص�Repsonseͷ�����д���
 #define   SYNC_INFO_HTTP_ERR_SENDLENGTHERROR				"������Ϣ����"//		Socket���͵İ�����
 #define   SYNC_INFO_HTTP_ERR_FAILTOCREATEHEAD			"������Ϣ����"//		Socket���͵İ�����
 #define   SYNC_INFO_HTTP_ERR_SOCKET_ABORT					"�������"//		�������											
 
 #define    SYNC_INFO_VCARD_ERROR              	"vCard���ݴ���ʧ��"
 
 
 #define    SYNC_INFO_VCALENDAR_ERROR              "vCalendar���ݴ���ʧ��"
 
 
 #define    SYNC_INFO_LISTEN_ERROR       	"���ݿ����ʧ��"
 
 #define    SYNC_INFO_PIM_OPERATION			"ͨѶ¼����ʧ��"
 
 #define    SYNC_INFO_PIM_UNAVAILABLE	 	"ͨѶ¼������"
 
 #define    SYNC_INFO_PIM_NOT_FOUND	 		"ͨѶ¼������"
 #define    SYNC_INFO_PIM_EMPTY	 		"ͨѶ¼Ϊ��"
 #define    SYNC_INFO_PIM_FULL			"ͨѶ¼����"		// ��
 
 #define    SYNC_INFO_PIM_DUP_NAME		"ͨѶ¼�������ظ�"	// �����ظ�(ͨѶ���������������ظ���������)
 
 #define    SYNC_INFO_LOG_MOBILE_FULL     "�ճ̱�����"//   log_mobile_full 4		//�ֻ��ճ�����
 #define    SYNC_INFO_LOG_MOBILE_EMPTY    "�ճ̱�Ϊ��"//log_mobile_empty 5	        //�ճ�Ϊ��
 #define    SYNC_INFO_LOG_ID_OUTRANGE     "����id�����ֻ�����ɾ����Χ"// log_id_outrange 6		    //����id�����ֻ�����ɾ����Χ
 
 #define	   SYNC_INFO_FAIL_GET_LISTEN_LOG	"��ȡ������Ϣ����" //��ȡ������Ϣ����
 #define	   SYNC_INFO_FAIL_SET_LISTEN_LOG		"���ü�����Ϣ����" //���ü�����Ϣ����
 #define	   SYNC_INFO_FAIL_DEL_LISTEN_LOG		"ɾ��������Ϣ����" //ɾ��������Ϣ����
 
 
 
 #define SYNC_INFO_STATE_RESPONSE_IN_PROGRESS 		"����ͬ����:101"//(ERR_VALUE+0x6101)
 #define SYNC_INFO_STATE_RESPONSE_OK	        		"ͬ���ɹ�:200"//(ERR_VALUE+0x6200)
 #define SYNC_INFO_STATE_RESPONSE_ITEM_ADDED			"��¼��ӳɹ�:201"//(ERR_VALUE+0x6201)
 #define SYNC_INFO_STATE_RESPONSE_ACCEPTED_FOR_PROCESSING	    "�ɹ�ִ��:202"//(ERR_VALUE+0x6202)
 #define SYNC_INFO_STATE_RESPONSE_NONAUTHORIATATIVE_RESPONSE	"û����֤��Ӧ:203"//(ERR_VALUE+0x6203)
 #define SYNC_INFO_STATE_RESPONSE_NO_CONTENT	          "û������:204"//(ERR_VALUE+0x6204)
 #define SYNC_INFO_STATE_RESPONSE_RESET_CONTENT	     "Դ����Ҫ����:205"//(ERR_VALUE+0x6205)
 #define SYNC_INFO_STATE_RESPONSE_PARTIAL_CONTENT	     "���ݳɹ�:206"//(ERR_VALUE+0x6206)
 #define SYNC_INFO_STATE_RESPONSE_CONFLICT_RESOLVED_WITH_MERGE	"���ݺϲ���ͻ:207"//(ERR_VALUE+0x6207)
 #define SYNC_INFO_STATE_RESPONSE_CONFLICT_RESOLVED_WITH_CLIENT_WINNING	"���ݴ����ͻ:208"//(ERR_VALUE+0x6208)
 #define SYNC_INFO_STATE_RESPONSE_CONFILCT_RESOLVED_WITH_DUPLICATE	"���ݿ�����ͻ:209"//(ERR_VALUE+0x6209)
 #define SYNC_INFO_STATE_RESPONSE_DELETE_WITHOUT_ARCHIVE	      	"ɾ���ɹ���û�Ըò����浵:210"//(ERR_VALUE+0x6210)
 #define SYNC_INFO_STATE_RESPONSE_ITEM_NO_DELETED	   	"ɾ��Ŀ��δ�ҵ�:211"//(ERR_VALUE+0x6211)
 #define SYNC_INFO_STATE_RESPONSE_AUTHENTICATION_ACCEPTED	       "��֤������:212"//(ERR_VALUE+0x6212)
 #define SYNC_INFO_STATE_RESPONSE_CHUNKED_ITEM "���յ�����̫��:213"//(ERR_VALUE+0x6213)
 #define SYNC_INFO_STATE_RESPONSE_OPERATION_CANCELED	                  	"������ȡ��:214"//(ERR_VALUE+0x6214)
 #define SYNC_INFO_STATE_RESPONSE_NO_EXECUTED	                          "����û��ִ��:215"//(ERR_VALUE+0x6215)
 #define SYNC_INFO_STATE_RESPONSE_ATOMIC_ROLL_BACK_OK	                  "�ɹ������ع�:216"//(ERR_VALUE+0x6216)
 #define SYNC_INFO_STATE_RESPONSE_MULTIPLE_CHOICES	        			"ͬ��Ŀ����Ҫ���滻:300"//(ERR_VALUE+0x6300)
 #define SYNC_INFO_STATE_RESPONSE_MOVED_PERMANENTLY	        			"Ŀ��URL��Ҫ����:301"//(ERR_VALUE+0x6301)
 #define SYNC_INFO_STATE_RESPONSE_TMPORARITY_FOUND	        			"ͬ��Ŀ����ʱ��ת������ͬURL��:302"//(ERR_VALUE+0x6302)
 #define SYNC_INFO_STATE_RESPONSE_SEE_OTHER	                		"ͬ��Ŀ��������URL�д���:303"//(ERR_VALUE+0x6303)
 #define SYNC_INFO_STATE_RESPONSE_NOT_MODIFIED	        				"ͬ������δ��ִ��:304"//(ERR_VALUE+0x6304)
 #define SYNC_INFO_STATE_RESPONSE_USE_PROXY	                			"ͬ��Ŀ��Ҫ����URL����:305"//(ERR_VALUE+0x6305)
 #define SYNC_INFO_STATE_RESPONSE_BAD_REQUEST	                  		"ͬ���������:400"//(ERR_VALUE+0x6400)
 #define SYNC_INFO_STATE_RESPONSE_INVALID_CREDENTIALS	          			"��֤δ��ͨ��:401"//(ERR_VALUE+0x6401)
 #define SYNC_INFO_STATE_RESPONSE_INVALID_PAYMENT	          				"��Ҫ����:402"//(ERR_VALUE+0x6402)
 #define SYNC_INFO_STATE_RESPONSE_COMMAND_FORBIDDEN	          			"ͬ�����󱻽�ֹ:403"//(ERR_VALUE+0x6403)
 #define SYNC_INFO_STATE_RESPONSE_NOT_FOUND	                  			"ͬ��Ŀ�겻����:404"//(ERR_VALUE+0x6404)
 #define SYNC_INFO_STATE_RESPONSE_COMMAND_NOT_ALLOWED	          		"ͬ�����������:405"//(ERR_VALUE+0x6405)
 #define SYNC_INFO_STATE_RESPONSE_OPTIONAL_NOT_SUPPORTED	  				"ͬ�������е�ĳЩ���ݲ���֧��:406"//(ERR_VALUE+0x6406)
 #define SYNC_INFO_STATE_RESPONSE_MISSING_CREDENTIALS	          		"û����֤��Ϣ:407"//(ERR_VALUE+0x6407)
 #define SYNC_INFO_STATE_RESPONSE_REQUEST_TIMEOUT	          			"ͬ������ʱ:408"//(ERR_VALUE+0x6408)
 #define SYNC_INFO_STATE_RESPONSE_REQUEST_CONFLICT	          			"���ݸ��³�ͻ:409"//(ERR_VALUE+0x6409)
 #define SYNC_INFO_STATE_RESPONSE_REQUESTED_TARGET_GONE	  				"ͬ��Ŀ�겻�ٴ���:410"//(ERR_VALUE+0x6410)
 #define SYNC_INFO_STATE_RESPONSE_SIZE_REQUIRED	          			"ͬ�����ݳ���δ�ҵ�:411"//(ERR_VALUE+0x6411)
 #define SYNC_INFO_STATE_RESPONSE_INCOMPLETE_COMMAND	          		"ͬ���������:412"//(ERR_VALUE+0x6412)
 #define SYNC_INFO_STATE_RESPONSE_ENTITY_TOO_LARGE	          		"ͬ������̫��:413"//(ERR_VALUE+0x6413)
 #define SYNC_INFO_STATE_RESPONSE_URI_TOO_LONG	          			"URL̫��:414"//(ERR_VALUE+0x6414)
 #define SYNC_INFO_STATE_RESPONSE_UNSUPPORTED_MEDIA	          		"���ݸ�ʽ����֧��:415"//	(ERR_VALUE+0x6415)
 #define SYNC_INFO_STATE_RESPONSE_REQUEST_SIZE_TOO_BIG	  			"ͬ����������ݳ���̫��:416"//(ERR_VALUE+0x6416)
 #define SYNC_INFO_STATE_RESPONSE_RETRY_LATER	                  	"ͬ��������Ҫ����:417"//(ERR_VALUE+0x6417)
 #define SYNC_INFO_STATE_RESPONSE_ALREADY_EXISTS	          			"ͬ��Ŀ���Ѿ�����:418"//(ERR_VALUE+0x6418)
 #define SYNC_INFO_STATE_RESPONSE_CONFLICT_WITH_SERVER_DATA	  		"�ͷ����������ݷ�����ͻ:419"//(ERR_VALUE+0x6419)
 #define SYNC_INFO_STATE_RESPONSE_DEVICE_FULL	                  	"��������:420"//(ERR_VALUE+0x6420)
 #define SYNC_INFO_STATE_RESPONSE_UNKNOWN_SEARCH_GRAMMAR	  			"�����ķ��޷���ʶ��:421"//(ERR_VALUE+0x6421)
 #define SYNC_INFO_STATE_RESPONSE_BAD_CGI_SCRIPT	          			"CGI�ű�����:422"//(ERR_VALUE+0x6422)
 #define SYNC_INFO_STATE_RESPONSE_SOFT_DELETE_CONFLICT	  			"���ɾ��������ͻ:423"//(ERR_VALUE+0x6423)
 #define SYNC_INFO_STATE_RESPONSE_SIZE_MISMATCH	          			"���ݳ��Ȳ�һ��:424"//(ERR_VALUE+0x6424)
 #define SYNC_INFO_STATE_RESPONSE_COMMAND_FAILED	             		"ͬ������ʧ��:500"//(ERR_VALUE+0x6500)
 #define SYNC_INFO_STATE_RESPONSE_COMMAND_NOT_IMPLEMENTED	     	"ͬ������δ��ʵ��:501"//(ERR_VALUE+0x6501)
 #define SYNC_INFO_STATE_RESPONSE_BAD_GATEWAY	                     "���ش���:502"//(ERR_VALUE+0x6502)
 #define SYNC_INFO_STATE_RESPONSE_SERVICE_UNAVAILABLE	             "ͬ���������Ի��:503"//(ERR_VALUE+0x6503)
 #define SYNC_INFO_STATE_RESPONSE_GATEWAY_TIMEOUT	             	"���ش���ʱ:504"//(ERR_VALUE+0x6504)
 #define SYNC_INFO_STATE_RESPONSE_DTD_NOT_SUPPORTED	             	"DTD�汾����֧��:505"//(ERR_VALUE+0x6505)
 #define SYNC_INFO_STATE_RESPONSE_PROCESSING_ERROR	             "����ͬ�������Ƿ�������:506"//(ERR_VALUE+0x6506)
 #define SYNC_INFO_STATE_RESPONSE_ATOMIC_FAILED	             		"ԭ��(Atomic)����ʧ��:507"//(ERR_VALUE+0x6507)
 #define SYNC_INFO_STATE_RESPONSE_REFRESH_REQUIRED	             	"ͬ��ˢ��ʧ��:508"//(ERR_VALUE+0x6508)
 #define SYNC_INFO_STATE_RESPONSE_DATA_STORE_FAILURE	             	"���ݴ洢ʧ��:510"//(ERR_VALUE+0x6510)
 #define SYNC_INFO_STATE_RESPONSE_SERVER_FAILURE	             		"��������������:511"//(ERR_VALUE+0x6511)
 #define SYNC_INFO_STATE_RESPONSE_SYNCHRONIZATION_FAILED	     		"ͬ��ʧ��:512"//(ERR_VALUE+0x6512)
 #define SYNC_INFO_STATE_RESPONSE_PROTOCOL_VERSION_NOT_SUPPORTED		  "SyncML�汾����֧��:513"//(ERR_VALUE+0x6513)
 #define SYNC_INFO_STATE_RESPONSE_OPERATION_SUCCESS_CANCELED	       	"ͬ������ʧ��:514"//(ERR_VALUE+0x6514)
 #define SYNC_INFO_STATE_RESPONSE_OPERATION_FAIL_CANCELLED           "ͬ��������ȡ��:515" //(ERR_VALUE+0x6515)
 #define SYNC_INFO_STATE_RESPONSE_ATOMIC_ROLL_BACK_FAILED			"ԭ��(Atomic)�����ع�ʧ��:516"//(ERR_VALUE+0x6516)
 #define SYNC_INFO_STATE_RESPONSE_UNKNOWN_ERROR						"δ֪����"//(ERR_VALUE+0x6517)
 
 
 ****************************************************************/

//char* smlGetSyncErrInfo(Ret_t rc);

