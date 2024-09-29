//
//  ProcessInfoUtil.swift
//  Trio-X
//
//  Created by Kunal Yelne on 28/09/24.
//

import Foundation
import AppKit
import OSLog
import ServiceManagement

class ProcessUtil {
    
    public static let shared = ProcessUtil()
    
    private init() {}

    /// Fetch all running process in the system
    func fetchRunningProcesses() async -> Result<[ProcessInfo], ProcessUtilError> {
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

    /// Returns the app icon for the running process else default icon
    private func getAppIcon(forPID pid: pid_t) -> NSImage {
        // Retrieve the running application using the PID
        if let runningApp = NSRunningApplication(processIdentifier: pid) {
            // Get the application icon, if available
            return runningApp.icon ?? NSImage(named: NSImage.applicationIconName) ?? NSImage()
        }
        
        // Return a system-provided application icon as a fallback
        return NSImage(named: NSImage.applicationIconName) ?? NSImage()
    }
    
    /// Terminates the given process PID
    func terminateProcess(_ pid: Int) async -> Result<Bool, ProcessUtilError> {
        if !isHelperToolInstalled() {
            installHelperTool()
        }
        let xpcClient = XPCClient()
        let result = await xpcClient.terminateProcess(pid: pid)
        if result {
            return .success(true)
        } else {
            return .failure(.ProcessTerminationFailed)
        }
    }
    
    
    /// Utility method to check whether the helper is installed or not
    func isHelperToolInstalled() -> Bool {
        // Specify the path to the helper tool
        let helperToolPath = "/Library/PrivilegedHelperTools/io.github.kunalyelne.HelperTool"
        
        // Check if the helper tool exists at the specified path
        return FileManager.default.fileExists(atPath: helperToolPath)
    }
    
    /// Installs the helper tool
    func installHelperTool() {
        // Attempt to register the helper tool using AMPService
        let helperService = SMAppService.mainApp
        
        do {
            // Attempt to register (install) the helper tool
            try helperService.register()
            print("Helper tool installed successfully")
        } catch {
            // Handle any errors during registration
            print("Failed to install helper tool: \(error.localizedDescription)")
        }
    }

}

/// Process Utis related error
enum ProcessUtilError: Error {
    case OperationNotpermitted(Error)
    case ProcessTerminationFailed
    case UnknownError(Error)
}
