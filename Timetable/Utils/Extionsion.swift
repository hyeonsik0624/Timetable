//
//  Extionsion.swift
//  Timetable
//
//  Created by 진현식 on 3/23/24.
//

import UIKit

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                paddingLeft: CGFloat = 0,
                paddingBottom: CGFloat = 0,
                paddingRight: CGFloat = 0,
                height: CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func setDimension(width: CGFloat, height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        
        widthAnchor.constraint(equalToConstant: width).isActive = true
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    func centerX(withView view: UIView, constant: CGFloat? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let constant = constant {
            centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: constant).isActive = true
            return
        }
        
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func centerY(withView view: UIView, constant: CGFloat? = nil, paddingLeft: CGFloat? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let constant = constant {
            centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant).isActive = true
            return
        }
        
        if let paddingLeft = paddingLeft {
            leftAnchor.constraint(equalTo: view.leftAnchor, constant: paddingLeft).isActive = true
        }
        
        centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1.0)
    }
    
    static let mainBlue = rgb(red: 74, green: 153, blue: 234)
}

extension UIApplication {
    var firstKeyWindow: UIWindow? { // It's available in iOS 15 +
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .filter { $0.activationState == .foregroundActive }
            .first?.keyWindow

    }
}