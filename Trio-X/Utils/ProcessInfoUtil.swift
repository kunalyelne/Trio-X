//
//  ProcessInfoUtil.swift
//  Trio-X
//
//  Created by Kunal Yelne on 28/09/24.
//

import Foundation
import AppKit
import OSLog

class ProcessInfoUtil {
    
    public static let shared = ProcessInfoUtil()
    
    private init() {}

    func fetchRunningProcesses() async -> Result<[ProcessInfo], DataRequestError> {
        var processList: [ProcessInfo] = []
        
        let task = Process()
        task.launchPath = "/bin/ps"
        task.arguments = ["-e", "-o", "pid=,comm="]
        
        let pipe = Pipe()
        task.standardOutput = pipe
        let outputHandle = pipe.fileHandleForReading
        
        do {
            try task.run()
        } catch {
            print("Failed to launch process: \(error.localizedDescription)")
            return .failure(.OperationNotpermitted(error))  // Return error if the fetch fails
        }

        let data = outputHandle.readDataToEndOfFile()
        task.waitUntilExit()
        
        let output = String(data: data, encoding: .utf8) ?? ""
        
        output.enumerateLines { line, _ in
            let components = line.split(separator: " ", maxSplits: 1)
            if components.count == 2, let pid = Int32(components[0]) {
                let processName = (components[1] as NSString).lastPathComponent
                
                let icon = self.getAppIcon(forPID: pid)
                processList.append(ProcessInfo(pid: pid, name: processName, icon: icon))
            } else {
                os_log("invaild process line: \(line)")
            }
        }
        
        return .success(processList)
    }

    func getAppIcon(forPID pid: pid_t) -> NSImage {
        // Retrieve the running application using the PID
        if let runningApp = NSRunningApplication(processIdentifier: pid) {
            // Get the application icon, if available
            return runningApp.icon ?? NSImage(named: NSImage.applicationIconName) ?? NSImage()
        }
        
        // Return a system-provided application icon as a fallback
        return NSImage(named: NSImage.applicationIconName) ?? NSImage()
    }
}

enum DataRequestError: Error {
    case OperationNotpermitted(Error)
    case UnknownError(Error)
}
