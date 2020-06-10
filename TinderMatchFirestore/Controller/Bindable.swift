//
//  Bindable.swift
//  TinderMatchFirestore
//
//  Created by Vishal Lakshminarayanappa on 6/1/20.
//  Copyright © 2020 Vishal Lakshminarayanappa. All rights reserved.
//

import Foundation


class Bindable<T>{
    
    var value : T?{
        didSet{
            observer?(value)
        }
    }
    
    var observer : ((T?) -> ())?
    
    func bind(observer : @escaping(T?)->()){
        self.observer = observer
    }
}
