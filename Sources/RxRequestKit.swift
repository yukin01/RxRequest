//
//  RxRequestKit.swift
//  RxRequestKit
//
//  Created by yukin01 on 2019/04/28.
//  Copyright © 2019 yukin01. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

internal let SEARCH_REPOSITORIES = "https://api.github.com/search/repositories?q=rxswift+language:swift&sort=stars&order=desc&per_page=1"

public func test() -> Observable<Any> {
    guard let url = URL(string: SEARCH_REPOSITORIES) else { fatalError() }
    let request = URLRequest(url: url)
    let session = URLSession(configuration: .default)
    return session.rx.json(request: request)
}

public protocol State {}
public struct Empty: State {}
public struct HasElement<Element>: State {
    public let element: Element
}
public typealias HasBaseURL = HasElement<String>

public struct RxRequest<BaseURL: State> {
    public static var builder: RxRequest<Empty> {
        return .init(baseURLState: .init())
    }
    
    public func baseURL(_ url: String) -> RxRequest<HasBaseURL> {
        return .init(baseURLState: .init(element: url))
    }
    
    private var baseURLState: BaseURL
}


extension RxRequest where BaseURL == HasBaseURL {
    func build() {
    }
}
