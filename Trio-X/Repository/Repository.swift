//
//  File.swift
//  Trio-X
//
//  Created by Kunal Yelne on 28/09/24.
//

protocol Repository {
    func fetchProcessInfoList() async -> Result<[ProcessInfo], DataRequestError>
    func writeLogToFile(_ log: String) async -> Result<Bool, LogFileUtilsError>
    func openLogFileInFinder()
}
