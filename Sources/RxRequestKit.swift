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

extension Request where BaseURLState == HasString {
    public func send<Response: Decodable>(_ returnType: Response.Type) -> Observable<Response> {
        guard let request = buildRequest() else { return .empty() }
        return URLSession.shared.rx
            .data(request: request)
            .map { data in
                if "" is Response {
                    return (String(data: data, encoding: .utf8) ?? "") as! Response
                } else {
                    let decoder = JSONDecoder()
                    do {
                        return try decoder.decode(Response.self, from: data)
                    }
                }
        }
    }
    
    public func send() -> Observable<Void> {
        guard let request = buildRequest() else { return .empty() }
        return URLSession.shared.rx
            .data(request: request)
            .map { _ in () }
    }
    
    public func json() -> Observable<Any> {
        guard let request = buildRequest() else { return .empty() }
        return URLSession.shared.rx.json(request: request)
    }
}
