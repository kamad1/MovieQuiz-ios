

import XCTest
@testable import MovieQuiz

final class MovieQuizControllerMock: MovieQuizViewControllerProtocol {
    var alertPresenter: MovieQuiz.AlertPresenterProtocol?
    
    func enabledButtons(isEnabled: Bool) {
        
    }
        
    func show(quiz step: MovieQuiz.QuizStepViewModel) {
        
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        
    }
    
    func showLoadingIndicator() {
        
    }
    
    func hideLoadingIndicator() {
        
    }
    
    func showNetworkError(message: String) {
        
    }
}

final class MovieQuizPresenterTests: XCTestCase {
    
    override func setUpWithError() throws {
       try super.setUpWithError()
    }

    override func tearDownWithError() throws {
       try super.tearDownWithError()
    }

    func testPresenterConvertModel() throws {
            let viewControllerMock = MovieQuizControllerMock()
            let sut = MovieQuizPresenter(viewController: viewControllerMock)
            
            let emptyData = Data()
            let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
            let viewModel = sut.convert(model: question)
            
             XCTAssertNotNil(viewModel.image)
            XCTAssertEqual(viewModel.question, "Question Text")
            XCTAssertEqual(viewModel.questionNumber, "1/10")
        }
}






//func testPerformanceExample() throws {
//    // This is an example of a performance test case.
//    measure {
//        // Put the code you want to measure the time of here.
//    }
//}

//func testExample() throws {
//
//}
