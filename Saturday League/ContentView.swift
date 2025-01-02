//
//  ContentView.swift
//  Saturday League
//
//  Created by Sachin Gurung on 6/17/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseCrashlytics

struct ContentView: View {
    @State private var teams: [Team] = [] // Start with an empty array
    @State private var newTeamName: String = "" // Input field for new team names
    
    @State private var homeTeam = ""
    @State private var homeScore = ""
    @State private var awayTeam = ""
    @State private var awayScore = ""
    
    var body: some View {
        NavigationView {
            VStack {
                // Input field and button for adding new teams
                HStack {
                    TextField("New Team Name", text: $newTeamName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    Button(action: {
                        addTeam()
                    }) {
                        Text("Add Team")
                            .padding()
                            .background(Color.green)
                            .foregroundColor(Color.white)
                            .cornerRadius(10)
                    }
                }
                
                HStack {
                    TextField("Home Team", text: $homeTeam)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("Home Score", text: $homeScore)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                }
                HStack {
                    TextField("Away Team", text: $awayTeam)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("Away Score", text: $awayScore)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                }
                Button(action: updateStandings) {
                    Text("Submit Score")
                        .fontWeight(.bold)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .cornerRadius(10)
                }
                .padding()
                
                Text("TEAM STANDINGS")
                    .font(.headline)
                    .padding(.bottom, 5)
                    .foregroundColor(Color.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                List {
                    HStack {
                        Text("TEAM")
                            .frame(width: 100, alignment: .leading)
                        Spacer()
                        Text("PL")
                            .frame(width: 30, alignment: .center)
                        Text("W")
                            .frame(width: 30, alignment: .center)
                        Text("D")
                            .frame(width: 30, alignment: .center)
                        Text("L")
                            .frame(width: 30, alignment: .center)
                        Text("+/-")
                            .frame(width: 50, alignment: .center)
                        Text("PTS")
                            .frame(width: 40, alignment: .center)
                    }
                    .font(.headline)
                    
                    ForEach(teams) { team in
                        HStack {
                            Text(team.name)
                                .frame(width: 100, alignment: .leading)
                            Spacer()
                            Text("\(team.played)")
                                .frame(width: 30, alignment: .center)
                            Text("\(team.wins)")
                                .frame(width: 30, alignment: .center)
                            Text("\(team.draws)")
                                .frame(width: 30, alignment: .center)
                            Text("\(team.losses)")
                                .frame(width: 30, alignment: .center)
                            Text("\(team.goalDifference)")
                                .frame(width: 50, alignment: .center)
                            Text("\(team.points)")
                                .frame(width: 30, alignment: .center)
                        }
                    }
                    .onDelete(perform: deleteTeam) // Enable swipe-to-delete
                }
                
                .toolbar{
                    ToolbarItem(placement: .principal){
                        Text ("Welcome to the Soccer League!")
                            .padding(.top, 40)
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(Color.blue)
                            .shadow(color: Color.black.opacity(0.5), radius: 4, x: 0, y: 2)
                            .multilineTextAlignment(.center)
                    }
                }
            }
            .padding()
        }
    }
    
    
    
    func deleteTeam(at offsets: IndexSet){
        teams.remove(atOffsets: offsets)
    }
    
    func addTeam(){
        let trimmedName = newTeamName.trimmingCharacters(in: .whitespaces)
        guard !trimmedName.isEmpty else {
            return
        }
        
        let newTeam = Team(name: trimmedName, played: 0, wins: 0, draws: 0, losses: 0, goalDifference: 0, points: 0)
        teams.append(newTeam)
        newTeamName = "" // Clear the input field
    }
    
    func updateStandings(){
        guard let homeScore = Int(homeScore), let awayScore = Int(awayScore) else {
            return
        }
        
        let trimmedHomeTeam = homeTeam.trimmingCharacters(in: .whitespaces)
        let trimmedAwayTeam = awayTeam.trimmingCharacters(in: .whitespaces)
        
        if let homeIndex = teams.firstIndex(where: {$0.name.caseInsensitiveCompare(trimmedHomeTeam) == .orderedSame}),
           let awayIndex = teams.firstIndex(where: {$0.name.caseInsensitiveCompare(trimmedAwayTeam) == .orderedSame}) {
            
            teams[homeIndex].played += 1
            teams[awayIndex].played += 1
            
            if homeScore > awayScore {
                teams[homeIndex].wins += 1
                teams[homeIndex].points += 3
                teams[awayIndex].losses += 1
            } else if homeScore < awayScore {
                teams[awayIndex].wins += 1
                teams[awayIndex].points += 3
                teams[homeIndex].losses += 1
            } else {
                teams[homeIndex].draws += 1
                teams[awayIndex].draws += 1
                teams[homeIndex].points += 1
                teams[awayIndex].points += 1
            }
            
            teams[homeIndex].goalDifference += (homeScore - awayScore)
            teams[awayIndex].goalDifference += (awayScore - homeScore)
            
            // sort teams by points, then goal difference
            teams.sort {
                if $0.points == $1.points {
                    return $0.goalDifference > $1.goalDifference
                }
                return $0.points > $1.points
            }
            
            // clear the input fields
            self.homeTeam = ""
            self.homeScore = ""
            self.awayTeam = ""
            self.awayScore = ""
        }
        
        func setupFirestore() {
            let db = Firestore.firestore()
            print("Firestore connected \(db)")
        }
        
        Crashlytics.crashlytics().log("Crashlytics is working!")
        print("Crashlytics initialized.")
    }
}




