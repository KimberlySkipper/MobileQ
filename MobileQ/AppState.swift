//
//  AppState.swift
//  MobileQ
//
//  Created by Kimberly Skipper on 1/3/17.
//  Copyright © 2017 The Iron Yard. All rights reserved.
//

import Foundation

class AppState {
    
    static let sharedInstance = AppState()
    
    var signedIn = false
    var displayName: String?
}
