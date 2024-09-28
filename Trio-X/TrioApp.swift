//
//  Trio_XApp.swift
//  Trio-X
//
//  Created by Kunal Yelne on 27/09/24.
//

import SwiftUI

@main
struct TrioApp: App {
    // Initialize DI Container
    let container = AppDIContainer().container
    
    var body: some Scene {
        WindowGroup {
            DashboardView()
                .environment(\.diContainer, container) // Add the container to the environment variable
        }
    }
}
