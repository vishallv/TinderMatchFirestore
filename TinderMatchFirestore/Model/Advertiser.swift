//
//  Advertiser.swift
//  TinderMatchFirestore
//
//  Created by Vishal Lakshminarayanappa on 5/28/20.
//  Copyright © 2020 Vishal Lakshminarayanappa. All rights reserved.
//

import UIKit

struct Advertiser : ProduceCardViewModel{
    let title : String
    let brandName : String
    let posterPhotoName : String
    
    func toCardViewModel() -> CardViewModel{
        
        let attributedText = NSMutableAttributedString(string: title, attributes: [.foregroundColor : UIColor.white,
                                                                                   .font : UIFont.systemFont(ofSize: 34, weight: .heavy)])
        
        attributedText.append(NSAttributedString(string: "\n \(brandName)", attributes: [.foregroundColor : UIColor.white,
                                                                                         .font : UIFont.systemFont(ofSize: 24, weight: .bold)]))
 
        return CardViewModel(imageNames: [posterPhotoName], attributedText: attributedText, textAlignment: .center,uid: "")
    }
}
