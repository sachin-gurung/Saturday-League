import Foundation
import FirebaseFirestore

struct Match: Identifiable {
    var id: String
    var homeTeam: String
    var homeScore: Int
    var awayTeam: String
    var awayScore: Int
    var datePlayed: Date

    init?(id: String, data: [String: Any]) {
        guard let homeTeam = data["homeTeam"] as? String,
              let homeScore = data["homeScore"] as? Int,
              let awayTeam = data["awayTeam"] as? String,
              let awayScore = data["awayScore"] as? Int,
              let datePlayedTimestamp = data["datePlayed"] as? Timestamp else { return nil }

        self.id = id
        self.homeTeam = homeTeam
        self.homeScore = homeScore
        self.awayTeam = awayTeam
        self.awayScore = awayScore
        self.datePlayed = datePlayedTimestamp.dateValue()
    }
}
