
import UIKit
//import Foundation

final class MovieQuizPresenter: QuestionFactoryDelegate {
    
    let questionsAmount: Int = 10
    var currentQuestion: QuizQuestion?
    var correctAnswers = 0
//    weak var viewController: MovieQuizViewController?
    weak var viewController: MovieQuizViewControllerProtocol?
    private var questionFactory: QuestionFactoryProtocol?
    private var statisticService: StatisticService?
    private var currentQuestionIndex: Int = 0
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        
        statisticService = StatisticServiceImplementation()
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
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
    
    func proceedToNextQuestionOrResults() {
        
        if self.isLastQuestion() {
            statisticService?.store(correct: correctAnswers, total: self.questionsAmount)
            
            guard let gamesCount = statisticService?.gamesCount else { return }
            guard let bestGame = statisticService?.bestGame else { return }
            guard let totalAccuracy = statisticService?.totalAccuracy else { return }
            
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
                
                self.restartGame()
                self.correctAnswers = 0
                
            })
            viewController?.alertPresenter?.showQuizResult(model: finalScreen)
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
    

    func didAnswer(isCorrectAnswer: Bool) {
        if isCorrectAnswer { correctAnswers += 1 }
    }
    
    func proceedWithAnswer(isCorrect: Bool) {
        viewController?.enabledButtons(isEnabled: false)
        if isCorrect {
            self.didAnswer(isCorrectAnswer: isCorrect)
        }
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            viewController?.enabledButtons(isEnabled: true)
            self.proceedToNextQuestionOrResults()
        }
    }
    
    // MARK: - QuestionFactoryDelegate
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailtoLoeadData(with error: Error) {
        let message = error.localizedDescription
        viewController?.showNetworkError(message: message)
    }
    
    private func didAnswer(isYes: Bool) { self.proceedWithAnswer(isCorrect: isYes == currentQuestion?.correctAnswer)
    }
    
}

//    init(statisticService: StatisticService? = StatisticServiceImplementation()) {
//        self.statisticService = statisticService
//    }

//    private func didAnswer(isYes: Bool) {
//       guard let currentQuestion = currentQuestion else {
//            return
//        }
//
//        let givenAnswer = isYes
//
//        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
//    }

//    func didReceiveNextQuestion(question: QuizQuestion?) {
//                presenter.didReceiveNextQuestion(question: question)
//    }

