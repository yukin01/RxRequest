//
//  Request.swift
//  RxRequestKit
//
//  Created by yukin01 on 2019/04/29.
//  Copyright © 2019 yukin01. All rights reserved.
//

import Foundation

public class State {}
public class Empty: State {}
public class HasElement<Element>: State {
    public let element: Element
    init(element: Element) {
        self.element = element
    }
}

public typealias HasString = HasElement<String>
public typealias HasDictionary = HasElement<[String: String]>
public typealias HasOptions = HasElement<(URLRequest.CachePolicy, TimeInterval)>
public typealias HasMethod = HasElement<Method>

public struct Request<BaseURLState: State, QueryState: State, OptionsState: State, MethodState: State> {
    
    private let baseURLState: BaseURLState
    private let queryState: QueryState
    private let optionsState: OptionsState
    private let methodState: MethodState
    
    public static var builder: Request<Empty, Empty, Empty, Empty> {
        return .init(
            baseURLState: .init(),
            queryState: .init(),
            optionsState: .init(),
            methodState: .init()
        )
    }
    
    public func set(baseURL: String) -> Request<HasString, QueryState, OptionsState, MethodState> {
        return .init(
            baseURLState: .init(element: baseURL),
            queryState: queryState,
            optionsState: optionsState,
            methodState: methodState
        )
    }
    
    public func set(query: [String: String]) -> Request<BaseURLState, HasDictionary, OptionsState, MethodState> {
        return .init(
            baseURLState: baseURLState,
            queryState: .init(element: query),
            optionsState: optionsState,
            methodState: methodState
        )
    }
    
    public func set(cachePolicy: URLRequest.CachePolicy, timeoutInterval: TimeInterval)
        -> Request<BaseURLState, QueryState, HasOptions, MethodState> {
        return .init(
            baseURLState: baseURLState,
            queryState: queryState,
            optionsState: .init(element: (cachePolicy, timeoutInterval)),
            methodState: methodState
        )
    }
    
    public func set(method: Method) -> Request<BaseURLState, QueryState, OptionsState, HasMethod> {
        return .init(
            baseURLState: baseURLState,
            queryState: queryState,
            optionsState: optionsState,
            methodState: .init(element: method)
        )
    }
}

extension Request where BaseURLState == HasString {
    public func build() -> URLRequest? {
        guard var components = URLComponents(string: baseURLState.element) else { return nil }
        
        if let q = queryState as? HasDictionary {
            components.queryItems = q.element.map { URLQueryItem(name: $0, value: $1) }
        }
        
        guard let url = URL(string: baseURLState.element) else { return nil }
        
        var request: URLRequest
        if let o = optionsState as? HasOptions {
            let (policy, interval) = o.element
            request = URLRequest(url: url, cachePolicy: policy, timeoutInterval: interval)
        } else {
            request = URLRequest(url: url)
        }
        
        if let m = methodState as? HasMethod {
            request.httpMethod = m.element.description
        }
        
        return request
    }
}
