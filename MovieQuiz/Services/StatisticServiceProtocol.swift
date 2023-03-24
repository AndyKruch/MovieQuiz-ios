//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Andy Kruch on 24.03.23.
//

import Foundation

protocol StatisticServiceProtocol {
    var totalAccuracy: Double { get }
    var gameCount: Int { get }
    var bestGame: BestGame? { get }
    
    func store(correct: Int, total: Int)
}
