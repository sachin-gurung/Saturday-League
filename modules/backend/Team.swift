import Foundation

struct Team: Identifiable {
    var id: String
    var name: String
    var played: Int
    var wins: Int
    var draws: Int
    var losses: Int
    var goalDifference: Int
    var points: Int

    init?(id: String, data: [String: Any]) {
        guard let name = data["name"] as? String,
              let played = data["played"] as? Int,
              let wins = data["wins"] as? Int,
              let draws = data["draws"] as? Int,
              let losses = data["losses"] as? Int,
              let goalDifference = data["goalDifference"] as? Int,
              let points = data["points"] as? Int else {
            return nil
        }

        self.id = id
        self.name = name
        self.played = played
        self.wins = wins
        self.draws = draws
        self.losses = losses
        self.goalDifference = goalDifference
        self.points = points
    }
}
