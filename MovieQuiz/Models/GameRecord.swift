//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Jedi on 23.05.2023.
//

import Foundation

struct GameRecord: Codable, Comparable {
    let correct: Int
    let total: Int
    let date: Date
    
    
    static func <(lhs: GameRecord, rhs: GameRecord) -> Bool {
             return lhs.correct < rhs.correct
    }
}
