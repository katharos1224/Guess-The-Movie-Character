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
            }
            
            //totalAnswered += KeychainWrapper.standard.integer(forKey: "number1")!

            cell.unlockedLevelImage.image = UIImage(imageLiteralResourceName: "1")
            // Bo tron anh?
            cell.lockedLevelLabel.text = ""
        }
        
        else if indexPath.item == 1 {
            cell.LevelLabel.text = "Level 2"

            if (totalAnswered < 14) {
                let view = UIView()
                view.backgroundColor = UIColor.black.withAlphaComponent(0.1)
                cell.backgroundView = view
                cell.lockedLevelLabel.text = "Guess 14 icons to unlock"
                cell.unlockedLevelImage.image = UIImage(imageLiteralResourceName: "lockedimg")
                //cell.backgroundColor = UIColor.darkGray.withAlphaComponent(0.2)
                cell.currentProgressView.isHidden = true
                cell.currentProgressLabel.text = "0/70"
            }
            else {
                if (KeychainWrapper.standard.integer(forKey: "number2") == nil) {
                    cell.currentProgressLabel.text = "0/70"
                }
                
                else{
                    let completed = KeychainWrapper.standard.integer(forKey: "number2")
                    cell.currentProgressLabel.text = String(completed!) + "/70"
                    
                    cell.currentProgressView.progress +=  KeychainWrapper.standard.float(forKey: "number2")! * 70/100
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
    
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
////        if isMuteSound{
////
////        }else{
////            MainViewController.shared.playSound()
////        }
//        if indexPath.item == 0{
//            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "PlayScreenViewController") as! PlayScreenViewController
//            if (KeychainWrapper.standard.integer(forKey: "number") == nil){
//                if (KeychainWrapper.standard.integer(forKey: "coin") == nil){
//                    KeychainWrapper.standard.set(0, forKey: "coin")
//                }
//                KeychainWrapper.standard.set(0, forKey: "number")
//                vc.numberQuestion = KeychainWrapper.standard.integer(forKey: "number")! + 1
//                vc.coin = KeychainWrapper.standard.integer(forKey: "coin")!
//            }else{
//                let numberQuestion = KeychainWrapper.standard.integer(forKey: "number")! + 1
//                if numberQuestion == 51{
//
//                }else{
//                    if (KeychainWrapper.standard.integer(forKey: "coin") == nil){
//                        KeychainWrapper.standard.set(0, forKey: "coin")
//                    }
//                    vc.coin = KeychainWrapper.standard.integer(forKey: "coin")!
//                    vc.numberQuestion = numberQuestion
//
//                }
//            }
//            vc.isMuteSound = isMuteSound
//            vc.isMuteMusic = isMuteMusic
//            vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
//            self.present(vc, animated: true, completion: nil)
//        }
//
//        else if indexPath.item == 1{
//            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "PlayScreenDSViewController") as! PlayScreenDSViewController
//            if (KeychainWrapper.standard.integer(forKey: "numberDS") == nil){
//                if (KeychainWrapper.standard.integer(forKey: "coin") == nil){
//                    KeychainWrapper.standard.set(0, forKey: "coin")
//                }
//                KeychainWrapper.standard.set(0, forKey: "numberDS")
//                vc.numberQuestion = KeychainWrapper.standard.integer(forKey: "numberDS")! + 1
//                vc.coin = KeychainWrapper.standard.integer(forKey: "coin")!
//            }else{
//                let numberQuestion = KeychainWrapper.standard.integer(forKey: "numberDS")! + 1
//                if numberQuestion == 65{
//
//                }else{
//                    if (KeychainWrapper.standard.integer(forKey: "coin") == nil){
//                        KeychainWrapper.standard.set(0, forKey: "coin")
//                    }
//                    vc.coin = KeychainWrapper.standard.integer(forKey: "coin")!
//                    vc.numberQuestion = numberQuestion
//                }
//            }
//            vc.isMuteSound = isMuteSound
//            vc.isMuteMusic = isMuteMusic
//            vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
//            self.present(vc, animated: true, completion: nil)
//        }
//    }
}
//--------------------

extension ChooseLevelViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
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

