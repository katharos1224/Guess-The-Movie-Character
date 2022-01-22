//
//  CorrectViewController.swift
//  app_doan_xe
//
//  Created by Son on 22/01/2022.
//

import UIKit

class CorrectViewController: UIViewController {
    @IBOutlet weak var rewardCoins: UILabel!
    @IBAction func nextButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ChooseLevelViewController") as! ChooseLevelViewController
        vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        self.present(vc, animated: true)
       // self.navigationController?.pushViewController(vc, animated: true)    }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rewardCoins.text = "0"

        // Do any additional setup after loading the view.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
