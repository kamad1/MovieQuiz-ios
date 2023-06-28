//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Jedi on 23.05.2023.
//

import Foundation


protocol StatisticService {
    
    func store(correct count: Int, total amount: Int)
    
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
}

final class StatisticServiceImplementation: StatisticService {
    
    private let userDefaults = UserDefaults.standard
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    private var date = Date()
    
    private var correct: Int {
        return userDefaults.integer(forKey: Keys.correct.rawValue)
    }
    private var total: Int {
        return userDefaults.integer(forKey: Keys.total.rawValue)
    }
    
    var totalAccuracy: Double {
        get {
            let correctCount = Double(userDefaults.integer(forKey: Keys.correct.rawValue))
            let total = Double(userDefaults.integer(forKey: Keys.total.rawValue))
            return 100 * (correctCount / total)
        }
    }
    
    private(set) var gamesCount: Int {
        get {
            let count = userDefaults.integer(forKey: Keys.gamesCount.rawValue)
            return count
        }
        set {
            return userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }
            
            return record
        }
        
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        gamesCount += 1
        userDefaults.set(self.total + amount, forKey: Keys.total.rawValue)
        userDefaults.set(self.correct + count, forKey: Keys.correct.rawValue)
        if bestGame < GameRecord(correct: count, total: amount, date: date) {
            self.bestGame = GameRecord(correct: count, total: amount, date: date)
        } else {
            self.bestGame = bestGame
        }
    }
}





//let url = URL(string: "https://imdb-api.com/en/API/MostPopularTVs/k_oxd12p94")

//guard let url = URL(string: "https://imdb-api.com/en/API/MostPopularTVs/k_kiwxbi4y") else { return } // распаковываем адрес
//
//var request = URLRequest(url: url) // создаём запрос
//request.httpBody = Data() // тело запроса в виде Data
//request.httpMethod = "POST" // имя HTTP метода
//request.setValue("test", forHTTPHeaderField: "TEST") // значение заголовка


/*
 1. Самый старый способ, который достался нам в наследство от Objective-C — делегирование.
 
 Про него мы уже рассказывали в предыдущих уроках.
 
 
 protocol MultiplicationDelegate { // описываем протокол делегирования
 func onResult(result: Int)
 }
 
 struct MyStruct: MultiplicationDelegate {
 // пишем функцию, которая будет заниматься перемножением переменных — но теперь она не возвращает результат
 // и принимает наш делегат как аргумент
 func multiplyNumbers(num1: Int, num2: Int, delegate: MultiplicationDelegate) {
 let num3 = num1 * num2
 delegate.onResult(result: num3) // вызываем делегат, чтобы вернуть результат
 }
 
 func runMultiplication() {
 let num1 = 2
 let num2 = 3
 multiplyNumbers(num1: num1, num2: num2, delegate: self) // вызываем функцию умножения, передаём туда делегат — в данном случае это наша структура
 }
 
 // MARK: - MultiplicationDelegate
 
 func onResult(result: Int) { // реализуем метод делегата
 print(result)
 }
 }*/



/*
 2. Второй способ — замыкания.
 
 С ними вы уже тоже знакомы:
 
 
 
 // пишем функцию, которая будет заниматься перемножением переменных — но теперь она не возвращает результат
 // и принимает замыкание как аргумент
 func multiplyNumbers(num1: Int, num2: Int, onResult: (Int) -> Void) {
 let num3 = num1 * num2
 onResult(num3)
 }
 
 let num1 = 2
 let num2 = 3
 
 // Вызываем функцию и передаём замыкание как аргумент
 multiplyNumbers(num1: num1, num2: num2, onResult: { result in
 print(result)
 })
 
 // Эта запись идентична верхней; когда замыкание идёт в конце функции, Xcode сам предложит написать вот так:
 multiplyNumbers(num1: num1, num2: num2) { result in
 print(result)
 }
 
 */

/* 3. Третий способ, самый новый — механизм async/await.
 
 В этом курсе мы с вами не будем его использовать. Механизм добавлен в Swift совсем недавно, и в нём ещё происходят изменения. К тому же, он доступен для использования только начиная с iOS 13. Но мы решили предупредить вас о существовании этого механизма. Если в документации или в примерах кода вы увидите подобные функции, это значит, что они возвращают результат асинхронно.
 
 //    func multiplyNumbers(num1: Int, num2: Int) async -> Int
 
 
 */

/*
 
 Как это устроено
 Для чего же нам были нужны все эти новые термины? Дело в том, что код, работающий с сетью, всегда работает асинхронно, в отдельном потоке и параллельно основной работе приложения. Давайте посмотрим, как написать функцию, которая сделает наш первый запрос:
 
 
 
 
 func sendFirstRequest() {
 // создаём адрес
 guard let url = URL(string: "https://imdb-api.com/en/API/MostPopularTVs/k_kiwxbi4y") else { return }
 // создаём запрос
 let request = URLRequest(url: url)
 
 /*
  Также запросу можно добавить HTTP метод, хедеры и тело запроса.
  
  request.httpMethod = "GET" // здесь можно указать HTTP метод — по умолчанию он GET
  request.allHTTPHeaderFields = [:] // а тут хедеры
  request.httpBody = nil // а здесь тело запроса
  */
 
 // Создаём задачу на отправление запроса в сеть
 let task: URLSessionDataTask = URLSession.shared.dataTask(with: request) { data, response, error in
 // здесь мы обрабатываем ответ от сервера
 
 // data — данные от сервера
 // response — ответ от сервера, содержащий код ответа, хедеры и другую информацию об ответе
 // error — ошибка ответа, если что-то пошло не так
 }
 // Отправляем запрос
 task.resume()
 }
 
 
 
 
 */
