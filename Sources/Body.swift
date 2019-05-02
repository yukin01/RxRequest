//
//  Body.swift
//  RxRequestKit
//
//  Created by Kinjo on 2019/04/30.
//  Copyright © 2019 yukin01. All rights reserved.
//

import Foundation

public enum Body {
    case json(AnyEncodable)
}

extension Body {
    var contentType: String {
        switch self {
        case .json: return "application/json"
        }
    }
    
    var value: Encodable {
        switch self {
        case .json(let value): return value
        }
    }
    
}
