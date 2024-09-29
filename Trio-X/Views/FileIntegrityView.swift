//
//  FileIntegrityView.swift
//  Trio-X
//
//  Created by Kunal Yelne on 28/09/24.
//

import SwiftUI

struct FileIntegrityView: View {
    
    @State private var directoryPath: String = ""
    
    @StateObject private var fileIntegrityViewModel: FileIntegrityViewModel
    
    init(_ fileIntegrityViewModel: FileIntegrityViewModel) {
        _fileIntegrityViewModel = StateObject(wrappedValue: fileIntegrityViewModel)
    }

    var body: some View {
        VStack {
            Text("File Integrity Check")
                .font(.largeTitle)
                .padding()
            
            TextField("Enter directory path", text: $directoryPath)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            // Button to start monitoring the given directory
            Button(fileIntegrityViewModel.isMonitoring ? "Stop Monitoring" : "Start Monitoring") {
                if fileIntegrityViewModel.isMonitoring {
                    fileIntegrityViewModel.stopMonitoring()
                } else {
                    fileIntegrityViewModel.startMonitoringGivenPath(directoryPath: directoryPath)
                }
            }
            .padding()
            .disabled(directoryPath.isEmpty) // Disable button if path is empty

            if !fileIntegrityViewModel.errorMessage.isEmpty {
                // Error Message
                Section {
                    Text("Error occurred :( \(fileIntegrityViewModel.errorMessage)")
                        .foregroundColor(.red)
                }
            } else {
                List(fileIntegrityViewModel.logMessages, id: \.self) { log in
                    Text(log)
                }
                
                // Button to open log file in Finder
                Button("Open Log File in Finder") {
                    fileIntegrityViewModel.openLogFileInFinder()
                }
                .padding()
                .disabled(fileIntegrityViewModel.logMessages.isEmpty) // Disable button until the logs are written to the disk
            }
        }
        .padding()
        .onDisappear {
            fileIntegrityViewModel.stopMonitoring() // Stop monitoring when the view disappears
        }
    }
}

#Preview {
    let container = AppDIContainer().container
    let fileIntegrityViewModel = container.resolve(FileIntegrityViewModel.self)!
    return FileIntegrityView(fileIntegrityViewModel)
}
