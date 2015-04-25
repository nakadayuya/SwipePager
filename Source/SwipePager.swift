//
//  SwipePager.swift
//
//  The MIT License (MIT)
//
//  Copyright (c) 2015 naoto yamaguchi
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import UIKit

protocol SwipePagerDataSource {
    func sizeForMenu(#swipePager: SwipePager) -> CGSize
    func menuViews(#swipePager: SwipePager) -> [SwipePagerMenu]
    func viewControllers(#swipePager: SwipePager) -> [UIViewController]
}

protocol SwipePagerDelegate {
    func swipePager(#swipePager: SwipePager, didMoveToPage page: Int)
}

public class SwipePager: UIView, UIPageViewControllerDataSource,
                                 UIPageViewControllerDelegate {
    
    // MARK: - Property
    
    var dataSource: SwipePagerDataSource?
    var delegate: SwipePagerDelegate?
    var transitionStyle: UIPageViewControllerTransitionStyle!
    var currentPage: Int = 0
    
    private var menuScrollView: UIScrollView = UIScrollView()
    private var menuViewArray: [SwipePagerMenu] = []
    private var menuSize: CGSize = CGSizeZero
    private var currentIndex: Int = 0
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
        self.settingCurrentPage()
        self.menuScrollViewReloadData()
        self.pageViewControllerReloadData()
    }
    
    // MARK: - Private
    
    private func initializeView() {
        
        self.menuScrollView = UIScrollView()
        self.menuScrollView.showsHorizontalScrollIndicator = true
        self.addSubview(self.menuScrollView)
        
        self.pageViewController = UIPageViewController()
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
    
    private func menuScrollViewReloadData() {
        if let menuSize = self.dataSource?.sizeForMenu(swipePager: self) {
            self.menuSize = menuSize
        }
        
        self.menuScrollView.frame = CGRectMake(
            0,
            0,
            CGRectGetWidth(self.frame),
            self.menuSize.height
        )
        
        self.layoutMenuScrollView(currentPage: self.currentPage)
    }
    
    private func layoutMenuScrollView(#currentPage: Int) {
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
        
        self.moveMenuScrollViewToCurrentIndex(currentPage)
    }
    
    private func pageViewControllerReloadData() {
        
        self.pageViewController.view.frame = CGRectMake(
            0,
            self.menuSize.height,
            CGRectGetWidth(self.frame),
            CGRectGetHeight(self.frame) - CGRectGetMinY(self.frame) - self.menuSize.height
        )
        
        if let viewControllerArray = self.dataSource?.viewControllers(swipePager: self) {
            self.viewControllers = viewControllerArray
            
            if self.viewControllers.count > 0 {
                self.pageViewController.setViewControllers(
                    [self.viewControllers[self.currentPage]],
                    direction: .Forward,
                    animated: true,
                    completion: nil
                )
            }
        }
    }
    
    func didTapMenu(gesture: UITapGestureRecognizer) {
        weak var weakSelf = self
        
        if let index = gesture.view?.tag {
            var direction: UIPageViewControllerNavigationDirection?
            
            if self.currentIndex > index {
                direction = .Reverse
            }
            else if self.currentIndex < index {
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
            
            self.currentIndex = index
            self.moveMenuScrollViewToCurrentIndex(index)
        }
    }
    
    private func moveMenuScrollViewToCurrentIndex(index: Int) {
        let frame = CGRectMake(
            CGFloat(index) * self.menuSize.width + self.menuSize.width / 2 - (CGRectGetWidth(self.frame) / 2), // TODO: 確認
            0,
            CGRectGetWidth(self.menuScrollView.frame),
            CGRectGetHeight(self.menuScrollView.frame)
        )
        self.menuScrollView.scrollRectToVisible(frame, animated: true)
        self.menuHighlight(index: index)
    }
    
    private func indexOfViewController(viewController: UIViewController) -> Int {
        for var i = 0; i < self.viewControllers.count; i++ {
            if viewController == self.viewControllers[i] {
                return i
            }
        }
        return NSNotFound
    }
    
    private func menuHighlight(#index: Int) {
        for var i = 0; i < self.menuViewArray.count; i++ {
            let menu = self.menuViewArray[i] as SwipePagerMenu
            menu.stateNormal()
            
            if i == index {
                menu.stateHighlight()
            }
        }
    }
    
    private func settingCurrentPage() {
        var correct = true
        
        if self.currentPage >= self.dataSource?.menuViews(swipePager: self).count {
            correct = false
        }
        
        if self.currentPage >= self.dataSource?.viewControllers(swipePager: self).count {
            correct = false
        }
        
        if correct == false {
            self.currentPage = 0
        }
    }
    
    private func didMoveToPage() {
        self.delegate?.swipePager(swipePager: self, didMoveToPage: self.currentIndex)
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
                self.currentIndex = self.indexOfViewController(viewController)
            }
    }
    
    public func pageViewController(
        pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [AnyObject],
        transitionCompleted completed: Bool) {
            if completed == true {
                self.moveMenuScrollViewToCurrentIndex(self.currentIndex)
                self.didMoveToPage()
            }
    }
    
}
