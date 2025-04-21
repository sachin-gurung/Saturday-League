////
////  ContentView.swift
////  Saturday League
////
////  Created by Sachin Gurung on 6/17/24.
////
///
import SwiftUI
import FirebaseFirestore

import SwiftUI
import FirebaseFirestore

struct ContentView: View {
    @State private var selectedTab = 0 // Tracks which tab is selected

    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                StandingsView()
                    .tabItem {
                        Label("Standings", systemImage: "list.number")
                    }
                    .tag(0)

                MatchesView()
                    .tabItem {
                        Label("Matches", systemImage: "sportscourt")
                    }
                    .tag(1)
            }
            .navigationTitle(selectedTab == 0 ? "THURSDAY SOCCER!" : "Match Scores")
        }
    }
}

