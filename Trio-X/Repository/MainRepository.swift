//
//  MainRepository.swift
//  Trio-X
//
//  Created by Kunal Yelne on 28/09/24.
//

class MainRepository: Repository {
    
    func fetchProcessInfoList() async -> Result<[ProcessInfo], DataRequestError> {
        return await ProcessInfoUtil.shared.fetchRunningProcesses()
    }
    
    func writeLogToFile(_ log: String) async -> Result<Bool, LogFileUtilsError> {
        return await LogFileUtils.shared.writeLogToFile(log)
    }
    
    func openLogFileInFinder() {
        LogFileUtils.shared.openLogFileInFinder()
    }
}
