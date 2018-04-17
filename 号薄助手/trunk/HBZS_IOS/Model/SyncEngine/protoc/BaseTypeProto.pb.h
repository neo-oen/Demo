// Generated by the protocol buffer compiler.  DO NOT EDIT!

#import "ProtocolBuffers.h"

@class Address;
@class Address_Builder;
@class Category;
@class Category_Builder;
@class Email;
@class Email_Builder;
@class Employed;
@class Employed_Builder;
@class InstantMessage;
@class InstantMessage_Builder;
@class Name;
@class Name_Builder;
@class Phone;
@class Phone_Builder;
@class PortraitData;
@class PortraitData_Builder;
@class Sms;
@class SmsSummary;
@class SmsSummary_Builder;
@class Sms_Builder;
@class UabError;
@class UabError_Builder;
@class Website;
@class Website_Builder;

typedef enum {
  GenderUnknownGender = 0,
  GenderMale = 1,
  GenderFemale = 2,
} Gender;

BOOL GenderIsValidValue(Gender value);

typedef enum {
  ConstellationUnknownConstellation = 0,
  ConstellationCapricorn = 1,
  ConstellationAquarius = 2,
  ConstellationPisces = 3,
  ConstellationAries = 4,
  ConstellationTaurus = 5,
  ConstellationGemini = 6,
  ConstellationCancer = 7,
  ConstellationLeo = 8,
  ConstellationVirgo = 9,
  ConstellationLibra = 10,
  ConstellationScorpio = 11,
  ConstellationSagittarius = 12,
} Constellation;

BOOL ConstellationIsValidValue(Constellation value);

typedef enum {
  BloodTypeUnknownBloodType = 0,
  BloodTypeA = 1,
  BloodTypeB = 2,
  BloodTypeO = 3,
  BloodTypeAb = 4,
} BloodType;

BOOL BloodTypeIsValidValue(BloodType value);

typedef enum {
  ImageTypeUnknownImageType = 0,
  ImageTypeJpg = 1,
} ImageType;

BOOL ImageTypeIsValidValue(ImageType value);

typedef enum {
  SmsTypeNormal = 0,
  SmsTypeDraft = 1,
} SmsType;

BOOL SmsTypeIsValidValue(SmsType value);

typedef enum {
  SmsSendTypeSend = 1,
  SmsSendTypeReceive = 2,
} SmsSendType;

BOOL SmsSendTypeIsValidValue(SmsSendType value);


@interface BaseTypeProtoRoot : NSObject {
}
+ (PBExtensionRegistry*) extensionRegistry;
+ (void) registerAllExtensions:(PBMutableExtensionRegistry*) registry;
@end

@interface Category : PBGeneratedMessage {
@private
  BOOL hasType_:1;
  BOOL hasLabel_:1;
  int32_t type;
  NSString* label;
}
- (BOOL) hasType;
- (BOOL) hasLabel;
@property (readonly) int32_t type;
@property (readonly, retain) NSString* label;

