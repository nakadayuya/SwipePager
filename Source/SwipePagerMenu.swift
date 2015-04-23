//
//  SwipePagerMenu.swift
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

class SwipePagerMenu: UIView {
    
    // MARK: - Property
    
    var title: String?
    var font: UIFont?
    var stateNormalColor: UIColor?
    var stateNormalFontColor: UIColor?
    var stateHighlightColor: UIColor?
    var stateHighlightFontColor: UIColor?
    
    override var frame: CGRect {
        didSet {
            self.titelLabel.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))
        }
    }
    
    private var titelLabel: UILabel = UILabel()
    
    // MARK: - LifeCycle
    
    override init() {
        super.init(frame: CGRectZero)
        self.titelLabel = UILabel()
        self.titelLabel.backgroundColor = UIColor.clearColor()
        self.titelLabel.textAlignment = .Center
        self.addSubview(self.titelLabel)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    
    func config() {
        if let title = self.title {
            self.titelLabel.text = title
        }
        
        if let font = self.font {
            self.titelLabel.font = font
        }
        
        self.stateNormal()
    }
    
    func stateNormal() {
        if let color = self.stateNormalColor {
            self.backgroundColor = color
        }
        
        if let color = self.stateNormalFontColor {
            self.titelLabel.textColor = color
        }
    }
    
    func stateHighlight() {
        if let color = self.stateHighlightColor {
            self.backgroundColor = color
        }
        
        if let color = self.stateHighlightFontColor {
            self.titelLabel.textColor = color
        }
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
