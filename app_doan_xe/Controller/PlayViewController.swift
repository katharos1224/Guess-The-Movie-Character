//
//  PlayViewController.swift
//  app_doan_xe
//
//  Created by Son on 08/10/2021.
//

import UIKit

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
    var listData:[WordsModel] = [WordsModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: ImageCLVCell.className, bundle: nil), forCellWithReuseIdentifier: ImageCLVCell.className)
        collectionView.register(UINib(nibName: GuessCLVCell.className, bundle: nil), forCellWithReuseIdentifier: GuessCLVCell.className)
        collectionView.register(UINib(nibName: AnswerCLVCell.className, bundle: nil), forCellWithReuseIdentifier: AnswerCLVCell.className)
        // Do any additional setup after loading the view.
        
        func createBackground(){
                let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
            backgroundImage.image = #imageLiteral(resourceName: "Rectangle 1")
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
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCLVCell.className, for: indexPath) as! ImageCLVCell
            return cell
        }
        else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GuessCLVCell.className, for: indexPath) as! GuessCLVCell
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AnswerCLVCell.className, for: indexPath) as! AnswerCLVCell
            return cell
        }

        
        
    }
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        return UICollectionReusableView()
    }
    
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

