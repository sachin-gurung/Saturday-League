import SwiftUI
import FirebaseFirestore

struct MatchesView: View {
    @State private var matches: [Match] = []

    var body: some View {
        VStack {
            Text("Match Scores")
                .font(.headline)
                .padding()

            List {
                ForEach(matches) { match in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(formattedDate(match.datePlayed))
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
                .onDelete(perform: deleteMatch) // Enable swipe-to-delete
            }
            .onAppear { fetchMatches() }
        }
    }

    // Fetch matches from Firestore
    private func fetchMatches() {
        FirestoreManager.shared.fetchMatches { result in
            switch result {
            case .success(let fetchedMatches):
                DispatchQueue.main.async {
                    self.matches = fetchedMatches
                }
            case .failure(let error):
                print("Error fetching matches: \(error)")
            }
        }
    }

    // Delete a match from Firestore
    private func deleteMatch(at offsets: IndexSet) {
        for index in offsets {
            let match = matches[index]
            FirestoreManager.shared.deleteMatch(matchId: match.id) { result in
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        self.matches.remove(atOffsets: offsets) // Remove from UI
                    }
                case .failure(let error):
                    print("Error deleting match: \(error)")
                }
            }
        }
    }

    // Format date to readable string
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    MatchesView()
}