+ (Category*) defaultInstance;
- (Category*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (Category_Builder*) builder;
+ (Category_Builder*) builder;
+ (Category_Builder*) builderWithPrototype:(Category*) prototype;

+ (Category*) parseFromData:(NSData*) data;
+ (Category*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (Category*) parseFromInputStream:(NSInputStream*) input;
+ (Category*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (Category*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (Category*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface Category_Builder : PBGeneratedMessage_Builder {
@private
  Category* result;
}

- (Category*) defaultInstance;

- (Category_Builder*) clear;
- (Category_Builder*) clone;

- (Category*) build;
- (Category*) buildPartial;

- (Category_Builder*) mergeFrom:(Category*) other;
- (Category_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (Category_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasType;
- (int32_t) type;
- (Category_Builder*) setType:(int32_t) value;
- (Category_Builder*) clearType;

- (BOOL) hasLabel;
- (NSString*) label;
- (Category_Builder*) setLabel:(NSString*) value;
- (Category_Builder*) clearLabel;
@end

@interface Address : PBGeneratedMessage {
@private
  BOOL hasAddrValue_:1;
  BOOL hasAddrPostal_:1;
  BOOL hasCategory_:1;
  NSString* addrValue;
  NSString* addrPostal;
  Category* category;
}
- (BOOL) hasCategory;
- (BOOL) hasAddrValue;
- (BOOL) hasAddrPostal;
@property (readonly, retain) Category* category;
@property (readonly, retain) NSString* addrValue;
@property (readonly, retain) NSString* addrPostal;

+ (Address*) defaultInstance;
- (Address*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (Address_Builder*) builder;
+ (Address_Builder*) builder;
+ (Address_Builder*) builderWithPrototype:(Address*) prototype;

+ (Address*) parseFromData:(NSData*) data;
+ (Address*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (Address*) parseFromInputStream:(NSInputStream*) input;
+ (Address*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (Address*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (Address*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface Address_Builder : PBGeneratedMessage_Builder {
@private
  Address* result;
}

- (Address*) defaultInstance;

- (Address_Builder*) clear;
- (Address_Builder*) clone;

- (Address*) build;
- (Address*) buildPartial;

- (Address_Builder*) mergeFrom:(Address*) other;
- (Address_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (Address_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasCategory;
- (Category*) category;
- (Address_Builder*) setCategory:(Category*) value;
- (Address_Builder*) setCategoryBuilder:(Category_Builder*) builderForValue;
- (Address_Builder*) mergeCategory:(Category*) value;
- (Address_Builder*) clearCategory;

- (BOOL) hasAddrValue;
- (NSString*) addrValue;
- (Address_Builder*) setAddrValue:(NSString*) value;
- (Address_Builder*) clearAddrValue;

- (BOOL) hasAddrPostal;
- (NSString*) addrPostal;
- (Address_Builder*) setAddrPostal:(NSString*) value;
- (Address_Builder*) clearAddrPostal;
@end

@interface Email : PBGeneratedMessage {
@private
  BOOL hasEmailValue_:1;
  BOOL hasCategory_:1;
  NSString* emailValue;
  Category* category;
}
- (BOOL) hasCategory;
- (BOOL) hasEmailValue;
@property (readonly, retain) Category* category;
@property (readonly, retain) NSString* emailValue;

+ (Email*) defaultInstance;
- (Email*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (Email_Builder*) builder;
+ (Email_Builder*) builder;
+ (Email_Builder*) builderWithPrototype:(Email*) prototype;

+ (Email*) parseFromData:(NSData*) data;
+ (Email*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (Email*) parseFromInputStream:(NSInputStream*) input;
+ (Email*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (Email*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (Email*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface Email_Builder : PBGeneratedMessage_Builder {
@private
  Email* result;
}

- (Email*) defaultInstance;

- (Email_Builder*) clear;
- (Email_Builder*) clone;

- (Email*) build;
- (Email*) buildPartial;

- (Email_Builder*) mergeFrom:(Email*) other;
- (Email_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (Email_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasCategory;
- (Category*) category;
- (Email_Builder*) setCategory:(Category*) value;
- (Email_Builder*) setCategoryBuilder:(Category_Builder*) builderForValue;
- (Email_Builder*) mergeCategory:(Category*) value;
- (Email_Builder*) clearCategory;

- (BOOL) hasEmailValue;
- (NSString*) emailValue;
- (Email_Builder*) setEmailValue:(NSString*) value;
- (Email_Builder*) clearEmailValue;
@end

@interface Employed : PBGeneratedMessage {
@private
  BOOL hasEmpCompany_:1;
  BOOL hasEmpDept_:1;
  BOOL hasEmpTitle_:1;
  NSString* empCompany;
  NSString* empDept;
  NSString* empTitle;
}
- (BOOL) hasEmpCompany;
- (BOOL) hasEmpDept;
- (BOOL) hasEmpTitle;
@property (readonly, retain) NSString* empCompany;
@property (readonly, retain) NSString* empDept;
@property (readonly, retain) NSString* empTitle;

+ (Employed*) defaultInstance;
- (Employed*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (Employed_Builder*) builder;
+ (Employed_Builder*) builder;
+ (Employed_Builder*) builderWithPrototype:(Employed*) prototype;

+ (Employed*) parseFromData:(NSData*) data;
+ (Employed*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (Employed*) parseFromInputStream:(NSInputStream*) input;
+ (Employed*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (Employed*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (Employed*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface Employed_Builder : PBGeneratedMessage_Builder {
@private
  Employed* result;
}

- (Employed*) defaultInstance;

- (Employed_Builder*) clear;
- (Employed_Builder*) clone;

- (Employed*) build;
- (Employed*) buildPartial;

- (Employed_Builder*) mergeFrom:(Employed*) other;
- (Employed_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (Employed_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasEmpCompany;
- (NSString*) empCompany;
- (Employed_Builder*) setEmpCompany:(NSString*) value;
- (Employed_Builder*) clearEmpCompany;

- (BOOL) hasEmpDept;
- (NSString*) empDept;
- (Employed_Builder*) setEmpDept:(NSString*) value;
- (Employed_Builder*) clearEmpDept;

- (BOOL) hasEmpTitle;
- (NSString*) empTitle;
- (Employed_Builder*) setEmpTitle:(NSString*) value;
- (Employed_Builder*) clearEmpTitle;
@end

@interface InstantMessage : PBGeneratedMessage {
@private
  BOOL hasImValue_:1;
  BOOL hasCategory_:1;
  NSString* imValue;
  Category* category;
}
- (BOOL) hasCategory;
- (BOOL) hasImValue;
@property (readonly, retain) Category* category;
@property (readonly, retain) NSString* imValue;

+ (InstantMessage*) defaultInstance;
- (InstantMessage*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (InstantMessage_Builder*) builder;
+ (InstantMessage_Builder*) builder;
+ (InstantMessage_Builder*) builderWithPrototype:(InstantMessage*) prototype;

+ (InstantMessage*) parseFromData:(NSData*) data;
+ (InstantMessage*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (InstantMessage*) parseFromInputStream:(NSInputStream*) input;
+ (InstantMessage*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (InstantMessage*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (InstantMessage*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface InstantMessage_Builder : PBGeneratedMessage_Builder {
@private
  InstantMessage* result;
}

- (InstantMessage*) defaultInstance;

- (InstantMessage_Builder*) clear;
- (InstantMessage_Builder*) clone;

- (InstantMessage*) build;
- (InstantMessage*) buildPartial;

- (InstantMessage_Builder*) mergeFrom:(InstantMessage*) other;
- (InstantMessage_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (InstantMessage_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasCategory;
- (Category*) category;
- (InstantMessage_Builder*) setCategory:(Category*) value;
- (InstantMessage_Builder*) setCategoryBuilder:(Category_Builder*) builderForValue;
- (InstantMessage_Builder*) mergeCategory:(Category*) value;
- (InstantMessage_Builder*) clearCategory;

- (BOOL) hasImValue;
- (NSString*) imValue;
- (InstantMessage_Builder*) setImValue:(NSString*) value;
- (InstantMessage_Builder*) clearImValue;
@end

@interface Name : PBGeneratedMessage {
@private
  BOOL hasFamilyName_:1;
  BOOL hasGivenName_:1;
  BOOL hasNickName_:1;
  NSString* familyName;
  NSString* givenName;
  NSString* nickName;
}
- (BOOL) hasFamilyName;
- (BOOL) hasGivenName;
- (BOOL) hasNickName;
@property (readonly, retain) NSString* familyName;
@property (readonly, retain) NSString* givenName;
@property (readonly, retain) NSString* nickName;

+ (Name*) defaultInstance;
- (Name*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (Name_Builder*) builder;
+ (Name_Builder*) builder;
+ (Name_Builder*) builderWithPrototype:(Name*) prototype;

+ (Name*) parseFromData:(NSData*) data;
+ (Name*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (Name*) parseFromInputStream:(NSInputStream*) input;
+ (Name*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (Name*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (Name*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface Name_Builder : PBGeneratedMessage_Builder {
@private
  Name* result;
}

- (Name*) defaultInstance;

- (Name_Builder*) clear;
- (Name_Builder*) clone;

- (Name*) build;
- (Name*) buildPartial;

- (Name_Builder*) mergeFrom:(Name*) other;
- (Name_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (Name_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasFamilyName;
- (NSString*) familyName;
- (Name_Builder*) setFamilyName:(NSString*) value;
- (Name_Builder*) clearFamilyName;

- (BOOL) hasGivenName;
- (NSString*) givenName;
- (Name_Builder*) setGivenName:(NSString*) value;
- (Name_Builder*) clearGivenName;

- (BOOL) hasNickName;
- (NSString*) nickName;
- (Name_Builder*) setNickName:(NSString*) value;
- (Name_Builder*) clearNickName;
@end

@interface Phone : PBGeneratedMessage {
@private
  BOOL hasPhoneValue_:1;
  BOOL hasCategory_:1;
  NSString* phoneValue;
  Category* category;
}
- (BOOL) hasCategory;
- (BOOL) hasPhoneValue;
@property (readonly, retain) Category* category;
@property (readonly, retain) NSString* phoneValue;

+ (Phone*) defaultInstance;
- (Phone*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (Phone_Builder*) builder;
+ (Phone_Builder*) builder;
+ (Phone_Builder*) builderWithPrototype:(Phone*) prototype;

+ (Phone*) parseFromData:(NSData*) data;
+ (Phone*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (Phone*) parseFromInputStream:(NSInputStream*) input;
+ (Phone*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (Phone*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (Phone*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface Phone_Builder : PBGeneratedMessage_Builder {
@private
  Phone* result;
}

- (Phone*) defaultInstance;

- (Phone_Builder*) clear;
- (Phone_Builder*) clone;

- (Phone*) build;
- (Phone*) buildPartial;

- (Phone_Builder*) mergeFrom:(Phone*) other;
- (Phone_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (Phone_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasCategory;
- (Category*) category;
- (Phone_Builder*) setCategory:(Category*) value;
- (Phone_Builder*) setCategoryBuilder:(Category_Builder*) builderForValue;
- (Phone_Builder*) mergeCategory:(Category*) value;
- (Phone_Builder*) clearCategory;

- (BOOL) hasPhoneValue;
- (NSString*) phoneValue;
- (Phone_Builder*) setPhoneValue:(NSString*) value;
- (Phone_Builder*) clearPhoneValue;
@end

@interface Website : PBGeneratedMessage {
@private
  BOOL hasPageValue_:1;
  BOOL hasCategory_:1;
  NSString* pageValue;
  Category* category;
}
- (BOOL) hasCategory;
- (BOOL) hasPageValue;
@property (readonly, retain) Category* category;
@property (readonly, retain) NSString* pageValue;

+ (Website*) defaultInstance;
- (Website*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (Website_Builder*) builder;
+ (Website_Builder*) builder;
+ (Website_Builder*) builderWithPrototype:(Website*) prototype;

+ (Website*) parseFromData:(NSData*) data;
+ (Website*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (Website*) parseFromInputStream:(NSInputStream*) input;
+ (Website*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (Website*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (Website*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface Website_Builder : PBGeneratedMessage_Builder {
@private
  Website* result;
}

- (Website*) defaultInstance;

- (Website_Builder*) clear;
- (Website_Builder*) clone;

- (Website*) build;
- (Website*) buildPartial;

- (Website_Builder*) mergeFrom:(Website*) other;
- (Website_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (Website_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasCategory;
- (Category*) category;
- (Website_Builder*) setCategory:(Category*) value;
- (Website_Builder*) setCategoryBuilder:(Category_Builder*) builderForValue;
- (Website_Builder*) mergeCategory:(Category*) value;
- (Website_Builder*) clearCategory;

- (BOOL) hasPageValue;
- (NSString*) pageValue;
- (Website_Builder*) setPageValue:(NSString*) value;
- (Website_Builder*) clearPageValue;
@end

@interface PortraitData : PBGeneratedMessage {
@private
  BOOL hasSid_:1;
  BOOL hasImageData_:1;
  BOOL hasImageType_:1;
  int32_t sid;
  NSData* imageData;
  ImageType imageType;
}
- (BOOL) hasSid;
- (BOOL) hasImageType;
- (BOOL) hasImageData;
@property (readonly) int32_t sid;
@property (readonly) ImageType imageType;
@property (readonly, retain) NSData* imageData;

+ (PortraitData*) defaultInstance;
- (PortraitData*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (PortraitData_Builder*) builder;
+ (PortraitData_Builder*) builder;
+ (PortraitData_Builder*) builderWithPrototype:(PortraitData*) prototype;

+ (PortraitData*) parseFromData:(NSData*) data;
+ (PortraitData*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (PortraitData*) parseFromInputStream:(NSInputStream*) input;
+ (PortraitData*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (PortraitData*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (PortraitData*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface PortraitData_Builder : PBGeneratedMessage_Builder {
@private
  PortraitData* result;
}

- (PortraitData*) defaultInstance;

- (PortraitData_Builder*) clear;
- (PortraitData_Builder*) clone;

- (PortraitData*) build;
- (PortraitData*) buildPartial;

- (PortraitData_Builder*) mergeFrom:(PortraitData*) other;
- (PortraitData_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (PortraitData_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasSid;
- (int32_t) sid;
- (PortraitData_Builder*) setSid:(int32_t) value;
- (PortraitData_Builder*) clearSid;

- (BOOL) hasImageType;
- (ImageType) imageType;
- (PortraitData_Builder*) setImageType:(ImageType) value;
- (PortraitData_Builder*) clearImageType;

- (BOOL) hasImageData;
- (NSData*) imageData;
- (PortraitData_Builder*) setImageData:(NSData*) value;
- (PortraitData_Builder*) clearImageData;
@end

@interface UabError : PBGeneratedMessage {
@private
  BOOL hasCode_:1;
  BOOL hasDescription_:1;
  int32_t code;
  NSString* description;
}
- (BOOL) hasCode;
- (BOOL) hasDescription;
@property (readonly) int32_t code;
@property (readonly, retain) NSString* description;

+ (UabError*) defaultInstance;
- (UabError*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (UabError_Builder*) builder;
+ (UabError_Builder*) builder;
+ (UabError_Builder*) builderWithPrototype:(UabError*) prototype;

+ (UabError*) parseFromData:(NSData*) data;
+ (UabError*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (UabError*) parseFromInputStream:(NSInputStream*) input;
+ (UabError*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (UabError*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (UabError*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface UabError_Builder : PBGeneratedMessage_Builder {
@private
  UabError* result;
}

- (UabError*) defaultInstance;

- (UabError_Builder*) clear;
- (UabError_Builder*) clone;

- (UabError*) build;
- (UabError*) buildPartial;

- (UabError_Builder*) mergeFrom:(UabError*) other;
- (UabError_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (UabError_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasCode;
- (int32_t) code;
- (UabError_Builder*) setCode:(int32_t) value;
- (UabError_Builder*) clearCode;

- (BOOL) hasDescription;
- (NSString*) description;
- (UabError_Builder*) setDescription:(NSString*) value;
- (UabError_Builder*) clearDescription;
@end

@interface Sms : PBGeneratedMessage {
@private
  BOOL hasIsLocked_:1;
  BOOL hasIsRead_:1;
  BOOL hasIsSendSuccess_:1;
  BOOL hasMode_:1;
  BOOL hasId_:1;
  BOOL hasSenderNumber_:1;
  BOOL hasReceiveTime_:1;
  BOOL hasContent_:1;
  BOOL hasCustomData_:1;
  BOOL hasType_:1;
  BOOL hasSendType_:1;
  BOOL isLocked_:1;
  BOOL isRead_:1;
  BOOL isSendSuccess_:1;
  int32_t mode;
  NSString* id;
  NSString* senderNumber;
  NSString* receiveTime;
  NSString* content;
  NSData* customData;
  SmsType type;
  SmsSendType sendType;
}
- (BOOL) hasId;
- (BOOL) hasType;
- (BOOL) hasSendType;
- (BOOL) hasSenderNumber;
- (BOOL) hasReceiveTime;
- (BOOL) hasIsLocked;
- (BOOL) hasIsRead;
- (BOOL) hasContent;
- (BOOL) hasIsSendSuccess;
- (BOOL) hasMode;
- (BOOL) hasCustomData;
@property (readonly, retain) NSString* id;
@property (readonly) SmsType type;
@property (readonly) SmsSendType sendType;
@property (readonly, retain) NSString* senderNumber;
@property (readonly, retain) NSString* receiveTime;
- (BOOL) isLocked;
- (BOOL) isRead;
@property (readonly, retain) NSString* content;
- (BOOL) isSendSuccess;
@property (readonly) int32_t mode;
@property (readonly, retain) NSData* customData;

+ (Sms*) defaultInstance;
- (Sms*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (Sms_Builder*) builder;
+ (Sms_Builder*) builder;
+ (Sms_Builder*) builderWithPrototype:(Sms*) prototype;

+ (Sms*) parseFromData:(NSData*) data;
+ (Sms*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (Sms*) parseFromInputStream:(NSInputStream*) input;
+ (Sms*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (Sms*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (Sms*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface Sms_Builder : PBGeneratedMessage_Builder {
@private
  Sms* result;
}

- (Sms*) defaultInstance;

- (Sms_Builder*) clear;
- (Sms_Builder*) clone;

- (Sms*) build;
- (Sms*) buildPartial;

- (Sms_Builder*) mergeFrom:(Sms*) other;
- (Sms_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (Sms_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasId;
- (NSString*) id;
- (Sms_Builder*) setId:(NSString*) value;
- (Sms_Builder*) clearId;

- (BOOL) hasType;
- (SmsType) type;
- (Sms_Builder*) setType:(SmsType) value;
- (Sms_Builder*) clearType;

- (BOOL) hasSendType;
- (SmsSendType) sendType;
- (Sms_Builder*) setSendType:(SmsSendType) value;
- (Sms_Builder*) clearSendType;

- (BOOL) hasSenderNumber;
- (NSString*) senderNumber;
- (Sms_Builder*) setSenderNumber:(NSString*) value;
- (Sms_Builder*) clearSenderNumber;

- (BOOL) hasReceiveTime;
- (NSString*) receiveTime;
- (Sms_Builder*) setReceiveTime:(NSString*) value;
- (Sms_Builder*) clearReceiveTime;

- (BOOL) hasIsLocked;
- (BOOL) isLocked;
- (Sms_Builder*) setIsLocked:(BOOL) value;
- (Sms_Builder*) clearIsLocked;

- (BOOL) hasIsRead;
- (BOOL) isRead;
- (Sms_Builder*) setIsRead:(BOOL) value;
- (Sms_Builder*) clearIsRead;

- (BOOL) hasContent;
- (NSString*) content;
- (Sms_Builder*) setContent:(NSString*) value;
- (Sms_Builder*) clearContent;

- (BOOL) hasIsSendSuccess;
- (BOOL) isSendSuccess;
- (Sms_Builder*) setIsSendSuccess:(BOOL) value;
- (Sms_Builder*) clearIsSendSuccess;

- (BOOL) hasMode;
- (int32_t) mode;
- (Sms_Builder*) setMode:(int32_t) value;
- (Sms_Builder*) clearMode;

- (BOOL) hasCustomData;
- (NSData*) customData;
- (Sms_Builder*) setCustomData:(NSData*) value;
- (Sms_Builder*) clearCustomData;
@end

@interface SmsSummary : PBGeneratedMessage {
@private
  BOOL hasIsFavourite_:1;
  BOOL hasId_:1;
  BOOL isFavourite_:1;
  NSString* id;
}
- (BOOL) hasId;
- (BOOL) hasIsFavourite;
@property (readonly, retain) NSString* id;
- (BOOL) isFavourite;

+ (SmsSummary*) defaultInstance;
- (SmsSummary*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (SmsSummary_Builder*) builder;
+ (SmsSummary_Builder*) builder;
+ (SmsSummary_Builder*) builderWithPrototype:(SmsSummary*) prototype;

+ (SmsSummary*) parseFromData:(NSData*) data;
+ (SmsSummary*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (SmsSummary*) parseFromInputStream:(NSInputStream*) input;
+ (SmsSummary*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (SmsSummary*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (SmsSummary*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface SmsSummary_Builder : PBGeneratedMessage_Builder {
@private
  SmsSummary* result;
}

- (SmsSummary*) defaultInstance;

- (SmsSummary_Builder*) clear;
- (SmsSummary_Builder*) clone;

- (SmsSummary*) build;
- (SmsSummary*) buildPartial;

- (SmsSummary_Builder*) mergeFrom:(SmsSummary*) other;
- (SmsSummary_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (SmsSummary_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasId;
- (NSString*) id;
- (SmsSummary_Builder*) setId:(NSString*) value;
- (SmsSummary_Builder*) clearId;

- (BOOL) hasIsFavourite;
- (BOOL) isFavourite;
- (SmsSummary_Builder*) setIsFavourite:(BOOL) value;
- (SmsSummary_Builder*) clearIsFavourite;
@end

