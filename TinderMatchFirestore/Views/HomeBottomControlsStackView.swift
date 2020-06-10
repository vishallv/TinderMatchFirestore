//
//  HomeBottomControlsStackView.swift
//  TinderMatchFirestore
//
//  Created by Vishal Lakshminarayanappa on 5/28/20.
//  Copyright © 2020 Vishal Lakshminarayanappa. All rights reserved.
//

import UIKit

class HomeBottomControlsStackView: UIStackView {
    
    //MARK: Properties
    
    static func createButton(image : UIImage) -> UIButton{
        let button = UIButton(type: .system)
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }
    
    let refreshButton = createButton(image: #imageLiteral(resourceName: "refresh_circle"))
    let dislikeButton = createButton(image: #imageLiteral(resourceName: "dismiss_circle"))
    let superLikeButton = createButton(image: #imageLiteral(resourceName: "super_like_circle"))
    let likeButton = createButton(image: #imageLiteral(resourceName: "like_circle"))
    let specialButton = createButton(image: #imageLiteral(resourceName: "boost_circle"))
    
    //MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        distribution = .fillEqually
        
//        let subViews =  [#imageLiteral(resourceName: "refresh_circle"),#imageLiteral(resourceName: "dismiss_circle"),#imageLiteral(resourceName: "super_like_circle"),#imageLiteral(resourceName: "like_circle"),#imageLiteral(resourceName: "boost_circle")].map { (image) -> UIView in
//
//            let button = UIButton(type: .system)
//            button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
//            return button
//
//        }
//        subViews.forEach { (view) in
//            addArrangedSubview(view)
//        }
        
        [refreshButton,dislikeButton,superLikeButton,likeButton,specialButton].forEach { (button) in
            addArrangedSubview(button)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Selector
    
    //MARK: Helper Function
    
}
