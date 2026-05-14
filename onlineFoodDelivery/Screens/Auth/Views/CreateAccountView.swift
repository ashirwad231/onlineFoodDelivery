//
//  CreateAccountView.swift
//  onlineFoodDelivery
//
//  Created by Ashirwad on 09/04/26.
//

import SwiftUI

struct CreateAccountView: View {
    
    @StateObject private var viewModel = RegisterViewModel()
    @State private var email: String = ""
    @State private var fullName: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    @State private var showSuccess: Bool = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Please complete all information to Create your account")
                .font(.headline).fontWeight(.bold)
                .foregroundStyle(.primary)
                .multilineTextAlignment(.center)
                .padding(.vertical)
            
            // Email input with validation
            VStack(alignment: .leading, spacing: 4) {
                InputView(placeholder: "Enter your email address", text: $email)
                if !email.isEmpty {
                    HStack(spacing: 8) {
                        Image(systemName: viewModel.isValidEmail(email) ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(viewModel.isValidEmail(email) ? .green : .red)
                        Text(viewModel.isValidEmail(email) ? "Valid email" : "Invalid email format")
                            .font(.caption)
                            .foregroundColor(viewModel.isValidEmail(email) ? .green : .red)
                    }
                    .padding(.horizontal)
                }
            }
            
            // Full name input
            InputView(placeholder: "Enter your full name", text: $fullName)
            
            // Password input with validation
            VStack(alignment: .leading, spacing: 4) {
                InputView(placeholder: "Enter your Password", isSecureField: true, text: $password)
                if !password.isEmpty {
                    HStack(spacing: 8) {
                        Image(systemName: viewModel.isValidPassword(password) ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(viewModel.isValidPassword(password) ? .green : .red)
                        Text(viewModel.isValidPassword(password) ? "Strong password" : "Min 6 chars, 1 upper, 1 lower, 1 digit, 1 special")
                            .font(.caption)
                            .foregroundColor(viewModel.isValidPassword(password) ? .green : .red)
                    }
                    .padding(.horizontal)
                }
            }
           
            // Confirm password with validation
            VStack(alignment: .leading, spacing: 4) {
                ZStack(alignment: .trailing) {
                    InputView(placeholder: "Confirm your password", isSecureField: true, text: $confirmPassword)
                    
                    if !password.isEmpty && !confirmPassword.isEmpty {
                        Image(systemName: "\(isPasswordMatch ? "checkmark" : "xmark").circle.fill")
                            .imageScale(.large)
                            .fontWeight(.bold)
                            .foregroundColor(isPasswordMatch ? Color(.systemGreen) : Color(.systemRed))
                            .padding(.trailing, 16)
                    }
                }
                
                if !confirmPassword.isEmpty && !isPasswordMatch {
                    HStack(spacing: 8) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.red)
                        Text("Passwords do not match")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                    .padding(.horizontal)
                }
            }
            
            // Error message
            if showError {
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.circle.fill")
                        .foregroundColor(.red)
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                }
                .padding()
                .background(Color.red.opacity(0.1))
                .cornerRadius(8)
            }
            
            // Success message
            if showSuccess {
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text("Account created successfully!")
                        .font(.caption)
                        .foregroundColor(.green)
                }
                .padding()
                .background(Color.green.opacity(0.1))
                .cornerRadius(8)
            }
            
            Spacer()
            
            Button {
                createAccount()
            } label: {
                Text("Create Account")
            }
            .buttonStyle(CapsuleButtonStyle())
            .disabled(!isFormValid)
            .opacity(isFormValid ? 1.0 : 0.5)
          
            
        }
        .navigationTitle("set up your account")
        .toolbarRole(.editor)
        .padding()
    }
    
    // MARK: - Validation Properties
    var isPasswordMatch: Bool {
        !confirmPassword.isEmpty && password == confirmPassword
    }
    
    var isFormValid: Bool {
        !email.isEmpty &&
        !fullName.isEmpty &&
        !password.isEmpty &&
        !confirmPassword.isEmpty &&
        viewModel.isValidEmail(email) &&
        viewModel.isValidPassword(password) &&
        isPasswordMatch
    }
    
    // MARK: - Methods
    private func createAccount() {
        // Validate all fields
        guard viewModel.isValidEmail(email) else {
            errorMessage = "Please enter a valid email address"
            showError = true
            return
        }
        
        guard !fullName.isEmpty else {
            errorMessage = "Please enter your full name"
            showError = true
            return
        }
        
        guard viewModel.isValidPassword(password) else {
            errorMessage = "Password must contain at least 6 characters, 1 uppercase, 1 lowercase, 1 digit, and 1 special character"
            showError = true
            return
        }
        
        guard isPasswordMatch else {
            errorMessage = "Passwords do not match"
            showError = true
            return
        }
        
        // Register user
        do {
            try viewModel.registerUser(email: email, password: password)
            showError = false
            showSuccess = true
            print("✅ Account created successfully for \(email)")
            
            // Dismiss after 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                dismiss()
            }
        } catch {
            errorMessage = "Failed to create account. Please try again."
            showError = true
            print("❌ Registration error: \(error.localizedDescription)")
        }
    }
}

#Preview {
    CreateAccountView()
}
