//
//  AppDelegate.h
//  UpDownRefurbishView
//
//  Created by neo on 2017/10/17.
//  Copyright © 2017年 neo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

