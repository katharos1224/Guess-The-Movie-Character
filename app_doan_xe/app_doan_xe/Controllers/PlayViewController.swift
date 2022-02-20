//
//  PlayViewController.swift
//  app_doan_xe
//
//  Created by Son on 08/10/2021.
//

import UIKit
import SwiftKeychainWrapper
import AVFoundation

extension NSObject {
    func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }
    var className: String {
        return String(describing: type(of: self))
    }
    class var className: String {
        return String(describing: self)
    }
}

class PlayViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var totalAnsweredLabel: UILabel!
    @IBOutlet weak var currentQuestion: UILabel!
    @IBOutlet weak var coinLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var viewBar: UIView!
    
    @IBAction func buyAction() {
    }
    @IBAction func revealOneLetterAction() {
    }
    @IBAction func revealAnswerAction() {
    }
    @IBAction func revealHintAction() {
    }
    @IBAction func backAction() {
        dismiss(animated: true)
    }
    
    var level = 0
    var coin = 0
    var totalAnswered = 0
    var numberQuestion = 0
    var listData:[WordsModel] = [WordsModel]()
    var listSpecialCharacter: [Int] = []
    var listRemainLetter: [LetterModel] = [LetterModel]()
    var listExcludeSpecialLetter: [LetterModel] = [LetterModel]()
    var listLettersOfRightAnswer: [String] = []
    var letter = ""
    var number = 0
    var listNumber: [Int] = []
    var letterArr: [String] = []
    var didSendDataScore: ((Int) -> Void)?
    var didSendDataLevel: ((Int) -> Void)?
    var isTrueAnswer = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: ImagePlayCLVCell.className, bundle: nil), forCellWithReuseIdentifier: ImagePlayCLVCell.className)
        collectionView.register(UINib(nibName: AnswerWhiteSpaceCLVCell.className, bundle: nil), forCellWithReuseIdentifier: AnswerWhiteSpaceCLVCell.className)
        collectionView.register(UINib(nibName: AnswerCLVCell.className, bundle: nil), forCellWithReuseIdentifier: AnswerCLVCell.className)
        collectionView.register(UINib(nibName: GuessCLVCell.className, bundle: nil), forCellWithReuseIdentifier: GuessCLVCell.className)
        // Do any additional setup after loading the view.
        
        listExcludeSpecialLetter = SqliteService.shared.shuffleLettersExcludeSpecialCharacters(number: numberQuestion + 1)
        listRemainLetter = SqliteService.shared.shuffleLetters(number: numberQuestion + 1)
        listSpecialCharacter = SqliteService.shared.getSpecialCharacterLocation(number: numberQuestion + 1)
        listData = SqliteService.shared.listData
        
        let backgroundImages: [UIImage] = [#imageLiteral(resourceName: "bggreen"), #imageLiteral(resourceName: "bgblue")]
        backgroundImage.image = backgroundImages.randomElement()
        
        if backgroundImage.image == #imageLiteral(resourceName: "bgblue") {
            viewBar.backgroundColor = #colorLiteral(red: 0.4072989821, green: 0.9387814403, blue: 0.9059766531, alpha: 0.3)
            levelLabel.textColor = UIColor.black
            currentQuestion.textColor = UIColor.black
        } else if backgroundImage.image == #imageLiteral(resourceName: "bggreen") {
            viewBar.backgroundColor = #colorLiteral(red: 0.7474684119, green: 0.7131774426, blue: 0, alpha: 0.3020593504)
            levelLabel.textColor = #colorLiteral(red: 0.3411329985, green: 0.00358922733, blue: 0.2856191993, alpha: 1)
            currentQuestion.textColor = #colorLiteral(red: 0.3411329985, green: 0.00358922733, blue: 0.2856191993, alpha: 1)
        }
        
        for index in 0...6 {
            if numberQuestion >= 70 * index && numberQuestion <= 70 * index + 70 - 1 {
                level = index + 1
                levelLabel.text = "Level \(level)"
                currentQuestion.text = "\((numberQuestion + 1) - 70 * index)/70"
            }
        }
        
        totalAnsweredLabel.text = "\(totalAnswered)"
        coinLabel.text = "\(coin)"
    }
    
    
    
}

