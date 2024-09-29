//
//  File.swift
//  Trio-X
//
//  Created by Kunal Yelne on 28/09/24.
//

protocol Repository {
    func fetchProcessInfoList() async -> Result<[ProcessInfo], ProcessUtilError>
    func writeLogToFile(_ log: String) async -> Result<Bool, LogFileUtilsError>
    func openLogFileInFinder()
    func terminateProcess(with pid: Int) async -> Result<Bool, ProcessUtilError>
}
