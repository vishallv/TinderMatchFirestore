//
//  Message.swift
//  TinderMatchFirestore
//
//  Created by Vishal Lakshminarayanappa on 6/6/20.
//  Copyright © 2020 Vishal Lakshminarayanappa. All rights reserved.
//

import Foundation
import Firebase
struct Message {
    let text,fromID,toID : String
    let timeStamp : Timestamp
    let IsMessageFromCurrentUser :Bool
    
    
    init(dictionary : [String:Any]) {
        self.text = dictionary["text"] as? String ?? ""
        self.fromID = dictionary["fromID"] as? String ?? ""
        self.timeStamp = dictionary["timeStamp"] as? Timestamp ?? Timestamp(date: Date())
        self.toID = dictionary["toID"] as? String ?? ""
        
        self.IsMessageFromCurrentUser = Auth.auth().currentUser?.uid == self.fromID
    }
}
