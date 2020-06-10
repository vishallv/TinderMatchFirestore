//
//  MachNavView.swift
//  TinderMatchFirestore
//
//  Created by Vishal Lakshminarayanappa on 6/5/20.
//  Copyright © 2020 Vishal Lakshminarayanappa. All rights reserved.
//

import UIKit
import LBTATools


class MachNavView : UIView{
    
    //MARK: Properties
    let backButton = UIButton(image: #imageLiteral(resourceName: "app_icon"), tintColor: .lightGray)
    
    //MARK: Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        let iconImageView = UIImageView(image: #imageLiteral(resourceName: "top_right_messages").withRenderingMode(.alwaysTemplate), contentMode: .scaleAspectFit)
        
        iconImageView.tintColor = #colorLiteral(red: 1, green: 0.3305864632, blue: 0.3505547345, alpha: 1)
        let messageLabel =  UILabel(text: "Messages", font: UIFont.boldSystemFont(ofSize: 20), textColor: #colorLiteral(red: 1, green: 0.3305864632, blue: 0.3505547345, alpha: 1), textAlignment: .center, numberOfLines: 0)
        let feedLabel =  UILabel(text: "Feed", font: UIFont.boldSystemFont(ofSize: 20), textColor: .gray, textAlignment: .center, numberOfLines: 0)
        stack(iconImageView.withHeight(44),hstack(messageLabel,feedLabel,distribution:.fillEqually)).padTop(10)
        
        setupShadow(opacity: 0.2, radius: 8, offset: .init(width: 0, height: 10), color: .init(white: 0, alpha: 0.3))
        
        
        addSubview(backButton)
        backButton.anchor(top: topAnchor,left: leftAnchor,paddingTop: 12,paddingLeft: 12,width: 34,height: 34)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Selector
    
    //MARK: Helper Function

}
