//
//  QueryAgentError.swift
//  VENI VIDI
//
//  Created by 雲無心 on 4/13/21.
//

import Foundation

enum QueryAgentError: String, Error {
    case urlError
    case noData
    case cannotDecodeData
}
