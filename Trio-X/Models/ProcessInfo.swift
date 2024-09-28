//
//  ProcessInfo.swift
//  Trio-X
//
//  Created by Kunal Yelne on 28/09/24.
//

import Foundation
import SwiftUI

/// Structure to represent a process with its name, PID, and icon.
struct ProcessInfo: Identifiable {
    let id = UUID()
    let pid: Int32
    let name: String
    let icon: NSImage
}
