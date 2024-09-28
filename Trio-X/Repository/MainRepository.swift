//
//  MainRepository.swift
//  Trio-X
//
//  Created by Kunal Yelne on 28/09/24.
//

import Foundation

class MainRepository: Repository {
    
    func fetchProcessInfoList() async -> Result<[ProcessInfo], DataRequestError> {
        return await ProcessInfoUtil.shared.fetchRunningProcesses()
    }
}
