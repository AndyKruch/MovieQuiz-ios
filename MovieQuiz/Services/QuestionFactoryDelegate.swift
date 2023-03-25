//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Andy Kruch on 19.03.23.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
