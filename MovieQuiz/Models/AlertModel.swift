//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Andy Kruch on 20.03.23.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    
    let completion: () -> Void
}
