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
}
