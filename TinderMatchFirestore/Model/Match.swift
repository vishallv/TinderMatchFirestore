//
//  Match.swift
//  TinderMatchFirestore
//
//  Created by Vishal Lakshminarayanappa on 6/6/20.
//  Copyright © 2020 Vishal Lakshminarayanappa. All rights reserved.
//

import UIKit

struct Match {
    let name, profileImageUrl,uid : String
    
    init(dictionary : [String:Any]) {
        self.name = dictionary["name"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}
