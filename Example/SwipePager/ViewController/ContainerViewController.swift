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
    
    var ORIGIN_Y: CGFloat = CGRectGetHeight(UIApplication.sharedApplication().statusBarFrame)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Sample"
        
        if let height = self.navigationController?.navigationBar.frame.height {
            ORIGIN_Y += height
        }
        
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
            if i == 0 { menu.title = "0" }
            if i == 1 { menu.title = "1" }
            if i == 2 { menu.title = "2" }
            if i == 3 { menu.title = "3" }
            if i == 4 { menu.title = "4" }
            if i == 5 { menu.title = "5" }
            if i == 6 { menu.title = "6" }
            if i == 7 { menu.title = "7" }
            array.append(menu)
        }
        
        return array
    }
    
    func viewControllers(#swipePager: SwipePager) -> [UIViewController] {
        var array: [UIViewController] = []
        
        for var i = 0; i < 8; i++ {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let feedViewController = storyBoard.instantiateViewControllerWithIdentifier("FeedViewController") as FeedViewController
            feedViewController.row = i
            array.append(feedViewController)
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
