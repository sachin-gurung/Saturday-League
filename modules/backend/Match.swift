//
//  Match.swift
//  Saturday League
//
//  Created by Sachin Gurung on 6/17/24.
//

import Foundation

struct Match: Identifiable {
    var id: String
    var homeTeam: String
    var homeScore: Int
    var awayTeam: String
    var awayScore: Int
    var datePlayed: String

    // Custom initializer to handle Firestore data parsing
    init?(id: String, data: [String: Any]) {
        guard let homeTeam = data["homeTeam"] as? String,
              let homeScore = data["homeScore"] as? Int,
              let awayTeam = data["awayTeam"] as? String,
              let awayScore = data["awayScore"] as? Int,
              let datePlayed = data["datePlayed"] as? String else {
            return nil // Return nil if any field is missing
        }
        
        self.id = id
        self.homeTeam = homeTeam
        self.homeScore = homeScore
        self.awayTeam = awayTeam
        self.awayScore = awayScore
        self.datePlayed = datePlayed
    }
}

//import Foundation
//
//struct Match {
//    var homeTeam: String
//    var homeScore: Int
//    var awayTeam: String
//    var awayScore: Int
//}
