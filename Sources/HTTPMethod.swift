//
//  HTTPMethod.swift
//  RxRequestKit
//
//  Created by yukin01 on 2019/04/29.
//  Copyright © 2019 yukin01. All rights reserved.
//

import Foundation

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
