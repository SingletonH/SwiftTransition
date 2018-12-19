//
//  TranstionViewController.swift
//  SwiftTransition
//
//  Created by iOS on 2018/12/11.
//  Copyright © 2018 AidaHe. All rights reserved.
//

import UIKit

class TranstionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "UIModalTransitionStyle"
    }

    @IBAction func presentWithCoverVertical(_ sender: Any) {
        let nextVC = SecondViewController()
        nextVC.modalTransitionStyle = .coverVertical
        self.present(nextVC, animated: true, completion: nil)
    }
    
    @IBAction func presentWithFlipHorizontal(_ sender: Any) {
        let nextVC = SecondViewController()
        nextVC.modalTransitionStyle = .flipHorizontal
        self.present(nextVC, animated: true, completion: nil)
    }
    
    @IBAction func presentWithCrossDissolve(_ sender: Any) {
        let nextVC = SecondViewController()
        nextVC.modalTransitionStyle = .crossDissolve
        self.present(nextVC, animated: true, completion: nil)
    }
    
    @IBAction func presentWithPartialCurl(_ sender: Any) {
        let nextVC = SecondViewController()
        nextVC.modalTransitionStyle = .partialCurl
        self.present(nextVC, animated: true, completion: nil)
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
