//
//  SendMessageButton.swift
//  TinderMatchFirestore
//
//  Created by Vishal Lakshminarayanappa on 6/4/20.
//  Copyright © 2020 Vishal Lakshminarayanappa. All rights reserved.
//

import UIKit

class SendMessageButton: UIButton {
    //MARK: Properties
    
    //MARK: Life Cycle
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let gradientLayer = CAGradientLayer()
        let leftColor = #colorLiteral(red: 1, green: 0.01176470588, blue: 0.4470588235, alpha: 1)
        let rightColor = #colorLiteral(red: 1, green: 0.3921568627, blue: 0.3176470588, alpha: 1)
        gradientLayer.colors = [leftColor.cgColor,rightColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        layer.insertSublayer(gradientLayer, at: 0)
//        layer.addSublayer(gradientLayer)
        layer.cornerRadius = rect.height/2
        clipsToBounds = true
        
        gradientLayer.frame = rect
    }
    //MARK: Selector
    
    //MARK: Helper Function
}
