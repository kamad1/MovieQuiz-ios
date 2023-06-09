//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Jedi on 21.05.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailtoLoeadData(with error: Error )
}