extension PlayViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else if section == 1 {
            let amountLetter = SqliteService.shared.getAmountLetterOfRightAnswer(number: numberQuestion + 1)
            return amountLetter
        }
        else {
            return 21
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImagePlayCLVCell.className, for: indexPath) as! ImagePlayCLVCell
            cell.imageCell.image = UIImage.init(imageLiteralResourceName: "\(numberQuestion + 1)")
            cell.layer.cornerRadius = 20
            cell.imageCell.layer.cornerRadius = 20
            cell.clipsToBounds = true
            return cell
        }
        else if indexPath.section == 1 {
            
            for item in listSpecialCharacter {
                if indexPath.item == item {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnswerWhiteSpaceCLVCell", for: indexPath) as! AnswerWhiteSpaceCLVCell
                    cell.lbLetter.text = "@"
                    return cell
                }
            }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnswerCLVCell", for: indexPath) as! AnswerCLVCell
            cell.answerLetterLabel.text = ""
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GuessCLVCell.className, for: indexPath) as! GuessCLVCell
            cell.guessLetterLabel.text = listExcludeSpecialLetter[indexPath.item].rightAnswer
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            
            let answerCell = collectionView.cellForItem(at: indexPath) as! AnswerCLVCell
            
            if answerCell.answerLetterLabel.text!.contains("") || isHintLetter(indexPath: indexPath) {
                
            }
            else {
                answerCell.answerLetterLabel.text = ""
                answerCell.answerLetterLabel.textColor = .clear
                
                let guessCell = collectionView.cellForItem(at: IndexPath(item: listNumber[indexPath.item], section: 2)) as! GuessCLVCell
                
                guessCell.guessLetterLabel.text = letterArr[indexPath.item]
                //set arrays to default
                listRemainLetter[listNumber[indexPath.item]].rightAnswer = letterArr[indexPath.item]
                letterArr[indexPath.item] = ""
                listNumber[indexPath.item] = -1
            }
        }
        
        else if indexPath.section == 2 {
            let guessCell = collectionView.cellForItem(at: indexPath) as! GuessCLVCell
            
            if guessCell.guessLetterLabel.text == "" {
                
            }
            else {
                if isFullCellInRightAnswer() {
                    
                }
                else {
                    letter = listRemainLetter[indexPath.item].rightAnswer
                    number = listRemainLetter[indexPath.item].number
                    
//                    letterArr.append(letter)
//                    listNumber.append(number)
                    listRemainLetter[indexPath.item].rightAnswer = ""
                    
                    //set LetterArr
                    insertLetterArr(letter: letter)
                    
                    //set ListNumber
                    insertListNumber(number: number)
                                        
                    guessCell.guessLetterLabel.text = ""
                    
                    var isWhiteSpace = false
                    let index = getIndexPathOfEmptyTextCell(in: self.collectionView)!
                    for item in listSpecialCharacter {
                        if item == index.item {
                            isWhiteSpace = true
                            let rightAnswerCell = self.collectionView.cellForItem(at: index) as! AnswerWhiteSpaceCLVCell
                            rightAnswerCell.lbLetter.text = letter
                        }
                    }
                    if isWhiteSpace {
                        isWhiteSpace = false
                    }
                    else {
                        let rightAnswerCell = self.collectionView.cellForItem(at: index) as! AnswerCLVCell
                        rightAnswerCell.answerLetterLabel.text = letter
                        rightAnswerCell.answerLetterLabel.textColor = .white
                    }
                }
            }
        }
    }
    
    func isEmptyListNumber(listNumber: [Int])->Bool {
        if listNumber.count == 0 {
            return false
        }
        else {
            for item in 0...listNumber.count-1 {
                if listNumber[item] == -1 {
                    return true
                }
            }
        }
        
        return false
    }
    
    func isEmptyLetterArr(letterArr: [String])->Bool {
        if letterArr.count == 0 {
            return false
        }
        else {
            for item in 0...letterArr.count-1 {
                if letterArr[item] == "" {
                    return true
                }
            }
        }
        
        return false
    }
    
    func insertLetterArr(letter: String) {
        //set LetterArr
        if isEmptyLetterArr(letterArr: letterArr) {
            for item in 0...letterArr.count-1 {
                if letterArr[item] == "" {
                    letterArr[item] = letter
                    break
                }
            }
        }
        else {
            self.letterArr.append(letter)
        }
    }
    
    func insertListNumber(number: Int) {
        //set ListNumber
        if isEmptyListNumber(listNumber: listNumber) {
            for item in 0...listNumber.count-1 {
                if listNumber[item] == -1 {
                    listNumber[item] = number
                    break
                }
            }
        }
        else {
            listNumber.append(number)
        }
    }
    
    func changeCoin(coin: String){
        coinLabel.text = String(coin)
        KeychainWrapper.standard.removeObject(forKey: "coin")
        KeychainWrapper.standard.set(Int(coin)!, forKey: "coin")
    }
    
