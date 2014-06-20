//
//  AppDelegate.swift
//  WeStep
//
//  Created by sunyazhou on 14-6-19.
//  Copyright (c) 2014年 哈尔滨工程大学 技术研究部. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate ,MSDynamicsDrawerViewControllerDelegate{
                            
    var window: UIWindow?

    //声明框架
    var dynamicsDrawerViewController: MSDynamicsDrawerViewController?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        // Override point for customization after application launch.
        self.window!.backgroundColor = UIColor.whiteColor()
        
        //初始化框架
        self.dynamicsDrawerViewController = MSDynamicsDrawerViewController()
        //设置代理
//        self.dynamicsDrawerViewController!.delegate = self
        //左边控制器样式, 添加：缩放、 渐变、视差、暗影、动态大小 等样式
        let stylers = [MSDynamicsDrawerScaleStyler.styler(),MSDynamicsDrawerFadeStyler.styler(),MSDynamicsDrawerParallaxStyler.styler(),MSDynamicsDrawerShadowStyler.styler(),MSDynamicsDrawerResizeStyler.styler()]
        /*
         *此处可能桥接 不好用 swift里面调用OC的类似乎没起作用 WeStep-Bridging-Header.h桥接文件
        */
        self.dynamicsDrawerViewController!.addStylersFromArray(stylers, forDirection: MSDynamicsDrawerDirection.MSDynamicsDrawerDirectionLeft)
        
        
        
        self.window!.rootViewController = self.dynamicsDrawerViewController
        
        self.window!.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

