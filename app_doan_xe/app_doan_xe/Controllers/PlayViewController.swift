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
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var coinLabel: UILabel!
    @IBOutlet weak var totalAnsweredLabel: UILabel!
    
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
    
    var coin = 0
    //var image: UIImage!
    var numberQuestion = 0
    var listData:[WordsModel] = [WordsModel]()
    var listWhiteSpace: [Int] = []
    var listLetter: [LetterModel] = [LetterModel]()
    var listLettersOfRightAnswer: [String] = []
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
        listLetter = SqliteService.shared.shuffleLetters(number: numberQuestion + 1)
        listData = SqliteService.shared.listData
        //image = UIImage(imageLiteralResourceName: "\(numberQuestion)")
        //coinLabel.text = String(coin)
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AnswerCLVCell.className, for: indexPath) as! AnswerCLVCell
            cell.answerLetterLabel.text = ""
            cell.answerLetterLabel.textColor = .clear
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GuessCLVCell.className, for: indexPath) as! GuessCLVCell
            cell.guessLetterLabel.text = listLetter[indexPath.item].rightAnswer
            return cell
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView,
//                        viewForSupplementaryElementOfKind kind: String,
//                        at indexPath: IndexPath) -> UICollectionReusableView {
//
//        return UICollectionReusableView()
//    }
    
    
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            let answerCell = collectionView.cellForItem(at: indexPath) as! AnswerCLVCell
            
            if answerCell.answerLetterLabel.text!.contains("") || isHintLetter(indexPath: indexPath){
                
            }
            else {
                answerCell.answerLetterLabel.text = ""
                answerCell.answerLetterLabel.textColor = .clear
                let guessCell = collectionView.cellForItem(at: IndexPath(item: listNumber[indexPath.item], section: 2)) as! GuessCLVCell
                
                guessCell.guessLetterLabel.text = letterArr[indexPath.item]
                //set arrays to default
                listLetter[listNumber[indexPath.item]].rightAnswer = letterArr[indexPath.item]
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
                    letter = listLetter[indexPath.item].rightAnswer
                    number = listLetter[indexPath.item].number
                    //set LetterArr
                    insertLetterArr(letter: letter)
                    //set ListNumber
                    insertListNumber(number: number)
                    
                    listLetter[indexPath.item].rightAnswer = ""
                    
                    guessCell.guessLetterLabel.text = ""
                    var isWhiteSpace = false
//                    let index = getIndexPathOfEmptyTextCell(in: self.collectionView)!
//                    for item in listWhiteSpace {
//                        if item == index.item {
//                            isWhiteSpace = true
//                            let rightAnswerCell = self.collectionView.cellForItem(at: index) as! AnswerCLVCell
//                            rightAnswerCell.answerLetterLabel.text = letter
//                        }
//                    }
                    if isWhiteSpace {
                        isWhiteSpace = false
                    }
                    else {
                        let rightAnswerCell = self.collectionView.cellForItem(at: getIndexPathOfEmptyTextCell(in: self.collectionView)!) as! AnswerCLVCell
                        rightAnswerCell.answerLetterLabel.text = letter
                        rightAnswerCell.answerLetterLabel.textColor = .white
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
    
    func whenAnswerCorrect() {
        let correctAnswer = SqliteService.shared.getOriginalRightAnswer(number: numberQuestion)
        
//        //next to new question
//        KeychainWrapper.standard.removeObject(forKey: "number")
//        KeychainWrapper.standard.set(numberQuestion, forKey: "number")
//        numberQuestion = KeychainWrapper.standard.integer(forKey: "number")! + 1
//
//        //increase coin
//        coin += 100
//        KeychainWrapper.standard.removeObject(forKey: "coin")
//        KeychainWrapper.standard.set(coin, forKey: "coin")
//        //
//        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "CorrectViewController") as! CorrectViewController
//        vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
//        vc.numberQuestion = numberQuestion
//        vc.correctAnswer = correctAnswer
//        vc.image = image
//        vc.coin = coin
//        vc.isMuteSound = isMuteSound
//        vc.isMuteMusic = isMuteMusic
//        self.present(vc, animated: true, completion: nil)
        listNumber.removeAll()
        letterArr.removeAll()
        listLettersOfRightAnswer.removeAll()
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
        let amountletter = SqliteService.shared.getAmountLetterOfRightAnswer(number: numberQuestion + 1)
        var isWhiteSpace = false
        for item in 0...amountletter - 1 {
            for whiteSpaceItem in listWhiteSpace {
                if item == whiteSpaceItem {
                    isWhiteSpace = true
                    let cell = collectionView.cellForItem(at: IndexPath(item: whiteSpaceItem, section: 1)) as! AnswerCLVCell
                    if (cell.answerLetterLabel.text == "") {
                        return false
                    }
                    if item == amountletter - 1 {
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
            if item == amountletter - 1 {
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
}

