//
//  Team.swift
//  Saturday League
//
//  Created by Sachin Gurung on 6/17/24.
//

import Foundation

struct Team: Identifiable {
    var id = UUID()
    var name: String
    var played: Int
    var wins: Int
    var draws: Int
    var losses: Int
    var goalDifference: Int
    var points: Int
}


