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
    
    func getAmountLetterOfRightAnswer(number: Int)->Int{
        return getRightAnswerLettersIncludeWhiteSpace(number: number).count
        
    }
    
    func getAmountLetterOfRightAnswerExcludeSpecialCharacters(number: Int)->Int{
        return getRightAnswerLetters(number: number).count
        
    }
    
    func getRightAnswer(number: Int)->[String]{
        var word: [String] = []
        for item in listData{
            if item.id == number + 1 {
                word = item.answer.components(separatedBy: .whitespaces)
                break
            }
        }
        return word
    }
    
    func getRightAnswerLettersIncludeWhiteSpace(number: Int)->[String] {
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
    
    func getRightAnswerLetters(number: Int)->[String] {
        var rightAnswerLetters: [String] = []
        let rightAnswerLettersIncludeWhiteSpace = getRightAnswerLettersIncludeWhiteSpace(number: number)
        for item in rightAnswerLettersIncludeWhiteSpace {
            if item == " " || item == "&" || item == "-" || item == "," || item == "." || item == "'" {
                continue
            }
            rightAnswerLetters.append(item.uppercased())
        }
        
        return rightAnswerLetters
    }
    
    func getWhiteSpaceLocation(number: Int)->[Int] {
        var whiteSpaceLocation: [Int] = []
        let rightAnswerLettersIncludeWhiteSpace = getRightAnswerLettersIncludeWhiteSpace(number: number)
        for item in 0...rightAnswerLettersIncludeWhiteSpace.count - 1 {
            if rightAnswerLettersIncludeWhiteSpace[item] == " " || rightAnswerLettersIncludeWhiteSpace[item] == "&" || rightAnswerLettersIncludeWhiteSpace[item] == "-" || rightAnswerLettersIncludeWhiteSpace[item] == "," || rightAnswerLettersIncludeWhiteSpace[item] == "." || rightAnswerLettersIncludeWhiteSpace[item] == "'" {
                if item == 0 {
                    continue
                }
                whiteSpaceLocation.append(item )
            }
        }
        return whiteSpaceLocation
    }
    
    func randomizeAvailableLetters(tileArraySize: Int) -> Array<String> {
        let alphabet: [String] = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "0", "1", "2", "3", "4", "7", "8", "9"]
        var availableTiles = [String]()
        for _ in 0..<tileArraySize {
            let rand = Int(arc4random_uniform(33))
            availableTiles.append(alphabet[rand])
        }
        return(availableTiles)
    }
    
    func getAmountOfRandomLetters(number: Int)->Int{
        let amountOfRightAnswer = getAmountLetterOfRightAnswerExcludeSpecialCharacters(number: number)
        return 21 - amountOfRightAnswer
    }
    
    func setNumberOfSection(number: Int)->Int{
        let rightAnswer = getRightAnswer(number: number)
        return rightAnswer.count
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
    
    func shuffleLetters(number: Int)->[LetterModel] {
        var randomAndRightAnswerLetters: [LetterModel] = [LetterModel]()
        let amountOfRandomLetters = getAmountOfRandomLetters(number: number)
        let randomLetters = randomizeAvailableLetters(tileArraySize: amountOfRandomLetters)
        let rightAnswerLetters = getRightAnswerLettersIncludeWhiteSpace(number: number)
        var letters = randomLetters + rightAnswerLetters
        letters.shuffle()
        for item in 0...letters.count - 1 {
            randomAndRightAnswerLetters.append(LetterModel(rightAnswer: letters[item], number: item))
        }
        //        //Exclude Special Characters?
        //        if <#condition#> {
        //            <#code#>
        //        }
        return randomAndRightAnswerLetters
    }
    
    func shuffleLettersExcludeSpecialCharacters(number: Int)->[LetterModel] {
        var randomAndRightAnswerLetters: [LetterModel] = [LetterModel]()
        let amountOfRandomLetters = getAmountOfRandomLetters(number: number)
        let randomLetters = randomizeAvailableLetters(tileArraySize: amountOfRandomLetters)
        let rightAnswerLetters = getRightAnswerLetters(number: number)
        var letters = randomLetters + rightAnswerLetters
        letters.shuffle()
        for item in 0...letters.count - 1 {
            randomAndRightAnswerLetters.append(LetterModel(rightAnswer: letters[item], number: item))
        }
        //        //Exclude Special Characters?
        //        if <#condition#> {
        //            <#code#>
        //        }
        return randomAndRightAnswerLetters
    }
}

