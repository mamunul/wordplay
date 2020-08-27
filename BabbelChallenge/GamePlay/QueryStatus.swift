//
//  QueryStatus.swift
//  BabbelChallenge
//
//  Created by Mamunul Mazid on 8/27/20.
//

import Foundation
import SwiftUI

enum QueryStatus {
    case ongoing
    case wrong
    case skipped
    case correct

    func getTextAndColor() -> (String, Color) {
        switch self {
        case .ongoing:
            return ("", Color.green)
        case .wrong:
            return ("Incorrect", Color.red)
        case .skipped:
            return ("Incorrect", Color.yellow)
        case .correct:
            return ("Correct", Color.green)
        }
    }
}
