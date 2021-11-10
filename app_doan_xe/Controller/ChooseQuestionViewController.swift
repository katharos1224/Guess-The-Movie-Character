//
//  ChooseQuestionViewController.swift
//  app_doan_xe
//
//  Created by Son on 09/10/2021.
//

import UIKit

class ChooseQuestionViewController: UIViewController {

    @IBOutlet weak var coinLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var ChooseQuestionCLV: UICollectionView!
    @IBAction func settingAction() {
    }
    @IBAction func rankAction() {
    }
    @IBAction func storeAction() {
    }
    @IBAction func backAction() {
        dismiss(animated: true)
    }
    
    var numberQuestion = 0
    var coin = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ChooseQuestionCLV.delegate = self
        ChooseQuestionCLV.dataSource = self
        
        ChooseQuestionCLV.register(UINib(nibName: ChooseQuestionCLVCell.className, bundle: nil), forCellWithReuseIdentifier: ChooseQuestionCLVCell.className)
        
    }
}

extension ChooseQuestionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 70
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChooseQuestionCLVCell.className, for: indexPath) as! ChooseQuestionCLVCell
        
        cell.layer.cornerRadius = 20
        cell.clipsToBounds = true
        
        for indexImage in 1...70 {
            if indexPath.item == indexImage - 1 {
                cell.questionImage.image = UIImage(imageLiteralResourceName: "\(indexImage)")
            }
        }
        cell.questionImage.layer.cornerRadius = 20
        cell.questionImage.clipsToBounds = true
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for indexQuestion in 1...70 {
            if indexPath.item == indexQuestion - 1 {
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "PlayViewController") as! PlayViewController
                vc.numberQuestion = indexPath.item
                vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
}

extension ChooseQuestionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.userInterfaceIdiom == .pad{
            return CGSize(width: 115, height: 115)
        }
        return CGSize(width: 115, height: 115)
    }
}
