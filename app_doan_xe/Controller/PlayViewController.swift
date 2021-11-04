//
//  PlayViewController.swift
//  app_doan_xe
//
//  Created by Son on 08/10/2021.
//

import UIKit
import SwiftKeychainWrapper
import AVFoundation
//import GoogleMobileAds

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
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var coinLabel: UILabel!
    @IBAction func shareAction() {
    }
    @IBAction func revealAnswerAction() {
    }
    @IBAction func watchHintAction() {
    }
    @IBAction func backAction() {
        dismiss(animated: true)
    }
    
    var coin = 0
    //var image: UIImage!
    var numberQuestion = 0
    var listData:[WordsModel] = [WordsModel]()
    var listLetter: [LetterModel] = [LetterModel]()
//    var isCheckAnswer = false
//    var isTrueAnswer = false
    var listWhiteSpace: [Int] = []
    var listRemainLetter: [LetterModel] = [LetterModel]()
    var letter = ""
    var number = 0
    var listNumber: [Int] = []
    var letterArr: [String] = []
    var didSendDataScore: ((Int) -> Void)?
    var didSendDataLevel: ((Int) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: ImagePlayCLVCell.className, bundle: nil), forCellWithReuseIdentifier: ImagePlayCLVCell.className)
        collectionView.register(UINib(nibName: AnswerCLVCell.className, bundle: nil), forCellWithReuseIdentifier: AnswerCLVCell.className)
        collectionView.register(UINib(nibName: GuessCLVCell.className, bundle: nil), forCellWithReuseIdentifier: GuessCLVCell.className)
        // Do any additional setup after loading the view.
        listWhiteSpace = SqliteService.shared.getWhiteSpaceLocation(number: numberQuestion + 1)
        listRemainLetter = SqliteService.shared.shuffleLetters(number: numberQuestion + 1)
        listData = SqliteService.shared.listData
        //image = UIImage(imageLiteralResourceName: "\(numberQuestion)")
        listLetter = SqliteService.shared.shuffleLetters(number: numberQuestion)
        coinLabel.text = String(coin)
        func createBackground(){
            let images: [UIImage] = [ #imageLiteral(resourceName: "bggreen"), #imageLiteral(resourceName: "bgblue")]
            let randomImage = images.shuffled().randomElement()
            let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
            backgroundImage.image = randomImage
            backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
            self.view.insertSubview(backgroundImage, at: 0)
        }
    }


}

extension PlayViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else if section == 1 {
            let amountLetter = SqliteService.shared.getAmountLetterOfRightAnswer(number: numberQuestion)
            return amountLetter
        }
        else {
            return 21
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImagePlayCLVCell.className, for: indexPath) as! ImagePlayCLVCell
            cell.imageCell.image = UIImage.init(imageLiteralResourceName: "\(numberQuestion)")
            cell.layer.cornerRadius = 20
            return cell
        }
        else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AnswerCLVCell.className, for: indexPath) as! AnswerCLVCell
            cell.answerLetterLabel.text = ""
            cell.layer.cornerRadius = 20
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GuessCLVCell.className, for: indexPath) as! GuessCLVCell
            cell.guessLetterLabel.text = listRemainLetter[indexPath.item].rightAnswer
            cell.layer.cornerRadius = 20
            return cell
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView,
//                        viewForSupplementaryElementOfKind kind: String,
//                        at indexPath: IndexPath) -> UICollectionReusableView {
//
//        return UICollectionReusableView()
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let guessCell = collectionView.cellForItem(at: indexPath) as! GuessCLVCell
            if guessCell.guessLetterLabel.text == "" {
                
            }
            else {
                if isFullCellInRightAnswer() {
                    
                }
                else {
                    letter = listRemainLetter[indexPath.item].rightAnswer
                    number = listRemainLetter[indexPath.item].number
                    letterArr.append(letter)
                    listNumber.append(number)
                    listRemainLetter[indexPath.item].rightAnswer = ""
                    //
                    guessCell.guessLetterLabel.text = ""
                    var isWhiteSpace = false
                    let index = getIndexPathOfEmptyTextCell(in: self.collectionView)!
                    for item in listWhiteSpace {
                        if item == index.item {
                            isWhiteSpace = true
                            let rightAnswerCell = self.collectionView.cellForItem(at: index) as! AnswerCLVCell
                            rightAnswerCell.answerLetterLabel.text = letter
                        }
                    }
                    if isWhiteSpace {
                        isWhiteSpace = false
                    }
                    else {
                        let rightAnswerCell = self.collectionView.cellForItem(at: getIndexPathOfEmptyTextCell(in: self.collectionView)!) as! AnswerCLVCell
                        rightAnswerCell.answerLetterLabel.text = letter
                    }
                }
            }
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
    
