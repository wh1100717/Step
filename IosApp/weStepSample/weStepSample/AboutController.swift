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
        let view0 = UIView(frame: CGRect(x: 0,y: 0,width: slideShow.frame.size.width, height: slideShow.frame.size.height))
        let view1 = UIView(frame: CGRect(x: 0,y: 0,width: slideShow.frame.size.width, height: slideShow.frame.size.height))
        let view2 = UIView(frame: CGRect(x: 0,y: 0,width: slideShow.frame.size.width, height: slideShow.frame.size.height))
        view0.backgroundColor = UIColor.yellowColor()
        view1.backgroundColor = UIColor.redColor()
        view2.backgroundColor = UIColor.blackColor()
        
        slideShow.addSubview(view0, onPage: 0)
        slideShow.addSubview(view1, onPage: 1)
        slideShow.addSubview(view2, onPage: 2)
        
        slideShow.addAnimation(
            DRDynamicSlideShowAnimation.animationForSubview(
                view0,
                page: 0,
                keyPath: "alpha",
                toValue: 1,
                delay: 0
            ) as DRDynamicSlideShowAnimation
        )
        slideShow.addAnimation(
            DRDynamicSlideShowAnimation.animationForSubview(
                view1,
                page: 1,
                keyPath: "alpha",
                toValue: 1,
                delay: 0
                ) as DRDynamicSlideShowAnimation
        )
        slideShow.addAnimation(
            DRDynamicSlideShowAnimation.animationForSubview(
                view2,
                page: 2,
                keyPath: "alpha",
                toValue: 1,
                delay: 0
                ) as DRDynamicSlideShowAnimation
        )
    }
}