//
//  AnyEncodable.swift
//  RxRequestKit
//
//  Created by Kinjo on 2019/05/02.
//  Copyright © 2019 yukin01. All rights reserved.
//

import Foundation

public struct AnyEncodable: Encodable {
    
    private let encodable: Encodable
    
    public init(_ encodable: Encodable) {
        self.encodable = encodable
    }
    
    public func encode(to encoder: Encoder) throws {
        try encodable.encode(to: encoder)
    }
}
