//
//  BaseController.swift
//  weStep
//
//  Created by 王浩 on 14-7-3.
//  Copyright (c) 2014年 哈尔滨工程大学 技术研究部. All rights reserved.
//

import Foundation

class BaseController: UIViewController {

    override func viewDidLoad(){
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor()
        let slideShow = DRDynamicSlideShow()
        slideShow.addSubview(viewGenerator(NSDate.date()), onPage: 0)
        slideShow.addSubview(viewGenerator(NSDate.dateYesterday()), onPage: 1)
        slideShow.addSubview(viewGenerator(NSDate.dateTomorrow()), onPage: 2)
        self.view.addSubview(slideShow)
        self.view.bringSubviewToFront(slideShow)
    }

    func viewGenerator(date: NSDate) -> UIView {
        let viewG = UIView(frame: CGRect(x: 0,y: 0,width: self.view.bounds.size.width, height: self.view.bounds.size.height))
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