//
//  SecurityPrivilegesViewModel.swift
//  Trio-X
//
//  Created by Kunal Yelne on 29/09/24.
//

import Foundation

class SecurityPrivilegesViewModel: ObservableObject {
    
    @Published var dataRequestState: DataRequestState = .Idle
    
    private let mainRepository: Repository
    
    init(_ mainRepository: Repository) {
        self.mainRepository = mainRepository
    }
    
    /// Terminates the given process pid
    func terminateProcess(with pid: Int) {
        // Update the data request state to .Loading
        dataRequestState = .Loading
        
        // Fetch all running processes data
        Task {
            let result: Result<Bool, ProcessUtilError> = await mainRepository.terminateProcess(with: pid)
            // Ensure the update to view happens on the main thread
            await MainActor.run {
                switch result {
                    case .success(_):
                        // Process terminated successfully
                        dataRequestState = .Success
                    case .failure(let processUtilFailure):
                        // Error occurred while terminating the process, return error message
                        dataRequestState = .Error(message: processUtilFailure.localizedDescription)
                }
            }
        }
    }
    
    func resetData() {
        dataRequestState = .Idle
    }
}
