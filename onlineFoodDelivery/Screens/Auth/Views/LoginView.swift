//
//  LoginView.swift
//  onlineFoodDelivery
//
//  Created by Ashirwad on 09/04/26.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject private var viewModel = RegisterViewModel()
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoginActive: Bool = false
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // logo
                    logo
                    
                    //title
                    titleView
                    Spacer().frame(height: 40)
                    
                    //textField with validation
                    VStack(alignment: .leading, spacing: 4) {
                        InputView(placeholder: "Email or phone number", text: $email)
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
                    
                    VStack(alignment: .leading, spacing: 4) {
                        InputView(placeholder: "Password", isSecureField: true, text: $password)
                        if !password.isEmpty {
                            HStack(spacing: 8) {
                                Image(systemName: viewModel.isValidPassword(password) ? "checkmark.circle.fill" : "xmark.circle.fill")
                                    .foregroundColor(viewModel.isValidPassword(password) ? .green : .red)
                                Text(viewModel.isValidPassword(password) ? "Valid password" : "Min 6 chars, 1 upper, 1 lower, 1 digit, 1 special")
                                    .font(.caption)
                                    .foregroundColor(viewModel.isValidPassword(password) ? .green : .red)
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
                    
                    Spacer(minLength: 20)
                    
                    //forgot button
                    forgotButton
                    Spacer().frame(height: 20)
                    
                    //login button
                    loginButton
                    Spacer().frame(height: 20)
                    
                    //bottom view or
                    bottomView
                    
                    NavigationLink(destination: FoodListView(viewModel: FoodListViewModel()), isActive: $isLoginActive) {
                        EmptyView()
                    }
                    
                }
                
            }
            .ignoresSafeArea()
            .padding(.horizontal)
        }
    }
    
    private var logo: some View {
        Image("Designer")
            .resizable()
            .scaledToFit()
            .frame(width: 300, height: 300)
    }
    
    private var titleView: some View {
        Text("Let us help you find the best restaurants in your area")
            .font(.system(size: 20, weight: .bold, design: .default))
            .foregroundColor(.black)
            .multilineTextAlignment(.center)
    }
    
    private var forgotButton: some View {
        HStack {
            Spacer()
            Button {
            }
            label: {
                Text("Forgot Password?")
                    .foregroundStyle(.secondary)
                    .fontWeight(.medium)
                    .padding(.leading)
            }
        }
    }
    
    private var loginButton: some View {
        Button {
            authenticateUser()
        }
        label: {
            Text("Login")
        }
        .buttonStyle(CapsuleButtonStyle())
        .disabled(!isLoginFormValid)
        .opacity(isLoginFormValid ? 1.0 : 0.5)
    }
    
    
    private var line: some View {
        VStack { Divider().frame(height: 1)}
    }
    
    private var lineorView: some View {
        HStack(spacing: 16){
            line
            Text("or")
                .fontWeight(.semibold)
            line
        }
        .foregroundStyle(.gray)
    }
    
    private var appleButton: some View {
        Button {
            
        } label: {
            Label("Sign in with Apple", systemImage: "apple.logo")
        }
        .buttonStyle(CapsuleButtonStyle(bgColor: .black))
        
    }
    
    private var googleView: some View {
        Button {
            
        } label: {
            HStack {
                Image("google")
                    .resizable()
                    .frame(width: 15, height: 15)
                Text("Sign in with Google")
            }
        }
        .buttonStyle(CapsuleButtonStyle(bgColor: .clear, textColor: .black, hasBorder: true))
    }
    
    private var footerView: some View {
        NavigationLink{
            CreateAccountView()
        } label : {
            HStack {
                Text("Don't have an account?")
                    .foregroundStyle(.black)
                Text("Sign up")
                    .foregroundStyle(.teal)
            }
            .fontWeight(.medium)
        }
    }
    
    
    private var bottomView: some View {
        VStack(spacing: 20) {
            lineorView
            appleButton
            googleView
            footerView
        }
    }
    
    // MARK: - Validation Properties
    var isLoginFormValid: Bool {
        !email.isEmpty &&
        !password.isEmpty &&
        viewModel.isValidEmail(email) &&
        viewModel.isValidPassword(password)
    }
    
    // MARK: - Authentication Method
    private func authenticateUser() {
        // Validate email format
        guard viewModel.isValidEmail(email) else {
            errorMessage = "Please enter a valid email address"
            showError = true
            return
        }
        
        // Validate password format
        guard viewModel.isValidPassword(password) else {
            errorMessage = "Please enter a valid password"
            showError = true
            return
        }
        
        // Check if user exists with matching credentials
        do {
            if let user = try StorageService.getUserBy(email) {
                // User found, verify password
                if user.password == password {
                    // Password matches, login successful
                    isLoginActive = true
                    showError = false
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                } else {
                    // Password does not match
                    errorMessage = "Invalid password. Please try again."
                    showError = true
                }
            } else {
                // User not found
                errorMessage = "No account found with this email. Please sign up first."
                showError = true
            }
        } catch {
            errorMessage = "Error checking credentials. Please try again."
            showError = true
            print("Login Error: \(error.localizedDescription)")
            debugPrint(error)
        }
    }
}

#Preview {
    LoginView()
}
