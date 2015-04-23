//
//  SwipePager.swift
//  SwipePager
//
//  Created by naoto yamaguchi on 2015/04/19.
//  Copyright (c) 2015年 naoto yamaguchi. All rights reserved.
//

import UIKit

protocol SwipePagerDataSource {
    func numberOfPage(#swipePager: SwipePager) -> Int
    func sizeForMenu(#swipePager: SwipePager) -> CGSize
    func menuViews(#swipePager: SwipePager) -> [SwipePagerMenu]
    func viewControllers(#swipePager: SwipePager) -> [UIViewController]
}

protocol SwipePagerDelegate {
    func swipePager(#swipePager: SwipePager, didMoveToPage: Int)
}

public class SwipePager: UIView, UIPageViewControllerDataSource,
                                 UIPageViewControllerDelegate {
    
    // MARK: - Property
    
    var dataSource: SwipePagerDataSource? {
        didSet {
            self.reloadData()
        }
    }
    var delegate: SwipePagerDelegate?
    var transitionStyle: UIPageViewControllerTransitionStyle!
    
    
    private var menuScrollView: UIScrollView = UIScrollView()
    private var menuViewArray: [SwipePagerMenu] = []
    private var menuSize: CGSize = CGSizeZero
    private var currentPage: Int = 0
    private var pageViewController: UIPageViewController = UIPageViewController()
    private var viewControllers: [UIViewController] = []
    
    // MARK: - LifeCycle
    
    init(frame: CGRect, transitionStyle: UIPageViewControllerTransitionStyle) {
        super.init(frame: frame)
        self.transitionStyle = transitionStyle
        self.initializeView()
    }
    
    override init() {
        super.init()
    }

    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    
    func reloadData() {
        if let menuSize = self.dataSource?.sizeForMenu(swipePager: self) {
            self.menuSize = menuSize
        }
        
        let menuHeight = self.menuSize.height
        
        self.menuScrollView.frame = CGRectMake(
            0,
            0,
            CGRectGetWidth(self.frame),
            menuHeight
        )
        
        self.layoutMenuScrollView(currentIndex: 0)
        
        self.pageViewController.view.frame = CGRectMake(
            0,
            menuHeight,
            CGRectGetWidth(self.frame),
            CGRectGetHeight(self.frame) - CGRectGetMinY(self.frame) - menuHeight
        )
        
        if let viewControllerArray = self.dataSource?.viewControllers(swipePager: self) {
            self.viewControllers = viewControllerArray
        }
        
        if self.viewControllers.count > 0 {
            self.pageViewController.setViewControllers(
                [self.viewControllers[0]],
                direction: .Forward,
                animated: true,
                completion: nil
            )
        }
    }
    
    // MARK: - Private
    
    private func initializeView() {
        
        self.menuScrollView = UIScrollView()
        self.menuScrollView.showsHorizontalScrollIndicator = true
        self.addSubview(self.menuScrollView)
        
        self.pageViewController = UIPageViewController(
            transitionStyle: self.transitionStyle,
            navigationOrientation: .Horizontal,
            options: nil
        )
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        
        self.insertSubview(
            self.pageViewController.view,
            belowSubview: self.menuScrollView
        )
    }
    
    private func indexOfViewController(viewController: UIViewController) -> Int {
        for var i = 0; i < self.viewControllers.count; i++ {
            if viewController == self.viewControllers[i] {
                return i
            }
        }
        return NSNotFound
    }
    
    private func layoutMenuScrollView(#currentIndex: Int) {
        var index: Int = 0
        
        if let menuViewArray = self.dataSource?.menuViews(swipePager: self) {
            
            self.menuViewArray = menuViewArray
            
            for view: SwipePagerMenu in menuViewArray {
                view.frame = CGRectMake(
                    self.menuSize.width * CGFloat(index),
                    0,
                    self.menuSize.width,
                    self.menuSize.height
                )
                view.config()
                self.menuHighlight(currentIndex)
                view.tag = index
                view.userInteractionEnabled = true
                let gesture = UITapGestureRecognizer(target: self, action: "didTapMenu:")
                view.addGestureRecognizer(gesture)
                self.menuScrollView.addSubview(view)
                index++
            }
        }
        
        self.menuScrollView.contentSize = CGSizeMake(
            self.menuSize.width * CGFloat(index),
            self.menuSize.height
        )
    }
    
    func didTapMenu(gesture: UITapGestureRecognizer) {
        weak var weakSelf = self
        
        if let index = gesture.view?.tag {
            var direction: UIPageViewControllerNavigationDirection?
            
            if self.currentPage > index {
                direction = .Reverse
            }
            else if self.currentPage < index {
                direction = .Forward
            }
            
            if let validDirection = direction {
                self.pageViewController.setViewControllers(
                    [self.viewControllers[index]],
                    direction: validDirection,
                    animated: true,
                    completion: { (bool) -> Void in
                        if bool {
                            weakSelf?.didMoveToPage()
                        }
                    }
                )
            }
            
            self.currentPage = index
            self.moveMenuScrollViewToCurrentPage(index)
        }
    }
    
    private func moveMenuScrollViewToCurrentPage(index: Int) {
        let frame = CGRectMake(
            CGFloat(index) * self.menuSize.width + self.menuSize.width / 2 - (CGRectGetWidth(self.frame) / 2), // TODO: 確認
            0,
            CGRectGetWidth(self.menuScrollView.frame),
            CGRectGetHeight(self.menuScrollView.frame)
        )
        self.menuScrollView.scrollRectToVisible(frame, animated: true)
        self.menuHighlight(index)
    }
    
    private func didMoveToPage() {
        self.delegate?.swipePager(swipePager: self, didMoveToPage: self.currentPage)
    }
    
    private func menuHighlight(index: Int) {
        for var i = 0; i < self.menuViewArray.count; i++ {
            let menu = self.menuViewArray[i] as SwipePagerMenu
            menu.stateNormal()
            
            if i == index {
                menu.stateHighlight()
            }
        }
    }
    
    // MARK: - UIPageViewControllerDataSource
    
    public func pageViewController(
        pageViewController: UIPageViewController,
        viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
            
            var index: Int = self.indexOfViewController(viewController)
            
            if index == NSNotFound {
                return nil
            }
        
            index--
        
            if (index >= 0) && (index < self.viewControllers.count) {
                return self.viewControllers[index]
            }
            
            return nil
    }
    
    public func pageViewController(
        pageViewController: UIPageViewController,
        viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
            
            var index: Int = self.indexOfViewController(viewController)
            
            if index == NSNotFound {
                return nil
            }
            
            index++
            
            if (index >= 0) && (index < self.viewControllers.count) {
                return self.viewControllers[index]
            }
            
            return nil
    }
    
    // MARK: - UIPageViewControllerDelegate
    
    public func pageViewController(
        pageViewController: UIPageViewController,
        willTransitionToViewControllers pendingViewControllers: [AnyObject]) {
            
            if pendingViewControllers.count > 0 {
                let viewControllers = pendingViewControllers as [UIViewController]
                let viewController = viewControllers[0] as UIViewController
                self.currentPage = self.indexOfViewController(viewController)
            }
    }
    
    public func pageViewController(
        pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [AnyObject],
        transitionCompleted completed: Bool) {
            if completed == true {
                self.moveMenuScrollViewToCurrentPage(self.currentPage)
                self.didMoveToPage()
            }
    }
    
}
