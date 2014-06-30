//
//  ViewController.swift
//  weStepSample
//
//  Created by 王浩 on 14-6-26.
//  Copyright (c) 2014年 王浩. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
                            
    @IBOutlet var dateLabel: UILabel
    @IBOutlet var morphingLabel: LTMorphingLabel
    
    var morphingTexts: Array<String>?
    var morphingIndex = 0
    var morphingStyleIndex = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor()
        
//        let mapView = BMKMapView(frame: CGRectMake(0, 0, 1, 1))
//        self.view = mapView

        morphingTexts = ["Design", "Design is not just", "what it looks like", "and feels like.", "Design", "is how it works.", "- Steve Jobs", "Swift", "Objective-C", "iPhone", "iPad", "Mac Mini", "MacBook Pro", "Mac Pro", "老婆", "老婆+女儿", "老婆+女儿+💰🏡🚘"]
        self.morphingLabel.text = morphingTexts![morphingIndex]

        UIComponentsInit()
        
    }

    @IBAction func changeMorphingStyle(sender: AnyObject) {
        switch morphingStyleIndex {
        case 1:
            morphingLabel.morphingMethod = .EvaporateAndFade
            morphingStyleIndex += 1
        case 2:
            morphingLabel.morphingMethod = .FallDownAndFade
            morphingStyleIndex += 1
        default:
            morphingLabel.morphingMethod = .ScaleAndFade
            morphingStyleIndex = 1
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func changeMorphingText(sender: AnyObject) {
        if morphingIndex + 1 >= countElements(morphingTexts!) {
            morphingIndex = 0
        }else {
            morphingIndex += 1
        }
        morphingLabel.text = morphingTexts![morphingIndex]
    }
    
    func UIComponentsInit() {
        self.dateLabel.text = getFormatDate(NSDate.date())
        
    }

    func getFormatDate(date:NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        if date.isThisYear() {
            dateFormatter.dateFormat = "MM月dd日"
        }else {
            dateFormatter.dateFormat = "yyyy年MM月dd日"
        }
        
        var stringDate = dateFormatter.stringFromDate(date)
        
        switch date.weekday {
        case 1:
            stringDate = stringDate + " 星期日"
        case 2:
            stringDate = stringDate + " 星期一"
        case 3:
            stringDate = stringDate + " 星期二"
        case 4:
            stringDate = stringDate + " 星期三"
        case 5:
            stringDate = stringDate + " 星期四"
        case 6:
            stringDate = stringDate + " 星期五"
        case 7:
            stringDate = stringDate + " 星期六"
        default:
            println("r u kidding me? wrong weekday: \(date.weekday)")
        }
        return stringDate
    }

}

