//
//  Request.swift
//  RxRequestKit
//
//  Created by yukin01 on 2019/04/29.
//  Copyright © 2019 yukin01. All rights reserved.
//

import Foundation

public protocol State {}
public struct Empty: State {}
public struct HasElement<Element>: State {
    public let element: Element
}
public typealias HasString = HasElement<String>
public typealias HasOptions = HasElement<(URLRequest.CachePolicy, TimeInterval)>

public enum Method: String {
    case get
    case post
    case put
    case patch
    case delete
}

extension Method: CustomStringConvertible {
    public var description: String {
        return self.rawValue.uppercased()
    }
}

public typealias HasMethod = HasElement<Method>

public struct Request<BaseURLState: State, OptionsState: State, MethodState: State> {
    
    public static var builder: Request<Empty, Empty, Empty> {
        return .init(baseURLState: .init(), optionsState: .init(), methodState: .init())
    }
    
    public func set(baseURL: String) -> Request<HasString, OptionsState, MethodState> {
        return .init(
            baseURLState: .init(element: baseURL),
            optionsState: optionsState,
            methodState: methodState
        )
    }
    
    public func set(cachePolicy: URLRequest.CachePolicy, timeoutInterval: TimeInterval)
        -> Request<BaseURLState, HasOptions, MethodState> {
        return .init(
            baseURLState: baseURLState,
            optionsState: .init(element: (cachePolicy, timeoutInterval)),
            methodState: methodState
        )
    }
    
    public func set(method: Method) -> Request<BaseURLState, OptionsState, HasMethod> {
        return .init(
            baseURLState: baseURLState,
            optionsState: optionsState,
            methodState: .init(element: method)
        )
    }
    
    private var baseURLState: BaseURLState
    private var optionsState: OptionsState
    private var methodState: MethodState
}

extension Request where BaseURLState == HasString, MethodState == HasMethod {
    public func build() -> URLRequest? {
        guard let url = URL(string: baseURLState.element) else { return nil }
        
        var request: URLRequest
        if let o = optionsState as? HasOptions {
            let (policy, interval) = o.element
            request = URLRequest(url: url, cachePolicy: policy, timeoutInterval: interval)
        } else {
            request = URLRequest(url: url)
        }
        
        request.httpMethod = methodState.element.description
        
        return request
    }
}
