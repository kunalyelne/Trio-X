//
//  FileIntegrityViewModel.swift
//  Trio-X
//
//  Created by Kunal Yelne on 29/09/24.
//

import Foundation

class FileIntegrityViewModel: ObservableObject {
    
    @Published var logMessages: [String] = []
    @Published var errorMessage: String = ""
    @Published var isMonitoring = false
    private var monitor: FileMonitor?
    
    private let mainRepository: Repository
    
    init(_ mainRepository: Repository) {
        self.mainRepository = mainRepository
    }
    
    
    func startMonitoringGivenPath(directoryPath: String) {
        guard !directoryPath.isEmpty else {
            logMessages.append("Please enter a valid directory path.")
            return
        }

        monitor = FileMonitor(path: directoryPath) { [weak self] log in
            // Ensure UI updates happen on the main thread
            DispatchQueue.main.async {
                self?.logMessages.append(log)  // Append log messages to the UI
            }

            Task {
               // Handle file writing asynchronously
                let result: Result<Bool, LogFileUtilsError>? = await self?.mainRepository.writeLogToFile(log)  // Call the async method safely
                
                if let result {
                    switch result {
                    case .success:
                        break
                    case .failure(let logFileUtilsError):
                        self?.errorMessage = "Error writing to file: \(logFileUtilsError.localizedDescription)."
                    }
                }
           }
        }
        
        isMonitoring = true
    }
    
    func stopMonitoring() {
        monitor?.stop() // Stop the monitoring
        monitor = nil
        isMonitoring = false
    }
    
    func openLogFileInFinder() {
        self.mainRepository.openLogFileInFinder()
    }
    
    deinit {
        monitor?.stop()
    }
}
