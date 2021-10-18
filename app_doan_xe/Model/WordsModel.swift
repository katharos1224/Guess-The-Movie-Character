//
//  WordsItemModel.swift
//  app_doan_xe
//
//  Created by Son on 09/10/2021.
//

import UIKit
import SQLite

class WordsModel: NSObject {
    var id: Int = 0
    var answer: String = ""
    var hint: String = ""
    var type: String = ""
    
    init(id: Int, answer: String, hint: String, type: String) {
        self.id = id
        self.answer = answer
        self.hint = hint
        self.type = type
    }
}
