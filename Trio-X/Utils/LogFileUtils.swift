//
//  FileUtils.swift
//  Trio-X
//
//  Created by Kunal Yelne on 29/09/24.
//

import AppKit

class LogFileUtils {
    
    private var logFileURL: URL?
    public static let shared = LogFileUtils()
    
    private init() {}
    
    // Function to write logs to the log file
    func writeLogToFile(_ log: String) async -> Result<Bool, LogFileUtilsError> {
        
        let logFileURL = setupLogFile()
        
        guard let logFileURL = logFileURL else { return .failure(.UnableToCreateFile) }
        
        if let fileHandle = try? FileHandle(forWritingTo: logFileURL) {
            // Move to the end of the file before writing
            fileHandle.seekToEndOfFile()
            if let logData = (log + "\n").data(using: .utf8) {
                fileHandle.write(logData)
            }
            fileHandle.closeFile()
            return .success(true)
        } else {
            return .failure(.OperationNotpermitted)
        }
    }
    
    // Set up the log file in the documents directory
    private func setupLogFile() -> URL? {
        let fileManager = FileManager.default
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let customFormattedDate = formatter.string(from: Date())
        
        if let documentsDir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            logFileURL = documentsDir.appendingPathComponent("\(customFormattedDate)+fileIntegrityLogs.txt")
            
            // If the file doesn't exist, create it
            if !fileManager.fileExists(atPath: logFileURL!.path) {
                fileManager.createFile(atPath: logFileURL!.path, contents: nil)
            }
            return logFileURL
        }
        return nil
    }
    
    // Function to open the log file in Finder
    func openLogFileInFinder() {
        guard let logFileURL = logFileURL else { return }
        
        // If the file doesn't exist, create it
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: logFileURL.path) {
            fileManager.createFile(atPath: logFileURL.path, contents: nil)
        }
        
        NSWorkspace.shared.activateFileViewerSelecting([logFileURL])
    }
}

enum LogFileUtilsError: Error {
    case UnableToCreateFile
    case OperationNotpermitted
    case UnknownError
}
