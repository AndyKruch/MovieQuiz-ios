//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Andy Kruch on 19.03.23.
//

import Foundation

protocol QuestionFactoryDelegate {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer() // сообщение об успешной загрузке
    func didFailToLoadData(with error: Error) // сообщение об ошибке загрузки
}
