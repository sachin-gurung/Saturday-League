//
//  SettingsView.swift
//  Saturday League
//
//  Created by Sachin Gurung on 12/31/24.
//

import SwiftUI

@MainActor
final class SettingsViewModel: ObservableObject {
    
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    
    func resetPassword() async throws {
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        
        guard let email = authUser.email else {
            throw URLError(.fileDoesNotExist)
        }
        try await AuthenticationManager.shared.resetPassword(email: email)
    }
    
    func updateEmail() async throws {
        let email = "hello123@gmail.com"
        try await AuthenticationManager.shared.updateEmail(email: email)
    }
    
    func updatePassword() async throws {
        let password = "hello123!"
        try await AuthenticationManager.shared.updatePassword(password: password)
    }
}

struct SettingsView: View {
    
    @StateObject private var viewModel = SettingsViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        List{
            Button("Logout") {
                Task{
                    do {
                        try viewModel.signOut()
                        showSignInView = true
                    } catch{
                        print("Error signing out: \(error)")
                    }
                }
            }
            emailSection
        }
        .navigationBarTitle("Settings")
    }
}

struct SettingsView_Previews: PreviewProvider{
    static var previews: some View{
        NavigationStack{
            SettingsView(showSignInView: .constant(false))
        }
    }
}

extension SettingsView {
    private var emailSection: some View {
        Section{
            Button("Reset password") {
                Task{
                    do {
                        try await viewModel.resetPassword()
                        print ("Password reset successful!")
                    } catch{
                        print("Error signing out: \(error)")
                    }
                }
            }
            
            Button("Update password") {
                Task{
                    do {
                        try await viewModel.updatePassword()
                        print ("Password update successful!")
                    } catch{
                        print("Error updating password: \(error)")
                    }
                }
            }
            
            Button("Update email") {
                Task{
                    do {
                        try await viewModel.updateEmail()
                        print ("Email update successful!")
                    } catch{
                        print("Error updating email: \(error)")
                    }
                }
            }
        } header: { Text("Email functions") }
    }
}
