//
//  ViewController.swift
//  RxRequestKitExample
//
//  Created by Kinjo on 2019/04/28.
//  Copyright © 2019 yukin01. All rights reserved.
//

import UIKit
import RxSwift
import RxRequestKit

class ViewController: UIViewController {

    let SEARCH_REPOSITORIES = "https://api.github.com/search/repositories?q=rxswift+language:swift&sort=stars&order=desc&per_page=1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = Request.builder
            .set(baseURL: SEARCH_REPOSITORIES)
            .set(method: .get)
            .send()
            .debug()
            .subscribe()
    }


}

