//
//  ChooseLevelViewController.swift
//  app_doan_xe
//
//  Created by Son on 09/10/2021.
//

import UIKit
import SwiftKeychainWrapper
import AVFoundation

class ChooseLevelViewController: UIViewController {
    
    @IBOutlet weak var ChooseLevelCLV: UICollectionView!
    
    @IBAction func settingAction() {
    }
    @IBAction func rankAction() {
    }
    @IBAction func storeAction() {
    }
    @IBAction func backAction() {
        dismiss(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        ChooseLevelCLV.delegate = self
        ChooseLevelCLV.dataSource = self
        
        ChooseLevelCLV.register(UINib(nibName: ChooseLevelCLVCell.className, bundle: nil), forCellWithReuseIdentifier: ChooseLevelCLVCell.className)
    }
}

//--------------

extension ChooseLevelViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"ChooseLevelCLVCell", for: indexPath) as! ChooseLevelCLVCell
        cell.layer.cornerRadius = 20
        cell.clipsToBounds = true
        var totalAnswered: Int = 0
        
        if indexPath.item == 0 {
            cell.LevelLabel.text = "Level 1"
            
            if (KeychainWrapper.standard.integer(forKey: "number1") == nil) {
                cell.currentProgressLabel.text = "0/70"
            }
            else{
                let completed = KeychainWrapper.standard.integer(forKey: "number1")
                cell.currentProgressLabel.text = String(completed!) + "/70"
                cell.currentProgressView.progress +=  KeychainWrapper.standard.float(forKey: "number1")! * 70/100
                totalAnswered += KeychainWrapper.standard.integer(forKey: "number1")!
            }

            cell.unlockedLevelImage.image = UIImage(imageLiteralResourceName: "1")
            cell.unlockedLevelImage.layer.cornerRadius = cell.unlockedLevelImage.frame.size.width / 2
            cell.unlockedLevelImage.clipsToBounds = true
            cell.lockedLevelLabel.text = ""
        }
        else if indexPath.item == 1 {
            cell.LevelLabel.text = "Level 2"

            if (KeychainWrapper.standard.integer(forKey: "number2") == nil && totalAnswered < 21) {
                let view = UIView()
                view.backgroundColor = UIColor.black.withAlphaComponent(0.1)
                cell.backgroundView = view
                cell.lockedLevelLabel.text = "Guess 21 icons to unlock"
                cell.unlockedLevelImage.image = UIImage(imageLiteralResourceName: "lockedimg")
                cell.unlockedLevelImage.layer.cornerRadius = cell.unlockedLevelImage.frame.size.width / 2
                cell.unlockedLevelImage.clipsToBounds = true
                cell.currentProgressView.isHidden = true
                cell.currentProgressLabel.text = "0/70"
            }
            else {
                if (KeychainWrapper.standard.integer(forKey: "number2") == nil && totalAnswered >= 21) {
                    cell.currentProgressLabel.text = "0/70"
                }
                
                else{
                    let completed = KeychainWrapper.standard.integer(forKey: "number2")
                    cell.currentProgressLabel.text = String(completed!) + "/70"
                    cell.currentProgressView.progress +=  KeychainWrapper.standard.float(forKey: "number2")! * 70/100
                    totalAnswered += KeychainWrapper.standard.integer(forKey: "number2")!
                }
                cell.unlockedLevelImage.image = UIImage(imageLiteralResourceName: "71")
                cell.unlockedLevelImage.layer.cornerRadius = cell.unlockedLevelImage.frame.size.width / 2
                cell.unlockedLevelImage.clipsToBounds = true
                cell.lockedLevelLabel.text = ""
                cell.currentProgressView.isHidden = false

            }
        }
        else if indexPath.item == 2 {
            cell.LevelLabel.text = "Level 3"

            if (KeychainWrapper.standard.integer(forKey: "number3") == nil && totalAnswered < 21) {
                let view = UIView()
                view.backgroundColor = UIColor.black.withAlphaComponent(0.1)
                cell.backgroundView = view
                cell.lockedLevelLabel.text = "Guess 21 icons to unlock"
                cell.unlockedLevelImage.image = UIImage(imageLiteralResourceName: "lockedimg")
                cell.unlockedLevelImage.layer.cornerRadius = cell.unlockedLevelImage.frame.size.width / 2
                cell.unlockedLevelImage.clipsToBounds = true
                cell.currentProgressView.isHidden = true
                cell.currentProgressLabel.text = "0/70"
            }
            else {
                if (KeychainWrapper.standard.integer(forKey: "number3") == nil && totalAnswered >= 21) {
                    cell.currentProgressLabel.text = "0/70"
                }
                
                else{
                    let completed = KeychainWrapper.standard.integer(forKey: "number3")
                    cell.currentProgressLabel.text = String(completed!) + "/70"
                    cell.currentProgressView.progress +=  KeychainWrapper.standard.float(forKey: "number3")! * 70/100
                    totalAnswered += KeychainWrapper.standard.integer(forKey: "number3")!
                }
                cell.unlockedLevelImage.image = UIImage(imageLiteralResourceName: "141")
                cell.unlockedLevelImage.layer.cornerRadius = cell.unlockedLevelImage.frame.size.width / 2
                cell.unlockedLevelImage.clipsToBounds = true
                cell.lockedLevelLabel.text = ""
                cell.currentProgressView.isHidden = false

            }
        }
        else if indexPath.item == 3 {
            cell.LevelLabel.text = "Level 4"

            if (KeychainWrapper.standard.integer(forKey: "number4") == nil && totalAnswered < 21) {
                let view = UIView()
                view.backgroundColor = UIColor.black.withAlphaComponent(0.1)
                cell.backgroundView = view
                cell.lockedLevelLabel.text = "Guess 21 icons to unlock"
                cell.unlockedLevelImage.image = UIImage(imageLiteralResourceName: "lockedimg")
                cell.unlockedLevelImage.layer.cornerRadius = cell.unlockedLevelImage.frame.size.width / 2
                cell.unlockedLevelImage.clipsToBounds = true
                cell.currentProgressView.isHidden = true
                cell.currentProgressLabel.text = "0/70"
            }
            else {
                if (KeychainWrapper.standard.integer(forKey: "number4") == nil && totalAnswered >= 21) {
                    cell.currentProgressLabel.text = "0/70"
                }
                
                else{
                    let completed = KeychainWrapper.standard.integer(forKey: "number4")
                    cell.currentProgressLabel.text = String(completed!) + "/70"
                    cell.currentProgressView.progress +=  KeychainWrapper.standard.float(forKey: "number4")! * 70/100
                    totalAnswered += KeychainWrapper.standard.integer(forKey: "number4")!
                }
                cell.unlockedLevelImage.image = UIImage(imageLiteralResourceName: "211")
                cell.unlockedLevelImage.layer.cornerRadius = cell.unlockedLevelImage.frame.size.width / 2
                cell.unlockedLevelImage.clipsToBounds = true
                cell.lockedLevelLabel.text = ""
                cell.currentProgressView.isHidden = false

            }
        }
        else if indexPath.item == 4 {
            cell.LevelLabel.text = "Level 5"

            if (KeychainWrapper.standard.integer(forKey: "number5") == nil && totalAnswered < 21) {
                let view = UIView()
                view.backgroundColor = UIColor.black.withAlphaComponent(0.1)
                cell.backgroundView = view
                cell.lockedLevelLabel.text = "Guess 21 icons to unlock"
                cell.unlockedLevelImage.image = UIImage(imageLiteralResourceName: "lockedimg")
                cell.unlockedLevelImage.layer.cornerRadius = cell.unlockedLevelImage.frame.size.width / 2
                cell.unlockedLevelImage.clipsToBounds = true
                cell.currentProgressView.isHidden = true
                cell.currentProgressLabel.text = "0/70"
            }
            else {
                if (KeychainWrapper.standard.integer(forKey: "number5") == nil && totalAnswered >= 21) {
                    cell.currentProgressLabel.text = "0/70"
                }
                
                else{
                    let completed = KeychainWrapper.standard.integer(forKey: "number5")
                    cell.currentProgressLabel.text = String(completed!) + "/70"
                    cell.currentProgressView.progress +=  KeychainWrapper.standard.float(forKey: "number5")! * 70/100
                    totalAnswered += KeychainWrapper.standard.integer(forKey: "number5")!
                }
                cell.unlockedLevelImage.image = UIImage(imageLiteralResourceName: "281")
                cell.unlockedLevelImage.layer.cornerRadius = cell.unlockedLevelImage.frame.size.width / 2
                cell.unlockedLevelImage.clipsToBounds = true
                cell.lockedLevelLabel.text = ""
                cell.currentProgressView.isHidden = false

            }
        }
        else if indexPath.item == 5 {
            cell.LevelLabel.text = "Level 6"

            if (KeychainWrapper.standard.integer(forKey: "number6") == nil && totalAnswered < 21) {
                let view = UIView()
                view.backgroundColor = UIColor.black.withAlphaComponent(0.1)
                cell.backgroundView = view
                cell.lockedLevelLabel.text = "Guess 21 icons to unlock"
                cell.unlockedLevelImage.image = UIImage(imageLiteralResourceName: "lockedimg")
                cell.unlockedLevelImage.layer.cornerRadius = cell.unlockedLevelImage.frame.size.width / 2
                cell.unlockedLevelImage.clipsToBounds = true
                cell.currentProgressView.isHidden = true
                cell.currentProgressLabel.text = "0/70"
            }
            else {
                if (KeychainWrapper.standard.integer(forKey: "number6") == nil && totalAnswered >= 21) {
                    cell.currentProgressLabel.text = "0/70"
                }
                
                else{
                    let completed = KeychainWrapper.standard.integer(forKey: "number6")
                    cell.currentProgressLabel.text = String(completed!) + "/70"
                    cell.currentProgressView.progress +=  KeychainWrapper.standard.float(forKey: "number6")! * 70/100
                    totalAnswered += KeychainWrapper.standard.integer(forKey: "number6")!
                }
                cell.unlockedLevelImage.image = UIImage(imageLiteralResourceName: "351")
                cell.unlockedLevelImage.layer.cornerRadius = cell.unlockedLevelImage.frame.size.width / 2
                cell.unlockedLevelImage.clipsToBounds = true
                cell.lockedLevelLabel.text = ""
                cell.currentProgressView.isHidden = false

            }
        }
        else {
            cell.LevelLabel.text = "Level 7"

            if (KeychainWrapper.standard.integer(forKey: "number7") == nil && totalAnswered < 21) {
                let view = UIView()
                view.backgroundColor = UIColor.black.withAlphaComponent(0.1)
                cell.backgroundView = view
                cell.lockedLevelLabel.text = "Guess 21 icons to unlock"
                cell.unlockedLevelImage.image = UIImage(imageLiteralResourceName: "lockedimg")
                cell.unlockedLevelImage.layer.cornerRadius = cell.unlockedLevelImage.frame.size.width / 2
                cell.unlockedLevelImage.clipsToBounds = true
                cell.currentProgressView.isHidden = true
                cell.currentProgressLabel.text = "0/70"
            }
            else {
                if (KeychainWrapper.standard.integer(forKey: "number7") == nil && totalAnswered >= 21) {
                    cell.currentProgressLabel.text = "0/70"
                }
                
                else{
                    let completed = KeychainWrapper.standard.integer(forKey: "number7")
                    cell.currentProgressLabel.text = String(completed!) + "/70"
                    cell.currentProgressView.progress +=  KeychainWrapper.standard.float(forKey: "number7")! * 70/100
                    totalAnswered += KeychainWrapper.standard.integer(forKey: "number7")!
                }
                cell.unlockedLevelImage.image = UIImage(imageLiteralResourceName: "421")
                cell.unlockedLevelImage.layer.cornerRadius = cell.unlockedLevelImage.frame.size.width / 2
                cell.unlockedLevelImage.clipsToBounds = true
                cell.lockedLevelLabel.text = ""
                cell.currentProgressView.isHidden = false

            }
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        return UICollectionReusableView()
    }
    
