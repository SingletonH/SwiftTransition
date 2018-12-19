//
//  AnimatViewController.swift
//  SwiftTransition
//
//  Created by iOS on 2018/12/12.
//  Copyright © 2018 AidaHe. All rights reserved.
//

import UIKit

class AnimatViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.imageTab(_:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
//
//        UIView.animate(withDuration: 0.5, animations: {
//            self.imageView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
//
//        }) { (_) in
//
//        }
    }

    @objc func imageTab(_ sender: UIGestureRecognizer){
        print("animating--")
        UIView.animate(withDuration: 0.3, animations: {
            self.imageView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
            
        }) { (_) in
            
        }
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
