//
//  UIViewExtensions.swift
//  Photoshare
//
//  Created by 吕凌晟 on 16/3/5.
//  Copyright © 2016年 Lingsheng Lyu. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    // MARK: - Frame
    
    /**
    Redefines the height of the view
    
    :param: height The new value for the view's height
    */
    func setHeight(height: CGFloat) {
        
        var frame: CGRect = self.frame
        frame.size.height = height
        
        self.frame = frame
    }
    
    /**
     Redefines the width of the view
     
     :param: width The new value for the view's width
     */
    func setWidth(width: CGFloat) {
        
        var frame: CGRect = self.frame
        frame.size.width = width
        
        self.frame = frame
    }
    
    /**
     Redefines X position of the view
     
     :param: x The new x-coordinate of the view's origin point
     */
    func setX(x: CGFloat) {
        
        var frame: CGRect = self.frame
        frame.origin.x = x
        
        self.frame = frame
    }
    
    /**
     Redefines Y position of the view
     
     :param: y The new y-coordinate of the view's origin point
     */
    func setY(y: CGFloat) {
        
        var frame: CGRect = self.frame
        frame.origin.y = y
        
        self.frame = frame
    }
}