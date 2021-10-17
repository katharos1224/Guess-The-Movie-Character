//
//  LevelViewController.swift
//  app_doan_xe
//
//  Created by Son on 09/10/2021.
//

import UIKit

class LevelViewController: UIViewController {

    @IBOutlet weak var LevelViewClV: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        LevelViewClV.delegate = self
        LevelViewClV.dataSource = self
        LevelViewClV.register(UINib(nibName: LevelCLVCell.className, bundle: nil), forCellWithReuseIdentifier: LevelCLVCell.className)
    }
}

extension LevelViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 14
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LevelViewClV.className, for: indexPath) as! LevelCLVCell
            return cell
    }
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        return UICollectionReusableView()
    }
}

extension LevelViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
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
