//
//  UserStateViewModel.swift
//  onlineFoodDelivery
//
//  Created by Ashirwad on 05/05/26.
//

import Foundation

enum UserStateError: Error{
    case signInError, signOutError
}

class UserStateViewModel: ObservableObject {
    
    func signOut() {
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
    }
}
