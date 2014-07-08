//
//  BaseController.swift
//  weStep
//
//  Created by 王浩 on 14-7-3.
//  Copyright (c) 2014年 哈尔滨工程大学 技术研究部. All rights reserved.
//

import Foundation

class BaseController: UIViewController, TTSlidingPagesDataSource, TTSliddingPageDelegate {

    var frameRect: CGRect?
    var slider: TTScrollSlidingPagesController?
    
    override func viewDidLoad(){
        super.viewDidLoad()
        frameRect = CGRect(x: 0,y: 0,width: self.view.bounds.size.width, height: self.view.bounds.size.height)
        self.slider = TTScrollSlidingPagesController()
        self.slider!.titleScrollerInActiveTextColour = UIColor.grayColor()
        self.slider!.titleScrollerBottomEdgeColour = UIColor.darkGrayColor()
        self.slider!.titleScrollerBottomEdgeHeight = 2
        
        if String.bridgeToObjectiveC(UIDevice.currentDevice().systemVersion)().floatValue >= 7 {
            self.slider!.hideStatusBarWhenScrolling = true
        }
    }
    
    func numberOfPagesForSlidingPagesViewController(source: TTScrollSlidingPagesController?) -> CInt {
        return 7
    }
    
    func pageForSlidingPagesViewController(source: TTScrollSlidingPagesController?, atIndex index: CInt) -> TTSlidingPage {
        var viewController: UIViewController
        //这里根据不同的日期生成不同的ViewController
        //暂时简单写一下
        if (index % 2 == 0) {
            viewController = UIViewController()
        } else {
            viewController = UIViewController()
        }
        return TTSlidingPage(contentViewController: viewController)
    }

    func titleForSlidingPagesViewController(source: TTScrollSlidingPagesController, atIndex index: CInt) -> TTSlidingPageTitle {
        return TTSlidingPageTitle(headerText: "Title\(index)")
    }
    
    func didScrollToViewAtIndex(index: Int){
        println("scrolled to view\(index)")
    }

    func viewGenerator(date: NSDate) -> UIView {
        let viewG = UIView(frame: frameRect!)
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