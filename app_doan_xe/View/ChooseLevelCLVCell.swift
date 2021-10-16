//
//  ChooseLevelCLVCell.swift
//  app_doan_xe
//
//  Created by Son on 09/10/2021.
//

import UIKit

class ChooseLevelCLVCell: UICollectionViewCell {

    @IBOutlet weak var imgChooseLvCell: UIImageView!
    @IBOutlet weak var currentProgressBar: UIProgressView!
    @IBOutlet weak var unlockedImageLevel: UIImageView!
    @IBOutlet weak var lockedImageLevel: UIImageView!
    @IBOutlet weak var currentProgressLabel: UILabel!
    @IBOutlet weak var lockedLevelLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
