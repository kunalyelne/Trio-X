//
//  HelperToolProtocol.swift
//  Trio-X
//
//  Created by Kunal Yelne on 29/09/24.
//

import Foundation

@objc protocol HelperToolProtocol {
    func terminateProcess(withPid pid: Int) async -> Bool
}
