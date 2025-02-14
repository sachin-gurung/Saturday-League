//
//  MatchesView.swift
//  Saturday League
//
//  Created by Sachin Gurung on 2/14/25.
//

import SwiftUI
import FirebaseFirestore

struct MatchesView: View {
    @State private var matches: [Match] = []

    var body: some View {
        VStack {
            Text("Match Scores")
                .font(.headline)
                .padding()

            List(matches) { match in
                HStack {
                    VStack(alignment: .leading) {
                        Text(match.datePlayed)
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("\(match.homeTeam) vs \(match.awayTeam)")
                            .font(.headline)
                    }
                    Spacer()
                    Text("\(match.homeScore) - \(match.awayScore)")
                        .font(.headline)
                        .foregroundColor(.blue)
                }
            }
            .onAppear { fetchMatches() } // Corrected function call
        }
    }

    // Fetch past matches from Firestore
    private func fetchMatches() {
        FirestoreManager.shared.fetchMatches { result in
            switch result {
            case .success(let fetchedMatches):
                DispatchQueue.main.async {
                    self.matches = fetchedMatches.sorted { $0.datePlayed > $1.datePlayed }
                }
            case .failure(let error):
                print("Error fetching matches: \(error)")
            }
        }
    }
}

#Preview {
    MatchesView()
}
