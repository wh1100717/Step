//
//  AboutController.swift
//  weStepSample
//
//  Created by 王浩 on 14-7-2.
//  Copyright (c) 2014年 王浩. All rights reserved.
//

import Foundation

class AboutController: UIViewController {
    
    @IBOutlet var slideShow: DRDynamicSlideShow

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view0 = viewGenerator(NSDate.date())
        let view1 = viewGenerator(NSDate.dateYesterday())
        let view2 = viewGenerator(NSDate.dateTomorrow())
        
        slideShow.addSubview(view0, onPage: 0)
        slideShow.addSubview(view1, onPage: 1)
        slideShow.addSubview(view2, onPage: 2)
        
        slideShow.addAnimation(
            DRDynamicSlideShowAnimation.animationForSubview(
                view0,
                page: 1,
                keyPath: "alpha",
                toValue: 1,
                delay: 0
            ) as DRDynamicSlideShowAnimation
        )
        slideShow.addAnimation(
            DRDynamicSlideShowAnimation.animationForSubview(
                view1,
                page: 2,
                keyPath: "alpha",
                toValue: 1,
                delay: 0
                ) as DRDynamicSlideShowAnimation
        )
        slideShow.addAnimation(
            DRDynamicSlideShowAnimation.animationForSubview(
                view2,
                page: 0,
                keyPath: "alpha",
                toValue: 1,
                delay: 0
                ) as DRDynamicSlideShowAnimation
        )
    }
    
    func viewGenerator(date: NSDate) -> UIView {
        let viewG = UIView(frame: CGRect(x: 0,y: 0,width: slideShow.frame.size.width, height: slideShow.frame.size.height))
        let dateLabel = UILabel(frame: CGRect(x: 0,y: self.view.bounds.size.height*0.1,width:self.view.bounds.size.width,height:self.view.bounds.size.height*0.2))
        dateLabel.textAlignment = .Center
        dateLabel.text = getFormatDate(date)
        dateLabel.textColor = UIColor.whiteColor()
        dateLabel.font = UIFont(name: "Helvetica", size: 24)
        
        viewG.addSubview(dateLabel)
        viewG.backgroundColor = UIColor.blackColor()
        
        
        return viewG
    }
    
    func getFormatDate(date: NSDate) -> String {
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