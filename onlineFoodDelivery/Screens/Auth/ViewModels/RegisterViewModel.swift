//
//  RegisterViewModel.swift
//  onlineFoodDelivery
//
//  Created by Ashirwad on 08/05/26.
//

import Foundation
class RegisterViewModel: ObservableObject {
    
func registerUser(email: String, password: String) throws {
    do {
        try StorageService.saveUser(email, password)
    } catch {
        print("❌ Register error: \(error.localizedDescription)")
        debugPrint(error)
        throw error
    }
}

// MARK: Email ID Validation
func isValidEmail(_ email: String) -> Bool {
    guard !email.isEmpty else { return false }
    let emailRegx = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegx)
    return emailPred.evaluate(with: email)
}

// MARK: Password Validation
func isValidPassword(_ password: String) -> Bool {
    guard !password.isEmpty else { return false }
    let passwordRegx = "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z])(?=.*[!@#$%&?._-]).{6,}"
    let passwordPred = NSPredicate(format: "SELF MATCHES %@", passwordRegx)
    return passwordPred.evaluate(with: password)
}

// MARK: Confirm password validation
func isValidConfirmPassword(_ password: String, _ confirmPassword: String) -> Bool {
    guard !password.isEmpty, !confirmPassword.isEmpty else { return false }
    return password == confirmPassword
}
}
