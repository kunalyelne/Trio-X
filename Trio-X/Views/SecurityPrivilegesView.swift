//
//  SecurityPrivilegesView.swift
//  Trio-X
//
//  Created by Kunal Yelne on 29/09/24.
//

import SwiftUI
import Foundation
import Security

struct SecurityPrivilegesView: View {
    @State private var pidInput: String = ""
    @State private var resultMessage: String = ""
    @State private var isHelperInstalled: Bool = false
    
    @StateObject private var securityPrivilegesViewModel: SecurityPrivilegesViewModel
    
    init(_ securityPrivilegesViewModel: SecurityPrivilegesViewModel) {
        _securityPrivilegesViewModel = StateObject(wrappedValue: securityPrivilegesViewModel)
    }
    
    var body: some View {
        VStack {
            Text("Security Privileges")
                .font(.largeTitle)
                .padding()
            
            TextField("Enter Process ID (PID)", text: $pidInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Terminate Process") {
                if let pid = Int(pidInput) {
                    securityPrivilegesViewModel.terminateProcess(with: pid)
                } else {
                    resultMessage = "Invalid PID"
                }
            }
            .padding()
            
            switch securityPrivilegesViewModel.dataRequestState {
                case .Idle:
                    // Render Text if result is not empty
                    if resultMessage.isEmpty {
                        EmptyView()
                    } else {
                        Text(resultMessage)
                            .foregroundColor(.red)
                    }
                case .Loading:
                    // Render Loader UI
                    ProgressView("Loading...")
                case .Success:
                    // Render Success Text
                    Text("Process Terminated Successfully!")
                        .foregroundColor(.green)
                        .padding()
                case .Error(let message):
                    // Render Error Text
                    Text("Error occurred :( \(message)")
                        .foregroundColor(.red)
            }
        }
        .padding()
        .onDisappear {
            securityPrivilegesViewModel.resetData()
            pidInput = ""
            resultMessage = ""
        }
    }
}

#Preview {
    let container = AppDIContainer().container
    let securityPrivilegesViewModel = container.resolve(SecurityPrivilegesViewModel.self)!
    return SecurityPrivilegesView(securityPrivilegesViewModel)
}
