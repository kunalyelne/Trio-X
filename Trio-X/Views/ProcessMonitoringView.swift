//
//  ProcessMonitorView.swift
//  Trio-X
//
//  Created by Kunal Yelne on 28/09/24.
//

import SwiftUI

struct ProcessMonitoringView: View {
    
    @StateObject private var processMonitoringViewModel: ProcessMonitoringViewModel
    
    init(_ processMonitoringViewModel: ProcessMonitoringViewModel) {
        _processMonitoringViewModel = StateObject(wrappedValue: processMonitoringViewModel)
    }
    
    var body: some View {
        VStack {
            switch processMonitoringViewModel.dataRequestState {
                case .Idle:
                    // Render Empty UI
                    EmptyView()
                case .Loading:
                    // Render Loader UI
                    ProgressView("Loading...")
                case .Success:
                    // Render Table UI for fetched data
                    renderProcessTable(for: processMonitoringViewModel.processInfo)
                case .Error(let message):
                    Section {
                        Text("Error occurred :( \(message)")
                            .foregroundColor(.red)
                    }
            }
            
        }
        .padding()
        .task {
            await processMonitoringViewModel.listRunningProcesses()
        }
    }
}

#Preview {
    let container = AppDIContainer().container
    let processMonitoringViewModel = container.resolve(ProcessMonitoringViewModel.self)!
    return ProcessMonitoringView(processMonitoringViewModel)
}
