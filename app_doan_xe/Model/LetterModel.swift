//
//  LetterModel.swift
//  mangaquizremake
//
//  Created by Huu Truong Nguyen on 7/30/21.
//

import UIKit
class LetterModel: NSObject {
    var number: Int = 0
    var rightAnswer: String = ""
    
    init(rightAnswer: String, number: Int){
        self.rightAnswer = rightAnswer
        self.number = number
    }
}
