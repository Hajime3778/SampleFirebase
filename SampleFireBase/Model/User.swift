//
//  User.swift
//  SampleFirebase
//
//  Created by Hajime Takeuchi on 2019/12/04.
//  Copyright © 2019 Hajime Takeuchi. All rights reserved.
//

import UIKit
import Firebase

struct User {
    var name: String = ""
    var age: Int = 0
    var favoriteFood: String = ""
    
    /// Dictionaryに変換します。
    var toDictionary: [String: Any] {
        return [
            "name": name,
            "age": age,
            "favoriteFood": favoriteFood
        ]
    }
    
    /// Dictionaryから、自分自身に代入します。
    /// - Parameter dictionary: User型
    mutating func setFromDictionary(_ dictionary: [String: Any]) {
        name = dictionary["name"] as? String ?? ""
        age = dictionary["age"] as? Int ?? 0
        favoriteFood = dictionary["favoriteFood"] as? String ?? ""
    }
}

enum DisplayMode {
    case insert
    case update
}
