// Generated by the protocol buffer compiler.  DO NOT EDIT!

#import "DeviceTokenReportProto.pb.h"

@implementation DeviceTokenReportProtoRoot
static PBExtensionRegistry* extensionRegistry = nil;
+ (PBExtensionRegistry*) extensionRegistry {
  return extensionRegistry;
}

+ (void) initialize {
  if (self == [DeviceTokenReportProtoRoot class]) {
    PBMutableExtensionRegistry* registry = [PBMutableExtensionRegistry registry];
    [self registerAllExtensions:registry];
    extensionRegistry = [registry retain];
  }
}
+ (void) registerAllExtensions:(PBMutableExtensionRegistry*) registry {
}
@end

@interface DeviceTokenReportRequest ()
@property (retain) NSString* deviceToken;
@property (retain) NSString* mdn;
@property (retain) NSString* mobileType;
@end

@implementation DeviceTokenReportRequest

- (BOOL) hasDeviceToken {
  return !!hasDeviceToken_;
}
- (void) setHasDeviceToken:(BOOL) value {
  hasDeviceToken_ = !!value;
}
@synthesize deviceToken;
- (BOOL) hasMdn {
  return !!hasMdn_;
}
- (void) setHasMdn:(BOOL) value {
  hasMdn_ = !!value;
}
@synthesize mdn;
- (BOOL) hasMobileType {
  return !!hasMobileType_;
}
- (void) setHasMobileType:(BOOL) value {
  hasMobileType_ = !!value;
}
@synthesize mobileType;
- (void) dealloc {
  self.deviceToken = nil;
  self.mdn = nil;
  self.mobileType = nil;
  [super dealloc];
}
- (id) init {
  if ((self = [super init])) {
    self.deviceToken = @"";
    self.mdn = @"";
    self.mobileType = @"";
  }
  return self;
}
static DeviceTokenReportRequest* defaultDeviceTokenReportRequestInstance = nil;
+ (void) initialize {
  if (self == [DeviceTokenReportRequest class]) {
    defaultDeviceTokenReportRequestInstance = [[DeviceTokenReportRequest alloc] init];
  }
}
+ (DeviceTokenReportRequest*) defaultInstance {
  return defaultDeviceTokenReportRequestInstance;
}
- (DeviceTokenReportRequest*) defaultInstance {
  return defaultDeviceTokenReportRequestInstance;
}
- (BOOL) isInitialized {
  if (!self.hasDeviceToken) {
    return NO;
  }
  return YES;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  if (self.hasDeviceToken) {
    [output writeString:1 value:self.deviceToken];
  }
  if (self.hasMdn) {
    [output writeString:2 value:self.mdn];
  }
  if (self.hasMobileType) {
    [output writeString:3 value:self.mobileType];
  }
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) {
    return size;
  }

  size = 0;
  if (self.hasDeviceToken) {
    size += computeStringSize(1, self.deviceToken);
  }
  if (self.hasMdn) {
    size += computeStringSize(2, self.mdn);
  }
  if (self.hasMobileType) {
    size += computeStringSize(3, self.mobileType);
  }
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (DeviceTokenReportRequest*) parseFromData:(NSData*) data {
  return (DeviceTokenReportRequest*)[[[DeviceTokenReportRequest builder] mergeFromData:data] build];
}
+ (DeviceTokenReportRequest*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (DeviceTokenReportRequest*)[[[DeviceTokenReportRequest builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (DeviceTokenReportRequest*) parseFromInputStream:(NSInputStream*) input {
  return (DeviceTokenReportRequest*)[[[DeviceTokenReportRequest builder] mergeFromInputStream:input] build];
}
+ (DeviceTokenReportRequest*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (DeviceTokenReportRequest*)[[[DeviceTokenReportRequest builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (DeviceTokenReportRequest*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (DeviceTokenReportRequest*)[[[DeviceTokenReportRequest builder] mergeFromCodedInputStream:input] build];
}
+ (DeviceTokenReportRequest*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (DeviceTokenReportRequest*)[[[DeviceTokenReportRequest builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (DeviceTokenReportRequest_Builder*) builder {
  return [[[DeviceTokenReportRequest_Builder alloc] init] autorelease];
}
+ (DeviceTokenReportRequest_Builder*) builderWithPrototype:(DeviceTokenReportRequest*) prototype {
  return [[DeviceTokenReportRequest builder] mergeFrom:prototype];
}
- (DeviceTokenReportRequest_Builder*) builder {
  return [DeviceTokenReportRequest builder];
}
@end

@interface DeviceTokenReportRequest_Builder()
@property (retain) DeviceTokenReportRequest* result;
@end

@implementation DeviceTokenReportRequest_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if ((self = [super init])) {
    self.result = [[[DeviceTokenReportRequest alloc] init] autorelease];
  }
  return self;
}
- (PBGeneratedMessage*) internalGetResult {
  return result;
}
- (DeviceTokenReportRequest_Builder*) clear {
  self.result = [[[DeviceTokenReportRequest alloc] init] autorelease];
  return self;
}
- (DeviceTokenReportRequest_Builder*) clone {
  return [DeviceTokenReportRequest builderWithPrototype:result];
}
- (DeviceTokenReportRequest*) defaultInstance {
  return [DeviceTokenReportRequest defaultInstance];
}
- (DeviceTokenReportRequest*) build {
  [self checkInitialized];
  return [self buildPartial];
}
- (DeviceTokenReportRequest*) buildPartial {
  DeviceTokenReportRequest* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (DeviceTokenReportRequest_Builder*) mergeFrom:(DeviceTokenReportRequest*) other {
  if (other == [DeviceTokenReportRequest defaultInstance]) {
    return self;
  }
  if (other.hasDeviceToken) {
    [self setDeviceToken:other.deviceToken];
  }
  if (other.hasMdn) {
    [self setMdn:other.mdn];
  }
  if (other.hasMobileType) {
    [self setMobileType:other.mobileType];
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (DeviceTokenReportRequest_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (DeviceTokenReportRequest_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet builderWithUnknownFields:self.unknownFields];
  while (YES) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
      case 10: {
        [self setDeviceToken:[input readString]];
        break;
      }
      case 18: {
        [self setMdn:[input readString]];
        break;
      }
      case 26: {
        [self setMobileType:[input readString]];
        break;
      }
    }
  }
}
- (BOOL) hasDeviceToken {
  return result.hasDeviceToken;
}
- (NSString*) deviceToken {
  return result.deviceToken;
}
- (DeviceTokenReportRequest_Builder*) setDeviceToken:(NSString*) value {
  result.hasDeviceToken = YES;
  result.deviceToken = value;
  return self;
}
- (DeviceTokenReportRequest_Builder*) clearDeviceToken {
  result.hasDeviceToken = NO;
  result.deviceToken = @"";
  return self;
}
- (BOOL) hasMdn {
  return result.hasMdn;
}
- (NSString*) mdn {
  return result.mdn;
}
- (DeviceTokenReportRequest_Builder*) setMdn:(NSString*) value {
  result.hasMdn = YES;
  result.mdn = value;
  return self;
}
- (DeviceTokenReportRequest_Builder*) clearMdn {
  result.hasMdn = NO;
  result.mdn = @"";
  return self;
}
- (BOOL) hasMobileType {
  return result.hasMobileType;
}
- (NSString*) mobileType {
  return result.mobileType;
}
- (DeviceTokenReportRequest_Builder*) setMobileType:(NSString*) value {
  result.hasMobileType = YES;
  result.mobileType = value;
  return self;
}
- (DeviceTokenReportRequest_Builder*) clearMobileType {
  result.hasMobileType = NO;
  result.mobileType = @"";
  return self;
}
@end

