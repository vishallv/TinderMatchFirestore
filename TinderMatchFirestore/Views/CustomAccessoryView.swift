//
//  CustomAccessoryView.swift
//  TinderMatchFirestore
//
//  Created by Vishal Lakshminarayanappa on 6/6/20.
//  Copyright © 2020 Vishal Lakshminarayanappa. All rights reserved.
//

import UIKit

class CustomInputAccessoryView : UIView{
    let textView = UITextView()
    let sendButton =  UIButton(title: "Send", titleColor: .black, font: .boldSystemFont(ofSize: 14), target: nil, action: nil)
    let placeholderLabel = UILabel(text:"Enter Message",textColor: .lightGray)
    
    override var intrinsicContentSize: CGSize{
        return .zero
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        setupShadow(opacity: 0.1, radius: 8, offset: .init(width: 0, height: -8), color: .lightGray)
        autoresizingMask = .flexibleHeight
        
//        textView.text = "Your rText"
        textView.isScrollEnabled = false
        textView.font = .systemFont(ofSize: 16)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextChange), name: UITextView.textDidChangeNotification, object: nil)
        
        sendButton.constrainHeight(50)
        sendButton.constrainWidth(60)
        
        let stackView = UIStackView(arrangedSubviews: [textView,sendButton])
        stackView.alignment = .center
        addSubview(stackView)
        stackView.fillSuperview()
        stackView.isLayoutMarginsRelativeArrangement = true
        
        
        addSubview(placeholderLabel)
        placeholderLabel.anchor(left: leftAnchor,right: sendButton.leftAnchor,paddingLeft: 16)
        placeholderLabel.centerY(inView: sendButton)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func handleTextChange(){
        placeholderLabel.isHidden = textView.text.count != 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

