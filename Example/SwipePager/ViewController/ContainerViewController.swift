//
//  ContainerViewController.swift
//  SwipePager
//
//  Created by naoto yamaguchi on 2015/04/23.
//  Copyright (c) 2015年 naoto yamaguchi. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController, SwipePagerDataSource, SwipePagerDelegate {
    
    // MARK: - Property
    
    var navH: CGFloat = 44.0
    
    var ORIGIN_Y: CGFloat = CGRectGetHeight(UIApplication.sharedApplication().statusBarFrame)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let height = self.navigationController?.navigationBar.frame.height {
            ORIGIN_Y += height
        }
        let statusBarH = UIApplication.sharedApplication().statusBarFrame.height
        let frame = CGRectMake(
            0,
            ORIGIN_Y,
            CGRectGetWidth(self.view.frame),
            CGRectGetHeight(self.view.frame)
        )
        
        let swipePager = SwipePager(frame: frame, transitionStyle: .Scroll)
        swipePager.dataSource = self
        swipePager.delegate = self
        self.view.addSubview(swipePager)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - SwipePagerDataSource
    
    func numberOfPage(#swipePager: SwipePager) -> Int {
        return 8
    }
    
    func sizeForMenu(#swipePager: SwipePager) -> CGSize {
        return CGSizeMake(80, 50)
    }
    
    func menuViews(#swipePager: SwipePager) -> [SwipePagerMenu] {
        var array: [SwipePagerMenu] = []
        
        for var i = 0; i < 8; i++ {
            var menu = SwipePagerMenu()
            menu.stateNormalColor = UIColor.lightGrayColor()
            menu.stateNormalFontColor = UIColor.whiteColor()
            menu.stateHighlightColor = UIColor.blackColor()
            menu.stateHighlightFontColor = UIColor.whiteColor()
            if i == 0 { menu.title = "1番目" }
            if i == 1 { menu.title = "2番目" }
            if i == 2 { menu.title = "3番目" }
            if i == 3 { menu.title = "4番目" }
            if i == 4 { menu.title = "5番目" }
            if i == 5 { menu.title = "6番目" }
            if i == 6 { menu.title = "7番目" }
            if i == 7 { menu.title = "8番目" }
            array.append(menu)
        }
        
        return array
    }
    
    func viewControllers(#swipePager: SwipePager) -> [UIViewController] {
        var array: [UIViewController] = []
        
        for var i = 0; i < 8; i++ {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let feedVC = storyBoard.instantiateViewControllerWithIdentifier("FeedViewController") as FeedViewController
            
            if i == 0 { feedVC.view.backgroundColor = UIColor.whiteColor() }
            if i == 1 { feedVC.view.backgroundColor = UIColor.grayColor() }
            if i == 2 { feedVC.view.backgroundColor = UIColor.redColor() }
            if i == 3 { feedVC.view.backgroundColor = UIColor.greenColor() }
            if i == 4 { feedVC.view.backgroundColor = UIColor.blueColor() }
            if i == 5 { feedVC.view.backgroundColor = UIColor.cyanColor() }
            if i == 6 { feedVC.view.backgroundColor = UIColor.yellowColor() }
            if i == 7 { feedVC.view.backgroundColor = UIColor.magentaColor() }
            
            array.append(feedVC)
        }
        
        return array
    }
    
    // MARK: - SwipePagerDelegate
    
    func swipePager(#swipePager: SwipePager, didMoveToPage: Int) {
        println("move to \(didMoveToPage.description)")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
