//
//  UserSingleton.swift
//  Snapchat Clone
//
//  Created by İhsan Elkatmış on 3.08.2022.
//

import Foundation

class UserSingleton {
    
    static let sharedUserInfo = UserSingleton()
    
    var email = ""
    var username = ""
    
    
    
    
    private init() {
        
    }
    
    
}
