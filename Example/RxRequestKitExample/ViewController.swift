//
//  ViewController.swift
//  RxRequestKitExample
//
//  Created by Kinjo on 2019/04/28.
//  Copyright © 2019 yukin01. All rights reserved.
//

import UIKit
import RxRequestKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        _ = RxRequestKit.test().subscribe(onNext: { print($0) })
    }


}