//-----------------
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if indexPath.item == 0 {
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "PlayViewController") as! PlayViewController
            if (KeychainWrapper.standard.integer(forKey: "number1") == nil){
                if (KeychainWrapper.standard.integer(forKey: "coin") == nil){
                    KeychainWrapper.standard.set(0, forKey: "coin")
                }
                KeychainWrapper.standard.set(0, forKey: "number1")
                vc.numberQuestion = KeychainWrapper.standard.integer(forKey: "number1")! + 1
                vc.coin = KeychainWrapper.standard.integer(forKey: "coin")!
            }else{
                let numberQuestion = KeychainWrapper.standard.integer(forKey: "number1")! + 1
                if numberQuestion == 71{

                }else{
                    if (KeychainWrapper.standard.integer(forKey: "coin") == nil){
                        KeychainWrapper.standard.set(0, forKey: "coin")
                    }
                    vc.coin = KeychainWrapper.standard.integer(forKey: "coin")!
                    vc.numberQuestion = numberQuestion
                    print("selected")
                }
            }
            
            vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
            self.present(vc, animated: true, completion: nil)
        }

        else if indexPath.item == 1 {
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "PlayViewController") as! PlayViewController
            if (KeychainWrapper.standard.integer(forKey: "number2") == nil){
                if (KeychainWrapper.standard.integer(forKey: "coin") == nil){
                    KeychainWrapper.standard.set(0, forKey: "coin")
                }
                KeychainWrapper.standard.set(0, forKey: "number2")
                vc.numberQuestion = KeychainWrapper.standard.integer(forKey: "number2")! + 1
                vc.coin = KeychainWrapper.standard.integer(forKey: "coin")!
            }else{
                let numberQuestion = KeychainWrapper.standard.integer(forKey: "number2")! + 1
                if numberQuestion == 141{

                }else{
                    if (KeychainWrapper.standard.integer(forKey: "coin") == nil){
                        KeychainWrapper.standard.set(0, forKey: "coin")
                    }
                    vc.coin = KeychainWrapper.standard.integer(forKey: "coin")!
                    vc.numberQuestion = numberQuestion
                }
            }
            
            vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
            self.present(vc, animated: true, completion: nil)
        }
        
        else if indexPath.item == 2 {
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "PlayViewController") as! PlayViewController
            if (KeychainWrapper.standard.integer(forKey: "number3") == nil){
                if (KeychainWrapper.standard.integer(forKey: "coin") == nil){
                    KeychainWrapper.standard.set(0, forKey: "coin")
                }
                KeychainWrapper.standard.set(0, forKey: "number3")
                vc.numberQuestion = KeychainWrapper.standard.integer(forKey: "number3")! + 1
                vc.coin = KeychainWrapper.standard.integer(forKey: "coin")!
            }else{
                let numberQuestion = KeychainWrapper.standard.integer(forKey: "number3")! + 1
                if numberQuestion == 211{

                }else{
                    if (KeychainWrapper.standard.integer(forKey: "coin") == nil){
                        KeychainWrapper.standard.set(0, forKey: "coin")
                    }
                    vc.coin = KeychainWrapper.standard.integer(forKey: "coin")!
                    vc.numberQuestion = numberQuestion
                }
            }
            
            vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
            self.present(vc, animated: true, completion: nil)
        }
        
        else if indexPath.item == 3 {
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "PlayViewController") as! PlayViewController
            if (KeychainWrapper.standard.integer(forKey: "number4") == nil){
                if (KeychainWrapper.standard.integer(forKey: "coin") == nil){
                    KeychainWrapper.standard.set(0, forKey: "coin")
                }
                KeychainWrapper.standard.set(0, forKey: "number4")
                vc.numberQuestion = KeychainWrapper.standard.integer(forKey: "number4")! + 1
                vc.coin = KeychainWrapper.standard.integer(forKey: "coin")!
            }else{
                let numberQuestion = KeychainWrapper.standard.integer(forKey: "number4")! + 1
                if numberQuestion == 281{

                }else{
                    if (KeychainWrapper.standard.integer(forKey: "coin") == nil){
                        KeychainWrapper.standard.set(0, forKey: "coin")
                    }
                    vc.coin = KeychainWrapper.standard.integer(forKey: "coin")!
                    vc.numberQuestion = numberQuestion
                }
            }
            
            vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
            self.present(vc, animated: true, completion: nil)
        }
        
        else if indexPath.item == 4 {
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "PlayViewController") as! PlayViewController
            if (KeychainWrapper.standard.integer(forKey: "number5") == nil){
                if (KeychainWrapper.standard.integer(forKey: "coin") == nil){
                    KeychainWrapper.standard.set(0, forKey: "coin")
                }
                KeychainWrapper.standard.set(0, forKey: "number5")
                vc.numberQuestion = KeychainWrapper.standard.integer(forKey: "number5")! + 1
                vc.coin = KeychainWrapper.standard.integer(forKey: "coin")!
            }else{
                let numberQuestion = KeychainWrapper.standard.integer(forKey: "number5")! + 1
                if numberQuestion == 351{

                }else{
                    if (KeychainWrapper.standard.integer(forKey: "coin") == nil){
                        KeychainWrapper.standard.set(0, forKey: "coin")
                    }
                    vc.coin = KeychainWrapper.standard.integer(forKey: "coin")!
                    vc.numberQuestion = numberQuestion
                }
            }
            
            vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
            self.present(vc, animated: true, completion: nil)
        }
        
        else if indexPath.item == 5 {
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "PlayViewController") as! PlayViewController
            if (KeychainWrapper.standard.integer(forKey: "number6") == nil){
                if (KeychainWrapper.standard.integer(forKey: "coin") == nil){
                    KeychainWrapper.standard.set(0, forKey: "coin")
                }
                KeychainWrapper.standard.set(0, forKey: "number6")
                vc.numberQuestion = KeychainWrapper.standard.integer(forKey: "number6")! + 1
                vc.coin = KeychainWrapper.standard.integer(forKey: "coin")!
            }else{
                let numberQuestion = KeychainWrapper.standard.integer(forKey: "number6")! + 1
                if numberQuestion == 421{

                }else{
                    if (KeychainWrapper.standard.integer(forKey: "coin") == nil){
                        KeychainWrapper.standard.set(0, forKey: "coin")
                    }
                    vc.coin = KeychainWrapper.standard.integer(forKey: "coin")!
                    vc.numberQuestion = numberQuestion
                }
            }
            
            vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
            self.present(vc, animated: true, completion: nil)
        }
        else {
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "PlayViewController") as! PlayViewController
            if (KeychainWrapper.standard.integer(forKey: "number7") == nil){
                if (KeychainWrapper.standard.integer(forKey: "coin") == nil){
                    KeychainWrapper.standard.set(0, forKey: "coin")
                }
                KeychainWrapper.standard.set(0, forKey: "number7")
                vc.numberQuestion = KeychainWrapper.standard.integer(forKey: "number7")! + 1
                vc.coin = KeychainWrapper.standard.integer(forKey: "coin")!
            }else{
                let numberQuestion = KeychainWrapper.standard.integer(forKey: "number7")! + 1
                if numberQuestion == 491{

                }else{
                    if (KeychainWrapper.standard.integer(forKey: "coin") == nil){
                        KeychainWrapper.standard.set(0, forKey: "coin")
                    }
                    vc.coin = KeychainWrapper.standard.integer(forKey: "coin")!
                    vc.numberQuestion = numberQuestion
                }
            }
            
            vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
            self.present(vc, animated: true, completion: nil)
        }
        
    }
}
//--------------------

extension ChooseLevelViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.userInterfaceIdiom == .pad{
            return CGSize(width: ChooseLevelCLV.frame.width, height: 76)
        }
        return CGSize(width: ChooseLevelCLV.frame.width, height: 76)
    }
}

