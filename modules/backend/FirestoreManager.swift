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

    // MARK: - Fetch All Teams
    func fetchTeams(completion: @escaping (Result<[Team], Error>) -> Void) {
        db.collection("teams").getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            var teams: [Team] = []
            for document in snapshot?.documents ?? [] {
                let team = Team(id: document.documentID, data: document.data())
                teams.append(team)
            }

            completion(.success(teams))
        }
    }

    // MARK: - Update Team Score
    func updateTeamScore(teamId: String, wins: Int, losses: Int, draws: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        let totalGames = wins + losses + draws
        let points = (wins * 3) + (draws * 1)

        db.collection("teams").document(teamId).updateData([
            "played": totalGames,
            "wins": wins,
            "losses": losses,
            "draws": draws,
            "points": points
        ]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
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
}