//    func whenAnswerCorrect(){
//        
//        //next to new question
//        numberQuestion += 1
//        switch level {
//        case 0:
//            KeychainWrapper.standard.set(numberQuestion, forKey: "level1")
//        case 1:
//            KeychainWrapper.standard.set(numberQuestion - level*10, forKey: "level2")
//        case 2:
//            KeychainWrapper.standard.set(numberQuestion - level*20, forKey: "level3")
//        case 3:
//            KeychainWrapper.standard.set(numberQuestion - level*30, forKey: "level4")
//        default:
//            break
//        }
////
////        //increase coin
////        switch level {
////        case 0:
////            levelScore = KeychainWrapper.standard.integer(forKey: "scorelv1")!
////            KeychainWrapper.standard.set(levelScore + 1, forKey: "scorelv1")
////        case 1:
////            levelScore = KeychainWrapper.standard.integer(forKey: "scorelv2")!
////            KeychainWrapper.standard.set(levelScore + 1, forKey: "level2")
////        case 2:
////            levelScore = KeychainWrapper.standard.integer(forKey: "scorelv3")!
////            KeychainWrapper.standard.set(levelScore + 1, forKey: "level3")
////        case 3:
////            levelScore = KeychainWrapper.standard.integer(forKey: "scorelv4")!
////            KeychainWrapper.standard.set(levelScore + 1, forKey: "level4")
////        default:
////            break
////        }
//        score += 1
//        lbcoin.text = String(score)
//        KeychainWrapper.standard.set(score, forKey: "score")
//        
//        //
//        listRemainLetter = SQLiteService.shared.shuffleLetters(number: numberQuestion + 1)
//        listWhiteSpace = SQLiteService.shared.getWhiteSpaceLocation(number: numberQuestion + 1)
//        listNumber.removeAll()
//        letterArr.removeAll()
//        listLettersOfRightAnswer.removeAll()
//    }
//
//    func isRightAnswer()->Bool{
//        let amountletter = SQLiteService.shared.getAmountLetterOfRightAnswer(number: numberQuestion + 1)
//        var isWhiteSpace = false
//        for item in 0...amountletter - 1{
//            for whiteSpaceItem in listWhiteSpace {
//                if item == whiteSpaceItem {
//                    isWhiteSpace = true
//                    let cell = collectionView.cellForItem(at: IndexPath(item: whiteSpaceItem, section: 1)) as! AnswerWhiteSpaceCLVCell
//                    listLettersOfRightAnswer.append(cell.lbLetter.text ?? "")
//                    if item == amountletter - 1{
//                        let rightAnswer = SQLiteService.shared.getRightAnswerLetters(number: numberQuestion + 1)
//                        if listLettersOfRightAnswer == rightAnswer{
//                            return true
//                        }
//                    }
//                    break
//                }
//            }
//            if isWhiteSpace {
//                isWhiteSpace = false
//                continue
//            }
//            let cell = collectionView.cellForItem(at: IndexPath(item: item, section: 1)) as! AnswerLetterCLVCell
//            listLettersOfRightAnswer.append(cell.lbLetter.text ?? "")
//            if item == amountletter - 1{
//                let rightAnswer = SQLiteService.shared.getRightAnswerLetters(number: numberQuestion + 1)
//                if listLettersOfRightAnswer == rightAnswer{
//                    isTrueAnswer = true
//                    return true
//                }
//            }
//        }
//        return false
//    }
//    
    func isFullCellInRightAnswer()->Bool{
        let amountletter = SqliteService.shared.getAmountLetterOfRightAnswer(number: numberQuestion + 1)
        var isWhiteSpace = false
        for item in 0...amountletter - 1{
            for whiteSpaceItem in listWhiteSpace {
                if item == whiteSpaceItem {
                    isWhiteSpace = true
                    let cell = collectionView.cellForItem(at: IndexPath(item: whiteSpaceItem, section: 1)) as! AnswerCLVCell
                    if (cell.answerLetterLabel.text == "") {
                        return false
                    }
                    if item == amountletter - 1{
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
            if item == amountletter - 1{
                return true
            }
        }
        return false
    }
//    
    func getIndexPathOfEmptyTextCell(in collectionView: UICollectionView) -> IndexPath? {
        let amountletter = SqliteService.shared.getAmountLetterOfRightAnswer(number: numberQuestion + 1)
        var isWhiteSpace = false
        for item in 0...amountletter - 1{
            for whiteSpaceItem in listWhiteSpace {
                if item == whiteSpaceItem {
                    isWhiteSpace = true
                    let cell = collectionView.cellForItem(at: IndexPath(item: whiteSpaceItem, section: 1)) as! AnswerCLVCell
                    if (cell.answerLetterLabel.text == "") {
                        return IndexPath(item: item, section: 1)
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
                return IndexPath(item: item, section: 1)
            }
        }
        return IndexPath(item: 0, section: 1)
    }
//    
//    func fillGuessCell(indexPath: IndexPath) {
//        let guessCell = guessCollectionView.cellForItem(at: IndexPath(item: listNumber[indexPath.item], section: 0)) as! GuessCLVCell
//        guessCell.backgroundColor = #colorLiteral(red: 0.07984445244, green: 0.3844624162, blue: 0.5199151635, alpha: 1)
//        guessCell.lbLetter.text = letterArr[indexPath.item]
//        listRemainLetter[listNumber[indexPath.item]] = LetterModel(rightAnswer: letterArr[indexPath.item], number: listNumber[indexPath.item])
//        //set arrays to default
//        letterArr.removeLast()
//        listNumber.removeLast()
//    }
//    
//    
//    func removeLetter() {
//        if isFullCellInRightAnswer() {
//            let amountletter = SQLiteService.shared.getAmountLetterOfRightAnswer(number: numberQuestion + 1)
//            let index = IndexPath(item: amountletter - 1, section: 1)
//            let cell = collectionView.cellForItem(at: index) as! AnswerLetterCLVCell
//            cell.lbLetter.text = ""
//            fillGuessCell(indexPath: index)
//        }
//        else {
//            let emptyCell = getIndexPathOfEmptyTextCell(in: collectionView)
//            let index = IndexPath(item: emptyCell!.item - 1, section: 1)
//            var isWhiteSpace = false
//            for whiteSpaceItem in listWhiteSpace {
//                if emptyCell!.item - 1 == whiteSpaceItem {
//                    isWhiteSpace = true
//                    let cell = collectionView.cellForItem(at: index) as! AnswerWhiteSpaceCLVCell
//                    cell.lbLetter.text = ""
//                    fillGuessCell(indexPath: index)
//                    break
//                }
//            }
//            if isWhiteSpace {
//                isWhiteSpace = false
//            }
//            else {
//                if emptyCell?.item == 0 {
//                    
//                }
//                else {
//                    let cell = collectionView.cellForItem(at: IndexPath(item: emptyCell!.item - 1, section: 1)) as! AnswerLetterCLVCell
//                    cell.lbLetter.text = ""
//                    fillGuessCell(indexPath: index)
//                }
//            }
//        }
//    }
    
}



extension PlayViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.userInterfaceIdiom == .pad{
            return CGSize(width: 45, height: 45)
        }
        return CGSize(width: 45, height: 45)
    }
}

