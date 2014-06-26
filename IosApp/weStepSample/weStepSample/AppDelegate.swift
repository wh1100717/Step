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


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
        let manager = AFHTTPRequestOperationManager()
        let url = "http://api.openweathermap.org/data/2.5/weather"
        manager.GET(url,
            parameters:nil,
//            success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
//                println("JSON: " + responseObject.description!)
//            },
            success: {
                println("JSON: " + $1.description!)
            },
            failure: {
                println($1.localizedDescription)
            }
        )
        
        return true
    }

}

