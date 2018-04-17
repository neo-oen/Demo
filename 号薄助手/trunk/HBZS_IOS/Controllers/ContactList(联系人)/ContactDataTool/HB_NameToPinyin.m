//
//  HB_NameToPinyin.m
//  HBZS_IOS
//
//  Created by 冯强迎 on 2018/2/8.
//

#import "HB_NameToPinyin.h"
#import "PinYin4Objc.h"
static HB_NameToPinyin * _instance = nil;

@implementation HB_NameToPinyin

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone ];
    });
    return _instance;
}

+(instancetype) sharedInstance{
    if (_instance == nil) {
        _instance = [[super alloc]init];
        
    }
    return _instance;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initdata];
    }
    return self;
}

-(id)copyWithZone:(NSZone *)zone{
    return _instance;
}

-(id)mutableCopyWithZone:(NSZone *)zone{
    return _instance;
}

-(void)initdata
{
    self.dic = [NSMutableDictionary dictionaryWithCapacity:0];
    
    NSString * path = [[NSBundle mainBundle] pathForResource:@"百家姓" ofType:@"txt"];
    
    NSString * text = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    NSArray * arr = [text componentsSeparatedByString:@"\n"];
    
    for (NSString * str in arr) {
        NSArray * temparr  = [str componentsSeparatedByString:@" "];
        [_dic setObject:temparr.lastObject forKey:temparr.firstObject];
    }
    
    
}


-(NSString *)nameTopinyin:(NSString *)name
{
    if (name.length<=0) {
        return nil;
    }
    NSMutableString * pinyinstr = [NSMutableString stringWithCapacity:0];
    
    NSString * xin  = nil;;
    NSInteger currentindex = 0;
    if (name.length) {
        xin = [self.dic objectForKey:[name substringToIndex:1]];
        currentindex = 1;
    }
    if (!xin.length&&name.length>=2) {
        xin = [self.dic objectForKey:[name substringToIndex:2]];
        currentindex = 2;
    }
    if (xin.length) {
        [pinyinstr appendString:xin];
    }
    
    
    for (NSInteger i = xin.length; i<name.length; i++) {
        [pinyinstr appendString:[self TopinyinWithcha:[name characterAtIndex:i]]];
    }
    
    return [pinyinstr uppercaseString];
}

-(NSString *)TopinyinWithcha:(unichar)subchar
{
    HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
    [outputFormat setToneType:ToneTypeWithoutTone];
    [outputFormat setVCharType:VCharTypeWithV];
    [outputFormat setCaseType:CaseTypeUppercase];
    
    NSArray * arr =[PinyinHelper toHanyuPinyinStringArrayWithChar:subchar withHanyuPinyinOutputFormat:outputFormat];
//    NSArray * arr = [PinyinHelper toHanyuPinyinStringArrayWithChar:subchar];

    [outputFormat release];
    NSArray * temparr  = [arr sortedArrayUsingSelector:@selector(compare:)];
    
    
    if (arr.count) {
        return temparr.firstObject;
    }
    else
    {
        return [NSString stringWithFormat:@"%c",subchar];
    }
    
}
@end
