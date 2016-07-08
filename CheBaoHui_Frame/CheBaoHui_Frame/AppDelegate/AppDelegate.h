//
//  AppDelegate.h
//  CheBaoHui_Frame
//
//  Created by Bella on 16/3/14.
//  Copyright © 2016年 huirui.zhouyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;

-(void)startHomePage;

@end

#pragma mark -- 类目ChangeColor修改bar上的颜色
@interface UINavigationController (ChangeColor)

-(void)changeColorWithNavigationControllerInstance:(UINavigationController *)instance;

@end
