//
//  MessageNavBar.swift
//  TinderMatchFirestore
//
//  Created by Vishal Lakshminarayanappa on 6/5/20.
//  Copyright © 2020 Vishal Lakshminarayanappa. All rights reserved.
//

import UIKit
import LBTATools

class MessageNavBar: UIView{
    
    let userProfileImageView = CircularImageView(width: 44, image: #imageLiteral(resourceName: "lady5c"))
    let usernameLabel = UILabel(text: "Kelly", font: .systemFont(ofSize: 16))
    let backButton = UIButton(image: #imageLiteral(resourceName: "back").withRenderingMode(.alwaysOriginal))
    let flagButton = UIButton(image: #imageLiteral(resourceName: "flag").withRenderingMode(.alwaysOriginal))
    
    var match : Match
    
    
    init(match : Match) {
        self.match = match
        usernameLabel.text = match.name
        userProfileImageView.sd_setImage(with: URL(string: match.profileImageUrl), completed: nil)
        
        super.init(frame: .zero)
        
        backgroundColor = .white
        setupShadow(opacity: 0.2, radius: 8, offset: .init(width: 0, height: 10), color: .init(white: 0, alpha: 0.3))
        let middleStack = hstack(stack(userProfileImageView, usernameLabel,spacing : 8 ,alignment:.center),alignment : .center)
        
        hstack(backButton,middleStack,flagButton).withMargins(.init(top: 0, left: 12, bottom: 0, right: 12))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

