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
    public var DatabaseRoot: Connection?
    var listData: [WordsModel] = [WordsModel]()
    let users = Table("Words")
    let id = Expression<Int>("id")
    let answer = Expression<String>("answer")
    let hint = Expression<String>("hint")
    let type = Expression<String>("type")
    
    func loadInit(linkPath: String) {
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
    
    func getAmountCharacterOfFullAnswer(number: Int)->Int{
        return getCharactersOfFullAnswer(number: number).count
        
    }
    
    func getAmountLetterExcludeSpecialCharacters(number: Int)->Int{
        return getOnlyLetters(number: number).count
        
    }
    
//    func getRightAnswer(number: Int)->[String]{
//        var word: [String] = []
//        for item in listData {
//            if item.id == number + 1 {
//                word = item.answer.components(separatedBy: [" ", "&", "-", ",", ".", "'"])  //fix this
//                break
//            }
//        }
//        return word
//    }
    
    func getCharactersOfFullAnswer(number: Int)->[String] {
        var letter:[String] = []
        for item in listData {
            if item.id == number {
                let word = item.answer
                for item in 0...word.count - 1 {
                    let index = word.index(word.startIndex, offsetBy: item)
                    letter.append(String(word[index]).uppercased())
                }
                
                return letter
            }
        }
        return []
    }
    
    func getOnlyLetters(number: Int)->[String] {
        var rightAnswerLetters: [String] = []
        let rightAnswerLettersIncludeWhiteSpace = getCharactersOfFullAnswer(number: number)
        for item in rightAnswerLettersIncludeWhiteSpace {
            if item == " " || item == "&" || item == "-" || item == "," || item == "." || item == "'" {
                continue
            }
            rightAnswerLetters.append(item.uppercased())
        }
        
        return rightAnswerLetters
    }
    
    func getSpecialCharacterIndex(number: Int)->[Int] {
        var specialCharacterIndex: [Int] = []
        let fullAnswer = getCharactersOfFullAnswer(number: number)
        for item in 0...fullAnswer.count - 1 {
            if item == 0 {
                continue
            }
            if fullAnswer[item] == " " || fullAnswer[item] == "&" || fullAnswer[item] == "-" || fullAnswer[item] == "," || fullAnswer[item] == "." || fullAnswer[item] == "'" {
                specialCharacterIndex.append(item)
            }
        }
        return specialCharacterIndex
    }
    
    func getCharacterIndex(number: Int)->[Int] {
        var characterIndex: [Int] = []
        let fullAnswer = getCharactersOfFullAnswer(number: number)
        for item in 0...fullAnswer.count - 1 {
            if item == 0 {
                continue
            }
            characterIndex.append(item)
        }
        return characterIndex
    }
    
    func randomizeAvailableLetters(tileArraySize: Int) -> Array<String> {
        let alphabet: [String] = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        let specialCharacter: [String] = [" ", "&", "-", ",", ".", "'"]
        var availableTiles = [String]()
        for _ in 0..<tileArraySize {
            let rand = Int(arc4random_uniform(UInt32(alphabet.count)))
            availableTiles.append(alphabet[rand])
        }
        return(availableTiles)
    }
    
    func getAmountOfRandomLetters(number: Int)->Int{
        let amountOfRightAnswer = getAmountLetterExcludeSpecialCharacters(number: number)
        return 21 - amountOfRightAnswer
    }
    
//    func setNumberOfSection(number: Int)->Int{
//        let rightAnswer = getRightAnswer(number: number)
//        return rightAnswer.count
//    }
    
    
    
    func getFullAnswer(number: Int)->String {
        var word = ""
        for item in listData {
            if item.id == number {
                word = item.answer
                break
            }
        }
        return word
    }
    
    func shuffleLetters(number: Int)->[LetterModel] {
        var randomLettersAndAnswerLetters: [LetterModel] = [LetterModel]()
        let amountOfRandomLetters = getAmountOfRandomLetters(number: number)
        let randomLetters = randomizeAvailableLetters(tileArraySize: amountOfRandomLetters)
        let rightAnswerLetters = getCharactersOfFullAnswer(number: number)
        var letters = randomLetters + rightAnswerLetters
        letters.shuffle()
        for item in 0...letters.count - 1 {
            
            if letters[item] == " " || letters[item] == "&" || letters[item] == "-" || letters[item] == "," || letters[item] == "." || letters[item] == "'" {
                continue
            }
            randomLettersAndAnswerLetters.append(LetterModel(rightAnswer: letters[item], number: item))
        }
        return randomLettersAndAnswerLetters
    }
    
//    func getCharacterByIndex(number: Int)->String {
//        var char = ""
//        for item in getSpecialCharacterIndex(number: number) {
//            let character = getCharactersOfFullAnswer(number: number)
//            if character[item] == " " || character[item] == "&" || character[item] == "-" || character[item] == "," || character[item] == "." || character[item] == "'" {
//                char = character[item]
//                break
//            }
//        }
//        return char
//    }
}

