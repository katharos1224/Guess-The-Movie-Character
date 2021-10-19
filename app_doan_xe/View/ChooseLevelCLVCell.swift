//
//  ChooseLevelCLVCell.swift
//  app_doan_xe
//
//  Created by Son on 09/10/2021.
//

import UIKit

class ChooseLevelCLVCell: UICollectionViewCell {


    @IBOutlet weak var currentProgressView: UIProgressView!
    @IBOutlet weak var unlockedLevelImage: UIImageView!
    @IBOutlet weak var lockedLevelImage: UIImageView!
    @IBOutlet weak var currentProgressLabel: UILabel!
    @IBOutlet weak var lockedLevelLabel: UILabel!
    @IBOutlet weak var LevelLabel: UILabel!
    
    let progress = Progress(totalUnitCount: 70)
}
