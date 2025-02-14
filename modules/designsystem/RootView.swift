//
//  RootView.swift
//  Saturday League
//
//  Created by Sachin Gurung on 12/30/24.
//

import SwiftUI

struct RootView: View {
    
    @State private var showSignInView: Bool = false
    
    var body: some View {
        ZStack {
            NavigationStack {
//                SettingsView(showSignInView: $showSignInView)
                if showSignInView {
                    AuthenticationView(showSignInView: $showSignInView)
                } else {
                    ContentView() // Show ContentView after sign-in
                }
            }
        }
        .onAppear {
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInView = authUser == nil
        }
        .fullScreenCover(isPresented: $showSignInView) {
            NavigationStack {
                AuthenticationView(showSignInView: $showSignInView)
            }
        }
    }
}

struct RootView_Previews {
    static var previews: some View {
        RootView()
    }
}
