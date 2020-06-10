//
//  CardViewModel.swift
//  TinderMatchFirestore
//
//  Created by Vishal Lakshminarayanappa on 5/28/20.
//  Copyright © 2020 Vishal Lakshminarayanappa. All rights reserved.
//

import UIKit

protocol ProduceCardViewModel {
    func toCardViewModel() -> CardViewModel
}

class CardViewModel {
    
    let uid : String
    let imageUrls : [String]
    let attributedText : NSAttributedString
    let textAlignment : NSTextAlignment
    
    fileprivate var imageIndex = 0 {
        didSet{
            let imageUrl = imageUrls[imageIndex]
//            let image = UIImage(named: imageName)
            
            imageIndexObserver?(imageIndex,imageUrl)
        }
    }
    
    //Reactive Programming
    var imageIndexObserver : ((Int,String?) -> ())?
    
    
    init(imageNames : [String],attributedText : NSAttributedString,textAlignment : NSTextAlignment,uid: String) {
        self.imageUrls = imageNames
        self.attributedText = attributedText
        self.textAlignment = textAlignment
        self.uid = uid
    }
    
    func advanceToNextPhoto(){
        imageIndex = min (imageIndex + 1,imageUrls.count-1)
    }
    
    func goToPreviousPhoto(){
        imageIndex = max(imageIndex - 1,0)
    }
    
}
