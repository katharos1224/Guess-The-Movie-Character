//
//  MainViewController.swift
//  app_doan_xe
//
//  Created by Sơn on 03/10/2021.
//

import UIKit

class MainViewController: UIViewController {

    @IBAction func freeCoinsAction() {
    }
    @IBAction func settingAction() {
    }
    @IBAction func rankAction() {
    }
    @IBAction func storeAction() {
    }
    @IBAction func playAction() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ChooseLevelViewController") as! ChooseLevelViewController
        vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        self.present(vc, animated: true)
       // self.navigationController?.pushViewController(vc, animated: true)    }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       print("Insert into")
        // Do any additional setup after loading the view.
    }


}
