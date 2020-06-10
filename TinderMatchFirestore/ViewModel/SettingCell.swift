//
//  SettingCell.swift
//  TinderMatchFirestore
//
//  Created by Vishal Lakshminarayanappa on 6/2/20.
//  Copyright © 2020 Vishal Lakshminarayanappa. All rights reserved.
//

import UIKit

class SettingCell: UITableViewCell{
    
    //MARK: Properties
    
    let textField : SettingTextField = {
        let tf = SettingTextField()
        tf.placeholder = "Enter Text"
        return tf
    }()
    
    //MARK: Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(textField)
        textField.addConstraintsToFillView(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Selector
    
    //MARK: Helper Function

}


class SettingTextField: UITextField {
    
   
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        
        return bounds.insetBy(dx: 24, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 24, dy: 0)
    }
    
    override var intrinsicContentSize: CGSize{
        return .init(width: 0, height: 44)
    }
}
