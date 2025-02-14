//
//  FirestoreManager.swift
//  Saturday League
//
//  Created by Sachin Gurung on 2/13/25.
//

import FirebaseFirestore

final class FirestoreManager {
    static let shared = FirestoreManager()
    private let db = Firestore.firestore()
    
    private init() {}
    
    // MARK: - Add a New Team
    func addTeam(name: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let teamData: [String: Any] = [
            "name": name,
            "played": 0,
            "wins": 0,
            "draws": 0,
            "losses": 0,
            "goalDifference": 0,
            "points": 0
        ]

        print("🟡 Attempting to add team:", teamData) // Debugging print

        db.collection("teams").addDocument(data: teamData) { error in
            if let error = error {
                print("❌ Error adding team: \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                print("✅ Team successfully added to Firestore")
                completion(.success(()))
            }
        }
    }
    
    func addMatch(homeTeam: String, homeScore: Int, awayTeam: String, awayScore: Int, datePlayed: Date, completion: @escaping (Result<Void, Error>) -> Void) {
        let matchData: [String: Any] = [
            "homeTeam": homeTeam,
            "homeScore": homeScore,
            "awayTeam": awayTeam,
            "awayScore": awayScore,
            "datePlayed": Timestamp(date: datePlayed)
        ]

        print("🟡 Attempting to add match:", matchData) // Debugging print

        db.collection("matches").addDocument(data: matchData) { error in
            if let error = error {
                print("❌ Error adding match: \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                print("✅ Match successfully added to Firestore")
                completion(.success(()))
            }
        }
    }

    // MARK: - Listen for Real-Time Match Updates
    func fetchMatches(completion: @escaping (Result<[Match], Error>) -> Void) {
        db.collection("matches")
            .order(by: "datePlayed", descending: true) // Sort by most recent
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                var matches: [Match] = []
                for document in snapshot?.documents ?? [] {
                    let data = document.data()
                    if let match = Match(id: document.documentID, data: data) {
                        matches.append(match)
                    }
                }

                completion(.success(matches))
            }
    }
    
    // MARK: - Fetch Teams from Firestore
        func fetchTeams(completion: @escaping (Result<[Team], Error>) -> Void) {
            db.collection("teams").getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    completion(.success([])) // Return an empty array if no teams exist
                    return
                }

                let teams: [Team] = documents.compactMap { document in
                    return Team(id: document.documentID, data: document.data())
                }

                completion(.success(teams))
            }
        }
    
    // MARK: - Delete a Team
    func deleteTeam(teamId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("teams").document(teamId).delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // MARK: - Update Team Score in Firestore
    func updateTeamScore(teamId: String, wins: Int, losses: Int, draws: Int, goalDifference: Int, points: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        let totalGames = wins + losses + draws

        db.collection("teams").document(teamId).updateData([
            "played": totalGames,
            "wins": wins,
            "losses": losses,
            "draws": draws,
            "goalDifference": goalDifference,
            "points": points
        ]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // MARK: - Delete a Match
    func deleteMatch(matchId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("matches").document(matchId).delete { error in
            if let error = error {
                print("❌ Error deleting match: \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                print("✅ Match successfully deleted")
                completion(.success(()))
            }
        }
    }
}
