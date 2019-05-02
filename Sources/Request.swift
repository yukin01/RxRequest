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
public typealias HasBody = HasElement<Body>

public struct Request<BaseURLState: State, QueryState: State, OptionsState: State, MethodState: State, BodyState: State> {
    
    private let baseURLState: BaseURLState
    private let queryState: QueryState
    private let optionsState: OptionsState
    private let methodState: MethodState
    private let bodyState: BodyState
    
    public static var builder: Request<Empty, Empty, Empty, Empty, Empty> {
        return .init(
            baseURLState: .init(),
            queryState: .init(),
            optionsState: .init(),
            methodState: .init(),
            bodyState: .init()
        )
    }
    
    public func set(baseURL: String) -> Request<HasString, QueryState, OptionsState, MethodState, BodyState> {
        return .init(
            baseURLState: .init(element: baseURL),
            queryState: queryState,
            optionsState: optionsState,
            methodState: methodState,
            bodyState: bodyState
        )
    }
    
    public func set(query: [String: String]) -> Request<BaseURLState, HasDictionary, OptionsState, MethodState, BodyState> {
        return .init(
            baseURLState: baseURLState,
            queryState: .init(element: query),
            optionsState: optionsState,
            methodState: methodState,
            bodyState: bodyState
        )
    }
    
    public func set(cachePolicy: URLRequest.CachePolicy, timeoutInterval: TimeInterval)
        -> Request<BaseURLState, QueryState, HasOptions, MethodState, BodyState> {
        return .init(
            baseURLState: baseURLState,
            queryState: queryState,
            optionsState: .init(element: (cachePolicy, timeoutInterval)),
            methodState: methodState,
            bodyState: bodyState
        )
    }
    
    public func set(method: Method) -> Request<BaseURLState, QueryState, OptionsState, HasMethod, BodyState> {
        return .init(
            baseURLState: baseURLState,
            queryState: queryState,
            optionsState: optionsState,
            methodState: .init(element: method),
            bodyState: bodyState
        )
    }
    
    public func set<T: Encodable>(body: T) -> Request<BaseURLState, QueryState, OptionsState, MethodState, HasBody> {
        return .init(
            baseURLState: baseURLState,
            queryState: queryState,
            optionsState: optionsState,
            methodState: methodState,
            bodyState: .init(element: .json(AnyEncodable(body)))
        )
    }
}

extension Request where BaseURLState == HasString {
    public func build() -> URLRequest? {
        guard var components = URLComponents(string: baseURLState.element) else { return nil }
        
        if let q = queryState as? HasDictionary {
            components.queryItems = q.element.map { URLQueryItem(name: $0, value: $1) }
        }
        
        guard let url = components.url else { return nil }
        
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
        
        if let b = bodyState as? HasBody {
            switch b.element {
            case .json(let value):
                request.httpBody = try? JSONEncoder().encode(value)
            }
        }
        
        return request
    }
}
