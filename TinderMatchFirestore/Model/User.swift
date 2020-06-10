//
//  User.swift
//  TinderMatchFirestore
//
//  Created by Vishal Lakshminarayanappa on 5/28/20.
//  Copyright © 2020 Vishal Lakshminarayanappa. All rights reserved.
//

import UIKit


struct User  : ProduceCardViewModel{
    var name : String?
    var age : Int?
    var profession : String?
    var imageUrl1 : String?
    var imageUrl2 : String?
    var imageUrl3 : String?
    var uid : String?
    
    var minSeekingAge : Int?
    var maxSeekingAge : Int?
    
    
    init(dictionary : [String:Any]) {
        
        self.name = dictionary["fullname"] as? String ?? ""
        self.age = dictionary["age"] as? Int
        self.profession = dictionary["profession"] as? String
        self.imageUrl1 = dictionary["imageURL1"] as? String
        self.imageUrl2 = dictionary["imageURL2"] as? String
        self.imageUrl3 = dictionary["imageURL3"] as? String
        self.uid = dictionary["uid"] as? String ?? ""
        self.minSeekingAge = dictionary["minSeekingAge"] as? Int
        self.maxSeekingAge = dictionary["maxSeekingAge"] as? Int
    }
    
    func toCardViewModel() -> CardViewModel{
        
        let attributedText = NSMutableAttributedString(string: name ?? "", attributes: [
                                                                                       .font : UIFont.systemFont(ofSize: 32, weight: .heavy)])
        let ageString = age != nil ? "\(age!)" : "N\\A"
        
        attributedText.append(NSAttributedString(string: " \(ageString)", attributes: [
                                                                                      .font : UIFont.systemFont(ofSize: 24, weight: .regular)]))
        let professionString = profession != nil ? "\(profession!)" : "Not Available"
        attributedText.append(NSAttributedString(string: " \n \(professionString)", attributes: [
        .font : UIFont.systemFont(ofSize: 20, weight: .regular)]))
        
        var imageUrls = [String]()
        if let url1 = imageUrl1 { imageUrls.append(url1)}
        if let url2 = imageUrl2 { imageUrls.append(url2)}
        if let url3 = imageUrl3 { imageUrls.append(url3)}
        
        
        return CardViewModel(imageNames: imageUrls, attributedText: attributedText, textAlignment: .left, uid: uid ?? "")
    }
}
