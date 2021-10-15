//
//  WordsItemModel.swift
//  app_doan_xe
//
//  Created by Son on 09/10/2021.
//

import UIKit

class WordsModel: NSObject {

    class WordsModel: NSObject {
        var id: Int = 0
        var answer: String = ""
        var name: String = ""
        var desc: String = ""
        var type: String = ""
        
        func initLoad(_ json:  [String: Any]) -> WordsModel{
            if let temp = json["id"] as? Int { id = temp }
            if let temp = json["answer"] as? String { desc = temp }
            if let temp = json["name"] as? String { name = temp }
            if let temp = json["desc"] as? String { desc = temp }
            if let temp = json["type"] as? String { type = temp }

            return self
        }
    }
}
