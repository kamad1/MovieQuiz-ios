//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Jedi on 21.05.2023.
//

import Foundation

struct AlertModel{
    let title: String
    var message: String
    let buttonText: String
    let completion: () -> Void
}
