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
        if indexPath.item == 0{
            cell.unlockedLevelLabel.text = "Level XX"
            
            if (KeychainWrapper.standard.integer(forKey: "number") == nil){
                cell.currentProgressLabel.text = "0/70"
                
            }
            else{
                let completed = KeychainWrapper.standard.integer(forKey: "number")
                cell.currentProgressLabel.text = String(completed!) + "/70"
                let leftView = UIView(frame: CGRect(x: 0, y: 0,
                        width: cell.bounds.width/20, height: cell.bounds.height))
                leftView.backgroundColor = UIColor.black.withAlphaComponent(0)
                cell.addSubview(leftView)
            }
            
            //set 2 background layers
            let View = UIView()
            View.backgroundColor = UIColor.black.withAlphaComponent(0.8)
            cell.backgroundView = View
            if (KeychainWrapper.standard.integer(forKey: "number") != nil && KeychainWrapper.standard.integer(forKey: "number") != 0){
                cell.backgroundView?.frame = CGRect(x: cell.frame.width/CGFloat(65 - KeychainWrapper.standard.integer(forKey: "number")!), y: 0, width: (cell.frame.width/CGFloat(51 - KeychainWrapper.standard.integer(forKey: "number")!)) * 51, height: cell.frame.height)
            }
            let image = UIImage(#imageLiteral(resourceName: "_1.png"))
            let resizeImage = image.imageResize(sizeChange: CGSize(width: cell.frame.width, height: cell.frame.height))
            cell.backgroundColor = UIColor(patternImage: resizeImage)
        }
        else if indexPath.item == 1{
            cell.mangaName.text = "Kimetsu no yaiba"
            if (KeychainWrapper.standard.integer(forKey: "numberDS") == nil){
                cell.completed.text = "0/64"
            }
            else{
                let completed = KeychainWrapper.standard.integer(forKey: "numberDS")
                cell.completed.text = String(completed!) + "/64"
                
            }
            
            //set 2 background layers
            let View = UIView()
            View.backgroundColor = UIColor.black.withAlphaComponent(0.8)
//            View.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "demon slayer"))
            cell.backgroundView = View
            if (KeychainWrapper.standard.integer(forKey: "numberDS") != nil && KeychainWrapper.standard.integer(forKey: "numberDS") != 0){
                cell.backgroundView?.frame = CGRect(x: cell.frame.width/CGFloat(65 - KeychainWrapper.standard.integer(forKey: "numberDS")!), y: 0, width: (cell.frame.width/CGFloat(65 - KeychainWrapper.standard.integer(forKey: "numberDS")!)) * 65, height: cell.frame.height)
            }
            let image = UIImage(#imageLiteral(resourceName: "demon slayer"))
            let resizeImage = image.imageResize(sizeChange: CGSize(width: cell.frame.width, height: cell.frame.height))
            cell.backgroundColor = UIColor(patternImage: resizeImage)
            
        }
        else if indexPath.item == 2{
            cell.mangaName.text = "Naruto"
            cell.completed.text = "0/60"
            
            //set 2 background layers
            let View = UIView()
            View.backgroundColor = UIColor.black.withAlphaComponent(0.8)
            cell.backgroundView = View
            let image = UIImage(#imageLiteral(resourceName: "naruto"))
            let resizeImage = image.imageResize(sizeChange: CGSize(width: cell.frame.width, height: cell.frame.height))
            cell.backgroundColor = UIColor(patternImage: resizeImage)
            
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        return UICollectionReusableView()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isMuteSound{

        }else{
            MainViewController.shared.playSound()
        }
        if indexPath.item == 0{
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "PlayScreenViewController") as! PlayScreenViewController
            if (KeychainWrapper.standard.integer(forKey: "number") == nil){
                if (KeychainWrapper.standard.integer(forKey: "coin") == nil){
                    KeychainWrapper.standard.set(0, forKey: "coin")
                }
                KeychainWrapper.standard.set(0, forKey: "number")
                vc.numberQuestion = KeychainWrapper.standard.integer(forKey: "number")! + 1
                vc.coin = KeychainWrapper.standard.integer(forKey: "coin")!
            }else{
                let numberQuestion = KeychainWrapper.standard.integer(forKey: "number")! + 1
                if numberQuestion == 51{
                    
                }else{
                    if (KeychainWrapper.standard.integer(forKey: "coin") == nil){
                        KeychainWrapper.standard.set(0, forKey: "coin")
                    }
                    vc.coin = KeychainWrapper.standard.integer(forKey: "coin")!
                    vc.numberQuestion = numberQuestion
                    
                }
            }
            vc.isMuteSound = isMuteSound
            vc.isMuteMusic = isMuteMusic
            vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
            self.present(vc, animated: true, completion: nil)
        }
        
        else if indexPath.item == 1{
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "PlayScreenDSViewController") as! PlayScreenDSViewController
            if (KeychainWrapper.standard.integer(forKey: "numberDS") == nil){
                if (KeychainWrapper.standard.integer(forKey: "coin") == nil){
                    KeychainWrapper.standard.set(0, forKey: "coin")
                }
                KeychainWrapper.standard.set(0, forKey: "numberDS")
                vc.numberQuestion = KeychainWrapper.standard.integer(forKey: "numberDS")! + 1
                vc.coin = KeychainWrapper.standard.integer(forKey: "coin")!
            }else{
                let numberQuestion = KeychainWrapper.standard.integer(forKey: "numberDS")! + 1
                if numberQuestion == 65{
                    
                }else{
                    if (KeychainWrapper.standard.integer(forKey: "coin") == nil){
                        KeychainWrapper.standard.set(0, forKey: "coin")
                    }
                    vc.coin = KeychainWrapper.standard.integer(forKey: "coin")!
                    vc.numberQuestion = numberQuestion
                }
            }
            vc.isMuteSound = isMuteSound
            vc.isMuteMusic = isMuteMusic
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

