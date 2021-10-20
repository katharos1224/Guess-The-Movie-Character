//
//  SQLiteService.swift
//  app_doan_xe
//
//  Created by Son on 17/10/2021.
//

import UIKit
import SQLite

class SqliteService:NSObject {
    static let shared: SqliteService = SqliteService()
    var DatabaseRoot:Connection?
    var listData:[WordsModel] = [WordsModel]()
    let users = Table("Words")
    let id = Expression<Int>("id")
    let answer = Expression<String>("answer")
    let hint = Expression<String>("hint")
    let type = Expression<String>("type")
    
    func loadInit(linkPath:String) {
        var dbPath : String = ""
        var dbResourcePath : String = ""
        let fileManager = FileManager.default
        
        do{
            dbPath = try fileManager
                .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("Words.sqlite")
                .path
            if !fileManager.fileExists(atPath: dbPath) {
                dbResourcePath = Bundle.main.path(forResource: "Words", ofType: "sqlite")!
                try fileManager.copyItem(atPath: dbResourcePath, toPath: dbPath)
            }
        }catch{
            print("An error has occured")
        }
        
        do {
            self.DatabaseRoot = try Connection (linkPath)
        } catch {
            print(error)
        }
    }
    
    func getData(closure: @escaping (_ response: [WordsModel]?, _ error: Error?) -> Void) {
        
        listData.removeAll()
        
        if let DatabaseRoot = DatabaseRoot{
            do{
                for user in try DatabaseRoot.prepare(users) {
                    listData.append(WordsModel(id: Int(user[id]), answer: user[answer], hint: user[hint], type: user[type]))
                }
            } catch  {
            }
        }
        NotificationCenter.default.post(name: Notification.Name("LOAD_DATABASE_DONE"), object: nil)
        closure(listData, nil)
        
    }
    
    func getAmountLetterOfRightAnswer(number: Int)->Int{
        return getRightAnswerLetters(number: number).count
    }
    
//    func getWhiteSpace(number: Int)->Int{
//        let rightAnswer = getRightAnswer(number: number)
//        return rightAnswer.count - 1
//    }
    
    func setNumberOfSection(number: Int)->Int{
        let rightAnswer = getRightAnswer(number: number)
        return rightAnswer.count
    }
    
    func getRightAnswer(number: Int)->[String]{
        var word: [String] = []
        for item in listData{
            if item.id == number{
                word = item.answer.components(separatedBy: .whitespaces)
                    break
            }
        }
        return word
    }
    
    func getOriginalRightAnswer(number: Int)->String{
        var word = ""
        for item in listData{
            if item.id == number{
                word = item.answer
                break
            }
        }
        return word
    }
    
    func getRightAnswerLettersIncludeWhiteSpace(number: Int)->[String]{
        var letter:[String] = []
        for item in listData{
            if item.id == number{
                let word = item.answer
                for item in 0...word.count-1{
                    let index = word.index(word.startIndex, offsetBy: item)
                    letter.append(String(word[index]).lowercased())
                }
                
                return letter
            }
        }
        return []
    }
    
    func getRightAnswerLetters(number: Int)->[String]{
        var rightAnswerLetters: [String] = []
        let rightAnswerLettersIncludeWhiteSpace = getRightAnswerLettersIncludeWhiteSpace(number: number)
        for item in rightAnswerLettersIncludeWhiteSpace{
            if item == " "{
                continue
            }
            rightAnswerLetters.append(item)
        }
        return rightAnswerLetters
    }
    
    func setNumberOfSection0(number: Int)->Int{
        let firstWord = getRightAnswer(number: number)[0]
        return firstWord.count
    }
    
    func setNumberOfSection1(number: Int)->Int{
        let secondWord = getRightAnswer(number: number)[1]
        return secondWord.count
    }
    
    func setNumberOfSection2(number: Int)->Int{
        let thirdWord = getRightAnswer(number: number)[2]
        return thirdWord.count
    }
    
    func setNumberOfSection3(number: Int)->Int{
        let fourthWord = getRightAnswer(number: number)[3]
        return fourthWord.count
    }
    
    func setNumberOfSection4(number: Int)->Int{
        let fifthWord = getRightAnswer(number: number)[4]
        return fifthWord.count
    }
    func randomizeAvailableLetters(tileArraySize: Int) -> Array<String> {
      let alphabet: [String] = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "&", "-", ",", ".", "‘", "2", "1", "7", "9", "8", "0", "3", "4" ]
      var availableTiles = [String]()
        for _ in 0..<tileArraySize {
        let rand = Int(arc4random_uniform(39))
        availableTiles.append(alphabet[rand])
      }
      return(availableTiles)
    }
    
    func getAmountOfRandomLetters(number: Int)->Int{
        let amountOfRightAnswer = getAmountLetterOfRightAnswer(number: number)
        return 21 - amountOfRightAnswer
    }
    
    func shuffleLetters(number: Int)->[LetterModel]{
        var randomAndRightAnswerLetters: [LetterModel] = [LetterModel]()
        let amountOfRandomLetters = getAmountOfRandomLetters(number: number)
        let randomLetters = randomizeAvailableLetters(tileArraySize: amountOfRandomLetters)
        let rightAnswerLetters = getRightAnswerLetters(number: number)
        var letters = randomLetters + rightAnswerLetters
        letters.shuffle()
        for item in 0...letters.count-1{
            randomAndRightAnswerLetters.append(LetterModel(rightAnswer: letters[item], number: item))
        }
        return randomAndRightAnswerLetters
    }
}

