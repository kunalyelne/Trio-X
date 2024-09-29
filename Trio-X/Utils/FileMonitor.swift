//
//  FileMonitor.swift
//  Trio-X
//
//  Created by Kunal Yelne on 29/09/24.
//

import Foundation

class FileMonitor {
    private var streamRef: FSEventStreamRef?
    private let onChange: (String) -> Void
    
    init(path: String, onChange: @escaping (String) -> Void) {
        self.onChange = onChange
        startMonitoring(path: path)
    }
    
    private func startMonitoring(path: String) {
        let pathsToWatch = [path] as CFArray
        let latency: CFTimeInterval = 1.0 // Latency in seconds
        
        // Create a context to pass self to the callback function
        var context = FSEventStreamContext(
            version: 0,
            info: UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque()),
            retain: nil,
            release: nil,
            copyDescription: nil
        )
        
        let callback: FSEventStreamCallback = { (streamRef, clientCallBackInfo, numEvents, eventPaths, eventFlags, eventIds) in
            let fileMonitorInstance = Unmanaged<FileMonitor>.fromOpaque(clientCallBackInfo!).takeUnretainedValue()
            fileMonitorInstance.handleEvent(numEvents: numEvents, eventPaths: eventPaths, eventFlags: eventFlags)
        }
        
        // Create the event stream
        streamRef = FSEventStreamCreate(nil,
                                        callback,
                                        &context, // Pass the context
                                        pathsToWatch,
                                        FSEventStreamEventId(kFSEventStreamEventIdSinceNow),
                                        latency,
                                        FSEventStreamCreateFlags(kFSEventStreamCreateFlagFileEvents))
        
        // Set the dispatch queue for the stream
        if let streamRef = streamRef {
            FSEventStreamSetDispatchQueue(streamRef, DispatchQueue.global())
            FSEventStreamStart(streamRef)
        }
    }
    
    private func handleEvent(numEvents: Int, eventPaths: UnsafeMutableRawPointer?, eventFlags: UnsafePointer<FSEventStreamEventFlags>) {
        // Safely cast eventPaths to a pointer of C strings (array of paths)
        let paths = unsafeBitCast(eventPaths, to: UnsafePointer<UnsafePointer<CChar>>.self)

        for i in 0..<numEvents {
            let path = String(cString: paths[i])  // Convert each C string to a Swift String
            let flags = eventFlags[i]
            
            
            guard let eventDetail = getEventDetail(Int(flags)) else {
                return
            }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = formatter.string(from: Date())
            
            var eventDescription = "\(date) - Event detected at - "
            
            // Additional checks for file type (directory, symlink, etc.)
            if (Int(flags) & kFSEventStreamEventFlagItemIsFile) != 0 {
                eventDescription += "[File] - \(path): "
            }
            if (Int(flags) & kFSEventStreamEventFlagItemIsDir) != 0 {
                eventDescription += "[Directory] - \(path): "
            }
            if (Int(flags) & kFSEventStreamEventFlagItemIsSymlink) != 0 {
                eventDescription += "[Symlink] - \(path): "
            }
            
            eventDescription += eventDetail
        
            self.onChange(eventDescription)
        }
    }
    
    func getEventDetail(_ flag: Int) -> String? {
        if (flag & kFSEventStreamEventFlagItemCreated) != 0 {
            return "Created"
        }
        if (flag & kFSEventStreamEventFlagItemRemoved) != 0 {
            return "Removed"
        }
        if (flag & kFSEventStreamEventFlagItemRenamed) != 0 {
            return "Renamed"
        }
        if (flag & kFSEventStreamEventFlagItemModified) != 0 {
            return "Modified"
        }
        return nil
    }
    
    func stop() {
        if let streamRef = streamRef {
            FSEventStreamStop(streamRef)
            FSEventStreamInvalidate(streamRef)
            FSEventStreamRelease(streamRef)
        }
    }
}
