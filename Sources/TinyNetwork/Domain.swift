//
//  Domain.swift
//  TinyNetwork
//
//  Created by Andreas Osberghaus on 25.11.20.
//

import Foundation

public protocol Domain {
    var host: String { get }
    var scheme: String { get }
}
