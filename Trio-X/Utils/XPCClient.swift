//
//  XPCClient.swift
//  Trio-X
//
//  Created by Kunal Yelne on 29/09/24.
//

import Foundation

class XPCClient {
    private var connection: NSXPCConnection?

    init() {
        // Establish a connection to the helper tool
        connection = NSXPCConnection(serviceName: "io.github.kunalyelne.HelperTool")
        connection?.remoteObjectInterface = NSXPCInterface(with: HelperToolProtocol.self)
        connection?.resume()
    }

    /// Terminates the given process PID
    func terminateProcess(pid: Int) async -> Bool {
        let helper = connection?.remoteObjectProxy as? HelperToolProtocol
        let result =  await helper?.terminateProcess(withPid: pid)
        return result ?? false
    }

    deinit {
        connection?.invalidate()
    }
}
