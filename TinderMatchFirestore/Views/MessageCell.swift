//
//  MessageCell.swift
//  TinderMatchFirestore
//
//  Created by Vishal Lakshminarayanappa on 6/6/20.
//  Copyright © 2020 Vishal Lakshminarayanappa. All rights reserved.
//

import UIKit
import LBTATools



class MessageCell: LBTAListCell<Message> {
    
    let textView  :  UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .clear
        tv.font = UIFont.systemFont(ofSize: 20)
        tv.isScrollEnabled = false
        tv.isEditable = false
        return tv
    }()
    
    let bubbleContainerView = UIView(backgroundColor: .lightGray)
    

    override var item: Message!{
        didSet{
            textView.text = item.text
            
            if item.IsMessageFromCurrentUser{
                anchorConstraint.leading?.isActive = false
                anchorConstraint.trailing?.isActive = true
                bubbleContainerView.backgroundColor = #colorLiteral(red: 0, green: 0.6267049909, blue: 1, alpha: 1)
                textView.textColor = .white
                
            }else{
                anchorConstraint.leading?.isActive = true
                anchorConstraint.trailing?.isActive = false
                bubbleContainerView.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                textView.textColor = .black
            }
        }
    }
    
    var anchorConstraint : AnchoredConstraints!
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(bubbleContainerView)
        bubbleContainerView.layer.cornerRadius = 12
        
         anchorConstraint = bubbleContainerView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        anchorConstraint.leading?.constant = 20
        anchorConstraint.trailing?.constant = -20
        

        bubbleContainerView.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        
        
        bubbleContainerView.addSubview(textView)
        textView.fillSuperview(padding: .init(top: 4, left: 12, bottom: 4, right: 12))
    }
}
