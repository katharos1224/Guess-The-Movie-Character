//
//  ChooseLevelViewController.swift
//  app_doan_xe
//
//  Created by Son on 09/10/2021.
//

import UIKit

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

extension ChooseLevelViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 35
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChooseLevelCLVCell.className, for: indexPath) as! ChooseLevelCLVCell
            return cell
    }
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        return UICollectionReusableView()
    }
}

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

