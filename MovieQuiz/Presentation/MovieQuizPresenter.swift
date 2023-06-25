
import UIKit
import Foundation

final class MovieQuizPresenter: QuestionFactoryDelegate {
    
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    var correctAnswers = 0
    private var questionFactory: QuestionFactoryProtocol?
    var alertPresenter: AlertPresenterProtocol?
    private var statisticService: StatisticService?
    let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    
    init(viewController: MovieQuizViewController) {
            self.viewController = viewController
        
        statisticService = StatisticServiceImplementation()
            
            questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
            questionFactory?.loadData()
            viewController.showLoadingIndicator()
        }
    
    init(statisticService: StatisticService? = StatisticServiceImplementation()) {
        self.statisticService = statisticService
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
                self.restartGame()
                self.correctAnswers = 0
//                questionFactory?.requestNextQuestion()
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
    
    private func didAnswer(isYes: Bool) { viewController?.showAnswerResult(isCorrect: isYes == currentQuestion?.correctAnswer)
        
    }
    
    func didAnswer(isCorrectAnswer: Bool) {
        if isCorrectAnswer { correctAnswers += 1 }
    }
    
//    func didReceiveNextQuestion(question: QuizQuestion?) {
//                presenter.didReceiveNextQuestion(question: question)
//    }
    
    // MARK: - QuestionFactoryDelegate
    func didLoadDataFromServer() {
//        activityIndicator.isHidden = true // скрываем индикатор загрузки
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailtoLoeadData(with error: Error) {
//        showNetworkError(message: error.localizedDescription)
        let message = error.localizedDescription
                viewController?.showNetworkError(message: message)
    }
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

