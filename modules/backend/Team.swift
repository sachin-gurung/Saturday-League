//
//  Team.swift
//  Saturday League
//
//  Created by Sachin Gurung on 6/17/24.
//

import Foundation

import Foundation

struct Team: Identifiable {
    var id: String  // Firestore document ID
    var name: String
    var played: Int
    var wins: Int
    var draws: Int
    var losses: Int
    var goalDifference: Int
    var points: Int

    // Convert Firestore document to `Team`
    init(id: String, data: [String: Any]) {
        self.id = id
        self.name = data["name"] as? String ?? "Unknown"
        self.played = data["played"] as? Int ?? 0
        self.wins = data["wins"] as? Int ?? 0
        self.draws = data["draws"] as? Int ?? 0
        self.losses = data["losses"] as? Int ?? 0
        self.goalDifference = data["goalDifference"] as? Int ?? 0
        self.points = data["points"] as? Int ?? 0
    }

    // Convert `Team` to Firestore dictionary
    func toDictionary() -> [String: Any] {
        return [
            "name": name,
            "played": played,
            "wins": wins,
            "draws": draws,
            "losses": losses,
            "goalDifference": goalDifference,
            "points": points
        ]
    }
}

//struct Team: Identifiable {
//    var id = UUID()
//    var name: String
//    var played: Int
//    var wins: Int
//    var draws: Int
//    var losses: Int
//    var goalDifference: Int
//    var points: Int
//}


