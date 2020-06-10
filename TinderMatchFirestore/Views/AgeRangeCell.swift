//
//  AgeRangeCell.swift
//  TinderMatchFirestore
//
//  Created by Vishal Lakshminarayanappa on 6/2/20.
//  Copyright © 2020 Vishal Lakshminarayanappa. All rights reserved.
//

import UIKit

class AgeRangeCell : UITableViewCell{
    //MARK: Properties
    
    let minSlider :  UISlider = {
        let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 100
        return slider
    }()
    
    let maxSlider :  UISlider = {
        let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 100
        return slider
    }()
    
    let minLabel : UILabel = {
        let label = AgeRangeLabel()
        label.text = "Min 32"
        return label
    }()
    let maxLabel : UILabel = {
        let label = AgeRangeLabel()
        label.text = "Min 88"
        return label
    }()
    
    
    //MARK: Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let overAllStackView = UIStackView(arrangedSubviews: [
            UIStackView(arrangedSubviews: [minLabel,minSlider]) ,
            UIStackView(arrangedSubviews: [maxLabel,maxSlider]) ,
        ])
        overAllStackView.axis = .vertical
        overAllStackView.spacing = 16
        
        addSubview(overAllStackView)
        overAllStackView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 16, paddingRight: 16)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Selector
    
    //MARK: Helper Function
}
class AgeRangeLabel : UILabel{
    
    override var intrinsicContentSize: CGSize{
        return .init(width: 80, height: 0)
    }
}
