import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {

    var alertPresenter: AlertPresenterProtocol?
    private var currentQuestion: QuizQuestion?
    private var statisticService: StatisticService?
    private var presenter: MovieQuizPresenter?
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    
    // MARK: добавил белый цвет в статусбар
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertPresenter = AlertPresenter(delegate: self)
        presenter = MovieQuizPresenter(viewController: self)
        showLoadingIndicator()
        imageView.layer.cornerRadius = 20
        statisticService = StatisticServiceImplementation()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter?.noButtonClicked()
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter?.yesButtonClicked()
    }
    
    func enabledButtons(isEnabled: Bool) {
        noButton.isEnabled = isEnabled
        yesButton.isEnabled = isEnabled
    }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = true // говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }
    
    func hideLoadingIndicator() {
        activityIndicator.hidesWhenStopped = true
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else { return }
            
            self.presenter?.restartGame()
            self.presenter?.correctAnswers = 0
            
        }
        alertPresenter?.showQuizResult(model: model)
    }
    
    func show(quiz step: QuizStepViewModel) {
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
}






/*
 Mock-данные
 
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 */
//    private func show(quiz result: QuizResultsViewModel) {
//        let alert = UIAlertController(
//            title: result.title,
//            message: result.text,
//            preferredStyle: .alert)
//
//        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
//            guard let self = self else { return }
//            self.currentQuestionIndex = 0
//            self.correctAnswers = 0
//            questionFactory?.requestNextQuestion()
//        }
//
//        alert.addAction(action)
//
//        self.present(alert, animated: true, completion: nil)
//    }

//    private func showNextQuestionOrResults() {
//        imageView.layer.borderColor = UIColor.clear.cgColor
//        if currentQuestionIndex == questionsAmount - 1 {
//            let text = correctAnswers == questionsAmount ?
//            "Поздравляем, Вы ответили на 10 из 10!" :
//            "Вы ответили на \(correctAnswers) из 10, попробуйте ещё раз!"
//            let viewModel = QuizResultsViewModel(
//                title: "Этот раунд окончен!",
//                text: text,
//                buttonText: "Сыграть ещё раз")
//
//            show(quiz: viewModel)
//        } else {
//            currentQuestionIndex += 1
//            self.questionFactory?.requestNextQuestion()
//            //до работка
//            imageView.layer.borderWidth = 0
//
//        }
//    }

//    private var currentQuestionIndex = 0
//    private let questionsAmount: Int = 10
//    private var correctAnswers = 0
//    private var questionFactory: QuestionFactoryProtocol?




//    func didFailtoLoeadData(with error: Error) {
//        showNetworkError(message: error.localizedDescription)
//    }

//    func didLoadDataFromServer() {
//        activityIndicator.isHidden = true // скрываем индикатор загрузки
//        questionFactory?.requestNextQuestion()
//    }


//    func didReceiveNextQuestion(question: QuizQuestion?) {
//        presenter.didReceiveNextQuestion(question: question)
//        guard let question = question else {
//            return
//        }
//        currentQuestion = question
//        let viewModel = presenter.convert(model: question)
//        DispatchQueue.main.async { [weak self] in
//            self?.show(quiz: viewModel)
//        }
//    }
//mark: ДОБАВbЛ СТРОКУ НИЖЕ
//        presenter.viewController = self
//        alertPresenter = AlertPresenter(delegate: self)
//        presenter.alertPresenter = alertPresenter

//        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)

//        questionFactory?.loadData()
//        questionFactory?.requestNextQuestion()

//            self.currentQuestionIndex = 0



//    private func convert(model: QuizQuestion) -> QuizStepViewModel {
//        let questionStep = QuizStepViewModel(
//            image: UIImage(data: model.image) ?? UIImage(),
//            question: model.text,
//            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
//        return questionStep
//    }

//    private func showNextQuestionOrResults() {
//        imageView.layer.borderWidth = 0
//        if presenter.isLastQuestion() {
//            imageView.layer.borderWidth = 8
//            statisticService?.store(correct: correctAnswers, total: presenter.questionsAmount)
//            guard let gamesCount = statisticService?.gamesCount else { return }
//            guard let bestGame = statisticService?.bestGame else { return }
//            guard let totalAccuracy = statisticService?.totalAccuracy else { return }
//            // QuizResultViewModel
//
//            let finalScreen = AlertModel (title: "Этот раунд окончен!",
//                                          message: """
//     Ваш результат: \(correctAnswers)/\(presenter.questionsAmount)
//     Количество сыгранных квизов: \(gamesCount)
//     Рекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))
//     Средняя точность: \(String(format: "%.2f", totalAccuracy))%
//     """ ,
//                                          buttonText: "Сыграть еще раз",
//                                          completion: { [weak self] in
//                guard let self = self else { return }
//                self.imageView.layer.borderWidth = 0
//                self.presenter.resetQuestionIndex()
//                self.correctAnswers = 0
//                self.questionFactory?.requestNextQuestion()
//            })
//            alertPresenter?.showQuizResult(model: finalScreen)
//        } else {
//            presenter.switchToNextQuestion()
//           currentQuestionIndex += 1
//            questionFactory?.requestNextQuestion()
//        }
//
//    }

//    MARK: фиксил Кнопки сделал их не активными при смене вопроса и теперь не возможно ответить больше 10 раз
//    func showAnswerResult(isCorrect: Bool) {
//        enabledButtons(isEnabled: false)
//        if isCorrect {
////            correctAnswers += 1
//            presenter?.didAnswer(isCorrectAnswer: isCorrect)
//        }
////        highlightImageBorder(isCorrect: isCorrect)
//       imageView.layer.masksToBounds = true
//       imageView.layer.borderWidth = 8
//       imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
//            guard let self = self else { return }
//            self.enabledButtons(isEnabled: true)
////            self.presenter.correctAnswers = self.correctAnswers
////            self.presenter.questionFactory = self.questionFactory
//            self.presenter?.showNextQuestionOrResults()
//
//        }
//    }
