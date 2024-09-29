//
//  HelperTool.swift
//  HelperTool
//
//  Created by Kunal Yelne on 29/09/24.
//

import Foundation

/// This object implements the protocol which we have defined. It provides the actual behavior for the service. It is 'exported' by the service to make it available to the process hosting the service over an NSXPCConnection.
class HelperTool: NSObject, HelperToolProtocol {
    
    func terminateProcess(withPid pid: Int) async -> Bool {
        let result = kill(pid_t(pid), SIGKILL) // Send SIGKILL signal
        return result == 0
    }
}
