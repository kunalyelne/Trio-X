//
//  CustomViews.swift
//  Trio-X
//
//  Created by Kunal Yelne on 28/09/24.
//

import SwiftUI

func renderProcessTable(for processInfo: [ProcessInfo]) -> some View {
    if processInfo.isEmpty {
        AnyView(Text("No processes found")
            .foregroundColor(.secondary))
    } else {
        AnyView(
            VStack {
                Text("Running Processes")
                    .font(.largeTitle)
                    .padding()
                
                Table(processInfo) {
                    // Process Name (Icon + Name) Column
                    TableColumn("Process Name") { process in
                        HStack {
                            Image(nsImage: process.icon)  // Display process icon
                                .resizable()
                                .frame(width: 20, height: 20)  // Resize the icon
                                .clipShape(Circle())
                            Text(process.name) // Display process name
                        }
                    }
                    // PID Column
                    TableColumn("PID") { process in
                        Text("\(String(process.pid))")
                    }
                }
            }
        )
    }
}
