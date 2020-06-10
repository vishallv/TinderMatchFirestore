//
//  MatchHeaderView.swift
//  TinderMatchFirestore
//
//  Created by Vishal Lakshminarayanappa on 6/6/20.
//  Copyright © 2020 Vishal Lakshminarayanappa. All rights reserved.
//

import UIKit
import LBTATools

class MatchHeaderView : UICollectionReusableView{
    let newMatchesLabel = UILabel(text: "New Matches", font: .boldSystemFont(ofSize: 16), textColor: #colorLiteral(red: 1, green: 0.3305864632, blue: 0.3505547345, alpha: 1))
    let horizontalViewController  = MatchesHorizontalController()
    let messagesLabel = UILabel(text: "Messages", font: .boldSystemFont(ofSize: 18), textColor: #colorLiteral(red: 1, green: 0.3305864632, blue: 0.3505547345, alpha: 1))
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        stack(stack(newMatchesLabel).padLeft(20),
              horizontalViewController.view,
              stack(messagesLabel).padLeft(20),
              spacing : 20).withMargins(.init(top: 20, left: 0, bottom: 0, right: 0))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
