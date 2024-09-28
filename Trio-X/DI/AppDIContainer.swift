//
//  AppDIContainer.swift
//  Trio-X
//
//  Created by Kunal Yelne on 28/09/24.
//

import Swinject
import SwiftUICore

class AppDIContainer {
    let container: Container
    
    init() {
        container = Container()
        setupDependencies()
    }
    
    private func setupDependencies() {
        container.register(Repository.self) { r in
            MainRepository()
        }
        container.register(ProcessMonitoringViewModel.self) { r in
            ProcessMonitoringViewModel(r.resolve(Repository.self)!)
        }
    }
}

struct DIContainerKey: EnvironmentKey {
    static let defaultValue: Container = AppDIContainer().container  // Default container
}

extension EnvironmentValues {
    var diContainer: Container {
        get { self[DIContainerKey.self] }
        set { self[DIContainerKey.self] = newValue }
    }
}
