//
//  MaterialCard.swift
//  MovieTime
//
//  Created by Brandon Sanchez on 2/5/17.
//  Copyright © 2017 Brandon Sanchez. All rights reserved.
//

import Foundation
import UIKit
/*
 Material Card UIView
 :- created to prevent issues with configuring cell at runtime
*/
public class MaterialCard: UIView {
    
    open var cornerRadius: CGFloat = 4
    
    open var shadowOffsetWidth: Int = 0
    open var shadowOffsetHeight: Int = 2
    open var shadowColor: UIColor? = UIColor.black
    open var shadowOpacity: Float = 0.6
    
    override open func layoutSubviews() {
        
        layer.cornerRadius = cornerRadius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        
        layer.masksToBounds = false
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight)
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
        
        //addPulse()
        
    }
    
    func addPulse() {
    let pulseAnimation = CABasicAnimation(keyPath: "backgroundColor")
    pulseAnimation.duration = 1
    pulseAnimation.fromValue = UIColor.blue.cgColor
    pulseAnimation.toValue = UIColor.white.cgColor
    pulseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    pulseAnimation.autoreverses = false
    pulseAnimation.repeatCount = 0
    self.layer.add(pulseAnimation, forKey: nil)
    }
    
}

public class MaterialWebView: UIWebView {
    open var cornerRadius: CGFloat = 4
    
    open var shadowOffsetWidth: Int = 0
    open var shadowOffsetHeight: Int = 2
    open var shadowColor: UIColor? = UIColor.black
    open var shadowOpacity: Float = 0.6
    
    override open func layoutSubviews() {
        
        layer.cornerRadius = cornerRadius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        
        for subview in self.subviews {
            subview.layer.cornerRadius = cornerRadius
        }
        layer.masksToBounds = false
        //self.clipsToBounds = true
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight)
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
    }
}
