//
//  AppState.swift
//  OIL_APP
//
//  Created by Miguel Gallardo on 3/19/19.
//  Copyright © 2019 JAMO-JMGT-CAO. All rights reserved.
//

class AppState {
    enum State {
        case unregistered
        case loggedIn
    }
    
    var state: State = .unregistered
}
