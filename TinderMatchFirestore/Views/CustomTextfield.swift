//
//  CustomTextfield.swift
//  TinderMatchFirestore
//
//  Created by Vishal Lakshminarayanappa on 5/30/20.
//  Copyright © 2020 Vishal Lakshminarayanappa. All rights reserved.
//

import UIKit


class CustomTextField : UITextField{
    
    let padding : CGFloat
    
    init(padding : CGFloat) {
        self.padding = padding
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    
//    override var intrinsicContentSize: CGSize{
//        return .init(width: 0, height: 50)
//    }
 
}
