//
//  AuthenticationView.swift
//  Saturday League
//
//  Created by Sachin Gurung on 12/29/24.
//

import SwiftUI
import AuthenticationServices

struct AuthenticationView: View {
    
    @Binding var showSignInView: Bool
    @State private var appleSignInCoordinator = AppleSignInCoordinator()
    
    var body: some View {
        VStack {
            SignInWithAppleButton(.signIn, onRequest: { request in
                appleSignInCoordinator.handleSignInWithAppleRequest(request: request)
            }, onCompletion: { result in
                appleSignInCoordinator.handleSignInWithAppleCompletion(result: result, showSignInView: $showSignInView)
            })
            .frame(height: 55)
            .cornerRadius(10)
            .padding()
            
            Spacer()
        }
        .padding()
        .navigationTitle("Sign In")
    }
}

// Helper class for Sign in with Apple
final class AppleSignInCoordinator: NSObject {
    fileprivate var currentNonce: String?

    func handleSignInWithAppleRequest(request: ASAuthorizationAppleIDRequest) {
        let rawNonce = AuthenticationManager.shared.randomNonceString()
        currentNonce = rawNonce  // Store raw nonce for later verification
        request.requestedScopes = [.fullName, .email]
        request.nonce = AuthenticationManager.shared.sha256(rawNonce)  // Send SHA256 hashed nonce
    }

    func handleSignInWithAppleCompletion(result: Result<ASAuthorization, Error>, showSignInView: Binding<Bool>) {
        switch result {
        case .success(let authResult):
            guard let appleIDCredential = authResult.credential as? ASAuthorizationAppleIDCredential else {
                print("Failed to get AppleID credential")
                return
            }

            Task {
                do {
                    _ = try await AuthenticationManager.shared.signInWithApple(credential: appleIDCredential)
                    DispatchQueue.main.async {
                        showSignInView.wrappedValue = false
                    }
                } catch {
                    print("Error signing in with Apple: \(error)")
                }
            }

        case .failure(let error):
            print("Apple Sign-in failed: \(error.localizedDescription)")
        }
    }
}
