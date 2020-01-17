//
//  ViewController.swift
//  Rxswift+MVVM
//
//  Created by xuanze on 2020/1/16.
//  Copyright © 2020 xuanze. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func jumpToNewViewController(_ sender: Any) {
        let newsVC = NewsViewController()
        newsVC.modalPresentationStyle = .fullScreen
        self.present(newsVC, animated: true, completion: nil)
    }
    
}

