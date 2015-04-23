//
//  SwipePagerMenu.swift
//  SwipePager
//
//  Created by naoto yamaguchi on 2015/04/23.
//  Copyright (c) 2015年 naoto yamaguchi. All rights reserved.
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
