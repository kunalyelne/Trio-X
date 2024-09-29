//
//  ProcessMonitoringViewModel.swift
//  Trio-X
//
//  Created by Kunal Yelne on 28/09/24.
//

import Foundation

class ProcessMonitoringViewModel: ObservableObject {
    
    @Published var dataRequestState: DataRequestState = .Idle
    @Published var processInfo: [ProcessInfo] = []
    
    private let mainRepository: Repository
    
    init(_ mainRepository: Repository) {
        self.mainRepository = mainRepository
    }
    
    /// Fetches all the running process in the system
    func listRunningProcesses() async {
        // Update the data request state to .Loading
        await MainActor.run { dataRequestState = .Loading }
        
        // Fetch all running processes data
        let result: Result<[ProcessInfo], ProcessUtilError> = await mainRepository.fetchProcessInfoList()
        
        // Ensure the update to view happens on the main thread
        await MainActor.run {
            switch result {
                case .success(let processInfoList):
                    // Process fetched successfully, return data
                    self.processInfo = processInfoList
                    dataRequestState = .Success
                case .failure(let dataRequestError):
                    // Error occurred while fetching process, return error message
                    dataRequestState = .Error(message: dataRequestError.localizedDescription)
            }
        }
    }
}
