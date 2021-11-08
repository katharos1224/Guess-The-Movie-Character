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
        
        for indexLevel in 1...7 {
            if (indexPath.item == indexLevel - 1 && indexPath.item == 0) {
                cell.LevelLabel.text = "Level \(indexLevel)"
                
                if (KeychainWrapper.standard.integer(forKey: "number\(indexLevel)") == nil) {
                    cell.currentProgressLabel.text = "0/70"
                }
                else{
                    let completed = KeychainWrapper.standard.integer(forKey: "number\(indexLevel)")
                    cell.currentProgressLabel.text = String(completed!) + "/70"
                    cell.currentProgressView.progress +=  KeychainWrapper.standard.float(forKey: "number\(indexLevel)")! * 70/100
                    totalAnswered += KeychainWrapper.standard.integer(forKey: "number\(indexLevel)")!
                }

                cell.unlockedLevelImage.image = UIImage(imageLiteralResourceName: "\(indexLevel)")
                cell.unlockedLevelImage.layer.cornerRadius = cell.unlockedLevelImage.frame.size.width / 2
                cell.unlockedLevelImage.clipsToBounds = true
                cell.lockedLevelLabel.text = ""
            }
            else {
                if (indexPath.item == indexLevel - 1 && indexPath.item > 0) {
                    cell.LevelLabel.text = "Level \(indexLevel)"
                    if (KeychainWrapper.standard.integer(forKey: "number\(indexLevel)") == nil && totalAnswered < 21) { //fix 21
                        let view = UIView()
                        view.backgroundColor = UIColor.black.withAlphaComponent(0.1)
                        cell.backgroundView = view
                        cell.lockedLevelLabel.text = "Guess 21 icons to unlock" //fix 21
                        cell.unlockedLevelImage.image = UIImage(imageLiteralResourceName: "lockedimg")
                        cell.unlockedLevelImage.layer.cornerRadius = cell.unlockedLevelImage.frame.size.width / 2
                        cell.unlockedLevelImage.clipsToBounds = true
                        cell.currentProgressView.isHidden = true
                        cell.currentProgressLabel.text = "0/70" //fix
                    }
                    else {
                        if (KeychainWrapper.standard.integer(forKey: "number\(indexLevel)") == nil && totalAnswered >= 21) {    //fix 21
                            cell.currentProgressLabel.text = "0/70" //fix
                        }
                        
                        else{
                            let completed = KeychainWrapper.standard.integer(forKey: "number\(indexLevel)")
                            cell.currentProgressLabel.text = String(completed!) + "/70"
                            cell.currentProgressView.progress +=  KeychainWrapper.standard.float(forKey: "number\(indexLevel)")! * 70/100
                            totalAnswered += KeychainWrapper.standard.integer(forKey: "number\(indexLevel)")!
                        }
                        cell.unlockedLevelImage.image = UIImage(imageLiteralResourceName: "\(70 * indexLevel + 1)")
                        cell.unlockedLevelImage.layer.cornerRadius = cell.unlockedLevelImage.frame.size.width / 2
                        cell.unlockedLevelImage.clipsToBounds = true
                        cell.lockedLevelLabel.text = ""
                        cell.currentProgressView.isHidden = false

                    }
                }
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
        for indexLevel in 1...7 {
            if indexPath.item == indexLevel - 1 {
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "ChooseQuestionViewController") as! ChooseQuestionViewController
    //            if (KeychainWrapper.standard.integer(forKey: "number1") == nil){
    //                if (KeychainWrapper.standard.integer(forKey: "coin") == nil){
    //                    KeychainWrapper.standard.set(0, forKey: "coin")
    //                }
    //                KeychainWrapper.standard.set(0, forKey: "number1")
    //                vc.numberQuestion = KeychainWrapper.standard.integer(forKey: "number1")! + 1
    //                vc.coin = KeychainWrapper.standard.integer(forKey: "coin")!
    //            }else{
    //                let numberQuestion = KeychainWrapper.standard.integer(forKey: "number1")! + 1
    //                if numberQuestion == 71{
    //
    //                }else{
    //                    if (KeychainWrapper.standard.integer(forKey: "coin") == nil){
    //                        KeychainWrapper.standard.set(0, forKey: "coin")
    //                    }
    //                    vc.coin = KeychainWrapper.standard.integer(forKey: "coin")!
    //                    vc.numberQuestion = numberQuestion
    //                    print("selected")
    //                }
    //            }
                
                vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
                self.present(vc, animated: true, completion: nil)
            }
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

