//
//  AppDelegate.swift
//  weStepSample
//
//  Created by 王浩 on 14-6-26.
//  Copyright (c) 2014年 王浩. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?
    
    var navigationController: UINavigationController?
    
    var mapManager: BMKMapManager?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
        
        //StatusBar相关
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .Slide)
        UIApplication.sharedApplication().setStatusBarStyle(.BlackOpaque, animated: false)
        
        self.window!.backgroundColor = UIColor.blackColor()

        //百度地图初始化
        self.mapManager = BMKMapManager()
        var ret: Bool = mapManager!.start("MZeSSDoMneNuLXanAjZ1KXEV", generalDelegate: nil)
        if !ret {
            println("manager start failed!")
        }
        


        //AFNetwork demo code
        let manager = AFHTTPRequestOperationManager()
        
        //fixed Request failed: unacceptable content-type: text/html Error
        manager.responseSerializer.acceptableContentTypes = manager.responseSerializer.acceptableContentTypes.setByAddingObject("text/html")
        let url = "http://www.weather.com.cn/data/sk/101110101.html"
        manager.GET(url,
            parameters:nil,
//            success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
//                println("JSON: " + responseObject.description!)
//            },
            success: {
                println("\($1)")
            },
            failure: {
                println($1.localizedDescription)
            }
        )
        
        return true
    }

}

