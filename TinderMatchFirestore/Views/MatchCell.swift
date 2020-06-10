//
//  MatchCell.swift
//  TinderMatchFirestore
//
//  Created by Vishal Lakshminarayanappa on 6/6/20.
//  Copyright © 2020 Vishal Lakshminarayanappa. All rights reserved.
//

import UIKit
import LBTATools

class MatchCell :  LBTAListCell<Match>{
    
    let profileImageView = UIImageView(image: #imageLiteral(resourceName: "lady4c"), contentMode: .scaleAspectFill)
    let usernameLabel = UILabel(text: "Kelly", font: .systemFont(ofSize: 14, weight: .semibold),textColor: .darkGray,textAlignment: .center,
                                numberOfLines: 2)
    
    override var item: Match!{
        didSet{
            usernameLabel.text = item.name
            guard let url = URL(string: item.profileImageUrl) else {return}
            profileImageView.sd_setImage(with: url, completed: nil)
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        profileImageView.clipsToBounds = true
        profileImageView.setDimensions(width: 80, height: 80)
        profileImageView.layer.cornerRadius = 80/2
        stack(stack(profileImageView,alignment: .center),usernameLabel)
        
    }
    
}