//    func notEnoughCoin(){
//        let popVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "NotEnoughCoinsViewController") as! NotEnoughCoinsViewController
//        self.addChild(popVC)
//        popVC.view.frame = self.view.frame
//        self.view.addSubview(popVC.view)
//        popVC.didMove(toParent: self)
//        popVC.didSendDataCoinPlus = { [weak self] coin in
//                guard let self = self else { return }
//            self.coin += coin
//            self.changeCoin(coin: String(self.coin))
//        }
//    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        return UICollectionReusableView()
    }
    
    func whenAnswerCorrect() {
        let correctAnswer = SqliteService.shared.getOriginalRightAnswer(number: numberQuestion)
        
        //next to new question
        KeychainWrapper.standard.removeObject(forKey: "number")
        KeychainWrapper.standard.set(numberQuestion, forKey: "number")
        numberQuestion = KeychainWrapper.standard.integer(forKey: "number")! + 1

        //increase coin
        coin += 10
        KeychainWrapper.standard.removeObject(forKey: "coin")
        KeychainWrapper.standard.set(coin, forKey: "coin")
        
//        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "CorrectViewController") as! CorrectViewController
        
        vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        vc.coin += coin
//        vc.isMuteSound = isMuteSound
//        vc.isMuteMusic = isMuteMusic
        self.present(vc, animated: true, completion: nil)
        
        listRemainLetter = SqliteService.shared.shuffleLetters(number: numberQuestion + 1)
        listSpecialCharacter = SqliteService.shared.getSpecialCharacterLocation(number: numberQuestion + 1)
        listNumber.removeAll()
        letterArr.removeAll()
        listLettersOfRightAnswer.removeAll()
        totalAnswered += 1
    }
    
    func isHintLetter(indexPath: IndexPath)->Bool {
        let cell = collectionView.cellForItem(at: indexPath) as! AnswerCLVCell
        if ((cell.answerLetterLabel.textColor == .clear) ) {
            return true
        }
        else {
            return false
        }
    }
    
    func isFullCellInRightAnswer()->Bool {
        let amountLetter = SqliteService.shared.getAmountLetterOfRightAnswer(number: numberQuestion + 1 )
        var isWhiteSpace = false
        for item in 0...amountLetter - 1 {
            for whiteSpaceItem in listSpecialCharacter {
                if item == whiteSpaceItem {
                    isWhiteSpace = true
                    let cell = collectionView.cellForItem(at: IndexPath(item: whiteSpaceItem, section: 0)) as! AnswerCLVCell
                    if (cell.answerLetterLabel.text == "") {
                        return false
                    }
                    if item == amountLetter - 1 {
                        return true
                    }
                    break
                }
            }
            if isWhiteSpace {
                isWhiteSpace = false
                continue
            }
            let cell = collectionView.cellForItem(at: IndexPath(item: item, section: 1)) as! AnswerCLVCell
            if (cell.answerLetterLabel.text == "") {
                return false
            }
            if item == amountLetter - 1 {
                return true
            }
        }
        return false
    }
    
    func isRightAnswer()->Bool {
        let amountLetter = SqliteService.shared.getAmountLetterOfRightAnswer(number: numberQuestion + 1)
        var isWhiteSpace = false
        for item in 0...amountLetter - 1 {
            for whiteSpaceItem in listSpecialCharacter {
                if item == whiteSpaceItem {
                    isWhiteSpace = true
                    let cell = collectionView.cellForItem(at: IndexPath(item: whiteSpaceItem, section: 1)) as! AnswerCLVCell
                    listLettersOfRightAnswer.append(cell.answerLetterLabel.text ?? "")
                    if item == amountLetter - 1{
                        let rightAnswer = SqliteService.shared.getRightAnswerLetters(number: numberQuestion + 1)
                        if listLettersOfRightAnswer == rightAnswer{
                            return true
                        }
                    }
                    break
                }
            }
            if isWhiteSpace {
                isWhiteSpace = false
                continue
            }
            let cell = collectionView.cellForItem(at: IndexPath(item: item, section: 1)) as! AnswerCLVCell
            listLettersOfRightAnswer.append(cell.answerLetterLabel.text ?? "")
            if item == amountLetter - 1{
                let rightAnswer = SqliteService.shared.getRightAnswerLetters(number: numberQuestion + 1)
                if listLettersOfRightAnswer == rightAnswer{
                    isTrueAnswer = true
                    return true
                }
            }
        }
        return false
    }
    
    func getIndexPathOfEmptyTextCell(in collectionView: UICollectionView) -> IndexPath? {
        let amountLetter = SqliteService.shared.getAmountLetterOfRightAnswer(number: numberQuestion + 1)
        var isWhiteSpace = false
        for item in 0...amountLetter - 1 {
            for whiteSpaceItem in listSpecialCharacter {
                if item == whiteSpaceItem {
                    isWhiteSpace = true
                    let cell = collectionView.cellForItem(at: IndexPath(item: whiteSpaceItem, section: 0)) as! AnswerCLVCell
                    if (cell.answerLetterLabel.text == "") {
                        return IndexPath(item: item, section: 0)
                    }
                    break
                }
            }
            if isWhiteSpace {
                isWhiteSpace = false
                continue
            }
            let cell = collectionView.cellForItem(at: IndexPath(item: item, section: 1)) as! AnswerCLVCell
            if (cell.answerLetterLabel.text == "") {
                return IndexPath(item: item, section: 0)
            }
        }
        return IndexPath(item: 0, section: 0)
    }
}



extension PlayViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 10.0, right: 0.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.userInterfaceIdiom == .pad{
            return CGSize(width: UIScreen.main.bounds.width, height: 50)
        }
        return CGSize(width: 50, height: 50)
    }
    
    func centerItemsInCollectionView(cellWidth: Double, numberOfItems: Double, spaceBetweenCell: Double, collectionView: UICollectionView) -> UIEdgeInsets {
        let totalWidth = cellWidth * numberOfItems
        let totalSpacingWidth = spaceBetweenCell * (numberOfItems - 1)
        let leftInset = (collectionView.frame.width - CGFloat(totalWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset
        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
    }
}


