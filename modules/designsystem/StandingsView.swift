//
//  StandingsView.swift
//  Saturday League
//
//  Created by Sachin Gurung on 2/14/25.
//

import SwiftUI
import FirebaseFirestore

struct StandingsView: View {
    @State private var teams: [Team] = [] // Teams from Firestore
    @State private var newTeamName: String = "" // New team input
    
    @State private var homeTeam = ""
    @State private var homeScore = ""
    @State private var awayTeam = ""
    @State private var awayScore = ""
    
    var body: some View {
        VStack {
            // Add Team Section
            HStack {
                TextField("Enter Team Name", text: $newTeamName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Button(action: { addTeam() }) {
                    Text("Add Team")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal)
            
            // Score Submission
            HStack {
                TextField("Home Team", text: $homeTeam)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Home Score", text: $homeScore)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
            }
            .padding(.horizontal)
            
            HStack {
                TextField("Away Team", text: $awayTeam)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Away Score", text: $awayScore)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
            }
            .padding(.horizontal)
            
            Button(action: submitScore) {
                Text("Submit Score")
                    .fontWeight(.bold)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(Color.white)
                    .cornerRadius(10)
            }
            .padding()
            
            Text("Welcome to SAPL!")
                .font(.headline)
                .padding(.leading, 16)
                .foregroundColor(Color.black)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // 🏆 **Header Row for Standings Table**
            HStack {
                Text("TEAM NAME").frame(width: 100, alignment: .leading).bold()
                Spacer()
                Text("PL").frame(width: 30, alignment: .center).bold()
                Text("W").frame(width: 30, alignment: .center).bold()
                Text("D").frame(width: 30, alignment: .center).bold()
                Text("L").frame(width: 30, alignment: .center).bold()
                Text("+/-").frame(width: 50, alignment: .center).bold()
                Text("PTS").frame(width: 40, alignment: .center).bold()
            }
            .padding(.horizontal)
            .padding(.bottom, 5)
            
            // Display Standings
            List {
                ForEach(teams) { team in
                    HStack {
                        Text(team.name).frame(width: 100, alignment: .leading)
                        Spacer()
                        Text("\(team.played)").frame(width: 30, alignment: .center)
                        Text("\(team.wins)").frame(width: 30, alignment: .center)
                        Text("\(team.draws)").frame(width: 30, alignment: .center)
                        Text("\(team.losses)").frame(width: 30, alignment: .center)
                        Text("\(team.goalDifference)").frame(width: 50, alignment: .center)
                        Text("\(team.points)").frame(width: 40, alignment: .center)
                    }
                }
                .onDelete(perform: deleteTeam) // Swipe to delete functionality
            }
            .onAppear { fetchTeams() } // Load teams
        }
    }
    
    // Fetch teams from Firestore
    private func fetchTeams() {
        FirestoreManager.shared.fetchTeams { result in
            switch result {
            case .success(let fetchedTeams):
                DispatchQueue.main.async {
                    self.teams = fetchedTeams.sorted { $0.points > $1.points }
                }
            case .failure(let error):
                print("Error fetching teams: \(error)")
            }
        }
    }
    
    // Add a new team
    private func addTeam() {
        let trimmedName = newTeamName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }
        
        // Convert input name to lowercase for comparison
        let lowercasedName = trimmedName.lowercased()
        
        // Check if a team with the same name (case insensitive) already exists
        if teams.contains(where: { $0.name.lowercased() == lowercasedName }) {
            print("Error: A team with this name already exists.")
            return
        }
        
        // Proceed with adding the team to Firestore
        FirestoreManager.shared.addTeam(name: trimmedName) { _ in fetchTeams() }
        newTeamName = "" // Clear input field after adding
    }
    
    //    // Add a new team
    //    private func addTeam() {
    //        guard !newTeamName.isEmpty else { return }
    //        FirestoreManager.shared.addTeam(name: newTeamName) { _ in fetchTeams() }
    //        newTeamName = ""
    //    }
    
    // Submit a match result
    private func submitScore() {
        guard let homeScoreInt = Int(homeScore), let awayScoreInt = Int(awayScore),
              !homeTeam.isEmpty, !awayTeam.isEmpty else {
            print("Error: Invalid input")
            return
        }
        
        let trimmedHomeTeam = homeTeam.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let trimmedAwayTeam = awayTeam.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        // Find home and away teams case-insensitively
        guard let homeTeamData = teams.first(where: { $0.name.lowercased() == trimmedHomeTeam }),
              let awayTeamData = teams.first(where: { $0.name.lowercased() == trimmedAwayTeam }) else {
            print("Error: One or both teams not found")
            return
        }
        
        var updatedHomeTeam = homeTeamData
        var updatedAwayTeam = awayTeamData
        
        updatedHomeTeam.played += 1
        updatedAwayTeam.played += 1
        
        if homeScoreInt > awayScoreInt {
            updatedHomeTeam.wins += 1
            updatedHomeTeam.points += 3
            updatedAwayTeam.losses += 1
        } else if homeScoreInt < awayScoreInt {
            updatedAwayTeam.wins += 1
            updatedAwayTeam.points += 3
            updatedHomeTeam.losses += 1
        } else {
            updatedHomeTeam.draws += 1
            updatedAwayTeam.draws += 1
            updatedHomeTeam.points += 1
            updatedAwayTeam.points += 1
        }
        
        updatedHomeTeam.goalDifference += (homeScoreInt - awayScoreInt)
        updatedAwayTeam.goalDifference += (awayScoreInt - homeScoreInt)
        
        // Update Firestore for both teams
        FirestoreManager.shared.updateTeamScore(
            teamId: updatedHomeTeam.id,
            wins: updatedHomeTeam.wins,
            losses: updatedHomeTeam.losses,
            draws: updatedHomeTeam.draws,
            goalDifference: updatedHomeTeam.goalDifference,
            points: updatedHomeTeam.points
        ) { _ in }
        
        FirestoreManager.shared.updateTeamScore(
            teamId: updatedAwayTeam.id,
            wins: updatedAwayTeam.wins,
            losses: updatedAwayTeam.losses,
            draws: updatedAwayTeam.draws,
            goalDifference: updatedAwayTeam.goalDifference,
            points: updatedAwayTeam.points
        ) { _ in }
        
        fetchTeams() // Refresh standings after update
        
        // Clear input fields
        homeTeam = ""
        homeScore = ""
        awayTeam = ""
        awayScore = ""
    }
    
    // Delete a team
    private func deleteTeam(at offsets: IndexSet) {
        for index in offsets {
            let team = teams[index]
            FirestoreManager.shared.deleteTeam(teamId: team.id) { result in
                switch result {
                case .success:
                    fetchTeams() // Reload teams after deleting
                case .failure(let error):
                    print("Error deleting team: \(error)")
                }
            }
        }
    }
}

#Preview {
    StandingsView()
}
