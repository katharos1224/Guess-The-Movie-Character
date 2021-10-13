//
//  WordsItemModel.swift
//  app_doan_xe
//
//  Created by Son on 09/10/2021.
//

import UIKit

class WordsItemModel: NSObject {

    class WordsItemModel: NSObject {
        var id: Int = 0
        var cover: String = ""
        var name: String = ""

        func initLoad(_ json:  [String: Any]) -> WordsItemModel{
            if let temp = json["id"] as? Int { id = temp }
            if let temp = json["cover"] as? String { cover = temp }
            if let temp = json["name"] as? String { name = temp }

            return self
        }
    }
}
