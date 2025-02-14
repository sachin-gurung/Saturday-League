//
//  AuthenticationManager.swift
//  Saturday League
//
//  Created by Sachin Gurung on 12/30/24.
//

import Foundation
import FirebaseAuth
import AuthenticationServices
import CryptoKit

struct AuthDataResultModel{
    let uid: String
    let email: String?
    let photoUrl: String?
    
    init(user: User){
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
    }
}

final class AuthenticationManager{
    static let shared = AuthenticationManager()
    private init(){}
    
    // Store the nonce
    private var currentNonce: String?
    
    // Sign in with Apple
    func signInWithApple(credential: ASAuthorizationAppleIDCredential) async throws -> AuthDataResultModel {
            guard let appleIDToken = credential.identityToken else {
                throw URLError(.badServerResponse)
            }

            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                throw URLError(.cannotDecodeContentData)
            }

        // Use the stored nonce instead of generating a new one
        guard let nonce = currentNonce else {
            throw URLError(.badServerResponse)
        }
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)

            let authDataResult = try await Auth.auth().signIn(with: credential)
            return AuthDataResultModel(user: authDataResult.user)
        }
    
    func getAuthenticatedUser() throws -> AuthDataResultModel{
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        return AuthDataResultModel(user: user)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    public func randomNonceString(length: Int = 32) -> String {
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length

        while remainingLength > 0 {
            let randoms: [UInt8] = (0..<16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode == errSecSuccess {
                    return random
                } else {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed.")
                }
            }

            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        self.currentNonce = result
        return result
    }
    
    // MARK: - SHA256 Hash Function for Nonce
    public func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        return hashedData.compactMap { String(format: "%02x", $0) }.joined()
    }
}


