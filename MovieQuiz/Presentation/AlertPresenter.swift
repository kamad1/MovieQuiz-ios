//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Jedi on 21.05.2023.
//
import UIKit
import Foundation




class AlertPresenter: AlertPresenterProtocol {
    
    weak var delegate: UIViewController?
    
    init (delegate: UIViewController){
        self.delegate = delegate
    }
    
    func showQuizResult(model: AlertModel) {
        let alert = UIAlertController(
            title: model.title,
            message: model.massege,
            preferredStyle: .alert)
        let action = UIAlertAction(
            title: model.buttonText,
            style: .default) { _ in
                model.completion()}
        
        alert.addAction(action)
        
        delegate?.present(alert, animated: true, completion: nil)
    }
}
 
