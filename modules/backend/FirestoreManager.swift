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
        
        db.collection("teams").addDocument(data: teamData) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // MARK: - Add a New Match
    func addMatch(homeTeam: String, homeScore: Int, awayTeam: String, awayScore: Int) {
        let matchData: [String: Any] = [
            "homeTeam": homeTeam,
            "homeScore": homeScore,
            "awayTeam": awayTeam,
            "awayScore": awayScore,
            "datePlayed": Date().formatted()
        ]
        
        db.collection("matches").addDocument(data: matchData)
    }
    
    // MARK: - Fetch Matches
    func fetchMatches(completion: @escaping (Result<[Match], Error>) -> Void) {
        db.collection("matches").getDocuments(source: .default) { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let documents = snapshot?.documents else {
                completion(.success([])) // Return empty array if no documents exist
                return
            }

            let matches: [Match] = documents.compactMap { document in
                return Match(id: document.documentID, data: document.data())
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
    
    //    // MARK: - Update Team Score
    //    func updateTeamScore(teamId: String, wins: Int, losses: Int, draws: Int, completion: @escaping (Result<Void, Error>) -> Void) {
    //        let totalGames = wins + losses + draws
    //        let points = (wins * 3) + (draws * 1)
    //
    //        db.collection("teams").document(teamId).updateData([
    //            "played": totalGames,
    //            "wins": wins,
    //            "losses": losses,
    //            "draws": draws,
    //            "points": points
    //        ]) { error in
    //            if let error = error {
    //                completion(.failure(error))
    //            } else {
    //                completion(.success(()))
    //            }
    //        }
    //    }
    
    //    // MARK: - Delete a Team
    //    func deleteTeam(teamId: String, completion: @escaping (Result<Void, Error>) -> Void) {
    //        db.collection("teams").document(teamId).delete { error in
    //            if let error = error {
    //                completion(.failure(error))
    //            } else {
    //                completion(.success(()))
    //            }
    //        }
    //    }
}
