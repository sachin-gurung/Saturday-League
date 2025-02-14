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
            .navigationTitle(selectedTab == 0 ? "Team Standings" : "Match Scores")
        }
    }
}

//struct ContentView: View {
//    @State private var teams: [Team] = [] // Teams fetched from Firestore
//    @State private var newTeamName: String = "" // Input for new team names
//    
//    @State private var homeTeam = ""
//    @State private var homeScore = ""
//    @State private var awayTeam = ""
//    @State private var awayScore = ""
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                // Add Team Section
//                HStack {
//                    TextField("Enter Team Name", text: $newTeamName)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                        .padding()
//                    Button(action: { addTeam() }) {
//                        Text("Add Team")
//                            .padding()
//                            .background(Color.green)
//                            .foregroundColor(.white)
//                            .cornerRadius(10)
//                    }
//                }
//                .padding()
//                
//                // Home Team Name and Score Input
//                HStack {
//                    TextField("Home Team", text: $homeTeam)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                    TextField("Home Score", text: $homeScore)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                        .keyboardType(.numberPad)
//                }
//                
//                // Away Team Name and Score Input
//                HStack {
//                    TextField("Away Team", text: $awayTeam)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                    TextField("Away Score", text: $awayScore)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                        .keyboardType(.numberPad)
//                }
//                
//                // Submit button to update standings
//                Button(action: submitScore) {
//                    Text("Submit Score")
//                        .fontWeight(.bold)
//                        .padding()
//                        .background(Color.blue)
//                        .foregroundColor(Color.white)
//                        .cornerRadius(10)
//                }
//                .padding()
//                
//                Text("TEAM STANDINGS")
//                    .font(.headline)
//                    .padding(.bottom, 5)
//                    .foregroundColor(Color.black)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                
//                // Display Teams Table
//                List {
//                    HStack {
//                        Text("TEAM")
//                            .frame(width: 100, alignment: .leading)
//                        Spacer()
//                        Text("PL").frame(width: 30, alignment: .center)
//                        Text("W").frame(width: 30, alignment: .center)
//                        Text("D").frame(width: 30, alignment: .center)
//                        Text("L").frame(width: 30, alignment: .center)
//                        Text("+/-").frame(width: 50, alignment: .center)
//                        Text("PTS").frame(width: 40, alignment: .center)
//                    }
//                    .font(.headline)
//                    
//                    ForEach(teams) { team in
//                        HStack {
//                            Text(team.name)
//                                .frame(width: 100, alignment: .leading)
//                            Spacer()
//                            Text("\(team.played)").frame(width: 30, alignment: .center)
//                            Text("\(team.wins)").frame(width: 30, alignment: .center)
//                            Text("\(team.draws)").frame(width: 30, alignment: .center)
//                            Text("\(team.losses)").frame(width: 30, alignment: .center)
//                            Text("\(team.goalDifference)").frame(width: 50, alignment: .center)
//                            Text("\(team.points)").frame(width: 40, alignment: .center)
//                        }
//                    }
//                }
//                .onAppear { fetchTeams() } // Load teams when view appears
//            }
//        }
//    }
//
//    // MARK: - Fetch Teams from Firestore
//    private func fetchTeams() {
//        FirestoreManager.shared.fetchTeams { result in
//            switch result {
//            case .success(let fetchedTeams):
//                DispatchQueue.main.async {
//                    self.teams = fetchedTeams.sorted {
//                        if $0.points == $1.points {
//                            return $0.goalDifference > $1.goalDifference
//                        }
//                        return $0.points > $1.points
//                    }
//                }
//            case .failure(let error):
//                print("Error fetching teams: \(error)")
//            }
//        }
//    }
//
//    // MARK: - Add New Team to Firestore
//    private func addTeam() {
//        guard !newTeamName.isEmpty else { return }
//
//        FirestoreManager.shared.addTeam(name: newTeamName) { result in
//            switch result {
//            case .success:
//                fetchTeams() // Reload teams after adding a new one
//                newTeamName = "" // Clear input field
//            case .failure(let error):
//                print("Error adding team: \(error)")
//            }
//        }
//    }
//
//    // MARK: - Submit Match Score
//    private func submitScore() {
//        guard let homeScoreInt = Int(homeScore),
//              let awayScoreInt = Int(awayScore),
//              !homeTeam.isEmpty,
//              !awayTeam.isEmpty
//        else {
//            print("Invalid input. Please enter valid team names and scores.")
//            return
//        }
//
//        let trimmedHomeTeam = homeTeam.trimmingCharacters(in: .whitespaces)
//        let trimmedAwayTeam = awayTeam.trimmingCharacters(in: .whitespaces)
//
//        if let homeIndex = teams.firstIndex(where: { $0.name.caseInsensitiveCompare(trimmedHomeTeam) == .orderedSame }),
//           let awayIndex = teams.firstIndex(where: { $0.name.caseInsensitiveCompare(trimmedAwayTeam) == .orderedSame }) {
//
//            var homeTeamData = teams[homeIndex]
//            var awayTeamData = teams[awayIndex]
//
//            homeTeamData.played += 1
//            awayTeamData.played += 1
//
//            if homeScoreInt > awayScoreInt {
//                homeTeamData.wins += 1
//                homeTeamData.points += 3
//                awayTeamData.losses += 1
//            } else if homeScoreInt < awayScoreInt {
//                awayTeamData.wins += 1
//                awayTeamData.points += 3
//                homeTeamData.losses += 1
//            } else {
//                homeTeamData.draws += 1
//                awayTeamData.draws += 1
//                homeTeamData.points += 1
//                awayTeamData.points += 1
//            }
//
//            homeTeamData.goalDifference += (homeScoreInt - awayScoreInt)
//            awayTeamData.goalDifference += (awayScoreInt - homeScoreInt)
//
//            // Update Firestore
//            FirestoreManager.shared.updateTeamScore(teamId: homeTeamData.id, wins: homeTeamData.wins, losses: homeTeamData.losses, draws: homeTeamData.draws) { _ in }
//            FirestoreManager.shared.updateTeamScore(teamId: awayTeamData.id, wins: awayTeamData.wins, losses: awayTeamData.losses, draws: awayTeamData.draws) { _ in }
//
//            // Reload teams from Firestore
//            fetchTeams()
//
//            // Clear input fields
//            homeTeam = ""
//            homeScore = ""
//            awayTeam = ""
//            awayScore = ""
//        }
//    }
//}
