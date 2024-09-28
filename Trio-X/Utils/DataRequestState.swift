//
//  DataRequestState.swift
//  Trio-X
//
//  Created by Kunal Yelne on 28/09/24.
//

import Foundation

/// Enum to represent a data rqeuest status.
enum DataRequestState {
    case Idle
    case Loading
    case Success
    case Error(message: String)
}
