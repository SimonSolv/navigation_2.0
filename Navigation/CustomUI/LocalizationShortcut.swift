//
//  LocalizationShortcut.swift
//  Navigation
//
//  Created by Simon Pegg on 18.01.2023.
//

import Foundation

postfix operator ~

postfix func ~ (string: String) -> String {
    return NSLocalizedString(string, comment: "")
}
