//
//  SignInEmailView.swift
//  Saturday League
//
//  Created by Sachin Gurung on 12/30/24.
//

import SwiftUI

@MainActor
final class SignInWithEmailViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    
    func signUp() async throws{
        guard !email.isEmpty, !password.isEmpty else {
            print("Please enter email and password")
            return
        }
        
        try await AuthenticationManager.shared.CreateUser(email: email, password: password)
    }
    
    func signIn() async throws{
        guard !email.isEmpty, !password.isEmpty else {
            print("Please enter email and password")
            return
        }
        
        try await AuthenticationManager.shared.signInUser(email: email, password: password)
    }
}

struct SignInEmailView: View {
    
    @StateObject private var viewModel = SignInWithEmailViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        VStack {
            TextField("Email", text: $viewModel.email)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
            SecureField("Password", text: $viewModel.password)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
            Button {
                Task {
                    do {
                        try await viewModel.signUp()
                        showSignInView = false
                        return
                    } catch {
                        print("Error signing up: \(error)")
                    }
                    
                    do {
                        try await viewModel.signIn()
                        showSignInView = false
                        return
                    } catch {
                        print("Error signing in: \(error)")
                    }
                }
            } label: {
                Text("Sign in")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            Spacer()
        }
        .padding()
        .navigationTitle("Sign In With Email")
    }
}

struct SignInEmailView_Previews: PreviewProvider {
    static var previews: some View{
        NavigationStack{
            SignInEmailView(showSignInView: .constant(false))
        }
    }
}
