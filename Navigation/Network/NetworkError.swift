//
//  NetworkError.swift
//  Navigation
//
//  Created by Simon Pegg on 23.11.2022.
//

import Foundation

enum NetworkError: Error {
    case `default`
    case serverError
    case parseError(reason: String)
    case unknownError
}
