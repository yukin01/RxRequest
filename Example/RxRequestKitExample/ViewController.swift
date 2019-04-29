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
    
    func test() -> Observable<Any> {
        //    guard let url = URL(string: SEARCH_REPOSITORIES) else { fatalError() }
        //    let request = URLRequest(url: url)
        let request = Request<HasString, Empty, HasMethod>.builder.set(baseURL: SEARCH_REPOSITORIES).set(method: .get).build()!
        let session = URLSession(configuration: .default)
        return session.rx.json(request: request)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        _ = test().debug().subscribe()
    }


}

