
import UIKit
import Foundation

final class MovieQuizPresenter {
    
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    var correctAnswers = 0
    var questionFactory: QuestionFactoryProtocol?
    var alertPresenter: AlertPresenterProtocol?
    private var statisticService: StatisticService?
    let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    
    init(statisticService: StatisticService? = StatisticServiceImplementation()) {
        self.statisticService = statisticService
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    func showNextQuestionOrResults() {
//        imageView.layer.borderWidth = 0
        if self.isLastQuestion() {
//            imageView.layer.borderWidth = 8
            statisticService?.store(correct: correctAnswers, total: self.questionsAmount)
            guard let gamesCount = statisticService?.gamesCount else { return }
            guard let bestGame = statisticService?.bestGame else { return }
            guard let totalAccuracy = statisticService?.totalAccuracy else { return }
            // QuizResultViewModel    
            
            let finalScreen = AlertModel (title: "Этот раунд окончен!",
                                          message: """
     Ваш результат: \(correctAnswers)/\(self.questionsAmount)
     Количество сыгранных квизов: \(gamesCount)
     Рекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))
     Средняя точность: \(String(format: "%.2f", totalAccuracy))%
     """ ,
                                          buttonText: "Сыграть еще раз",
                                          completion: { [weak self] in
                guard let self = self else { return }
//                self.imageView.layer.borderWidth = 0
                self.resetQuestionIndex()
                self.correctAnswers = 0
                questionFactory?.requestNextQuestion()
            })
            alertPresenter?.showQuizResult(model: finalScreen)
        } else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
         
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return questionStep
    }
    func yesButtonClicked() {
        didAnswer(isYes: true)
        
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
        
    }
    
    private func didAnswer(isYes: Bool) { viewController?.showAnswerResult(isCorrect: isYes == currentQuestion?.correctAnswer) }
//    private func didAnswer(isYes: Bool) {
//       guard let currentQuestion = currentQuestion else {
//            return
//        }
//
//        let givenAnswer = isYes
//
//        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
//    }
}

