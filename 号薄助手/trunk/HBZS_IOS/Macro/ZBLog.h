//
//  ZBLog.h
//  SD
//
//  Created by Kevin Zhang on 13-8-14.
//  Copyright (c) 2013年 QQ: 461308387. All rights reserved.
//

#ifdef DEBUG

#ifndef ZBLog
#   define ZBLog(fmt, ...) {NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
#endif

#else

#ifndef ZBLog
#   define ZBLog(...)
#endif

#endif
