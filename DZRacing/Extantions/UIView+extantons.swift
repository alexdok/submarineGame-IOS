//
//  UIView+extantons.swift
//  DZRacing
//
//  Created by алексей ганзицкий on 18.07.2022.
//

import Foundation
import UIKit


extension UIView {
    func rounded(radius: CGFloat = 15) {
        self.layer.cornerRadius = radius
    }
    
    func addShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 10, height: 10)
        layer.shadowRadius = 5
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
//        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: bounds.width/2).cgPath
        layer.shouldRasterize = true
    }
    
    func addGradient() {
        let gradient = CAGradientLayer()
        
        gradient.colors = [ UIColor.red.cgColor, UIColor.yellow.cgColor, UIColor.blue.cgColor]
        gradient.opacity = 0.6
        
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        gradient.frame = self.bounds
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func addParalaxEffect(amount: Int = 20) {
        let horizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        horizontal.minimumRelativeValue = -amount
        horizontal.maximumRelativeValue = amount
        let vertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        vertical.minimumRelativeValue = -amount
        vertical.maximumRelativeValue = amount
        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontal, vertical]
        addMotionEffect(group)
    }
    
}

