//
//  MainRepository.swift
//  Trio-X
//
//  Created by Kunal Yelne on 28/09/24.
//

class MainRepository: Repository {
    
    func fetchProcessInfoList() async -> Result<[ProcessInfo], ProcessUtilError> {
        return await ProcessUtil.shared.fetchRunningProcesses()
    }
    
    func writeLogToFile(_ log: String) async -> Result<Bool, LogFileUtilsError> {
        return await LogFileUtils.shared.writeLogToFile(log)
    }
    
    func openLogFileInFinder() {
        LogFileUtils.shared.openLogFileInFinder()
    }
    
    func terminateProcess(with pid: Int) async -> Result<Bool, ProcessUtilError> {
        return await ProcessUtil.shared.terminateProcess(pid)
    }
    
}
