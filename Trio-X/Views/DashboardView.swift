//
//  DashboardView.swift
//  Trio-X
//
//  Created by Kunal Yelne on 27/09/24.
//

import Foundation
import SwiftUI

struct DashboardView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: ProcessMonitoringView( ProcessMonitoringViewModel(MainRepository()))) {
                    Label("Process Monitoring", systemImage: "gearshape")
                }
                NavigationLink(destination: ContentView()) {
                    Label("File Integrity Check", systemImage: "folder")
                }
                NavigationLink(destination: ContentView()) {
                    Label("Security Privileges", systemImage: "shield")
                }
            }
            .listStyle(SidebarListStyle())
            .navigationTitle("Trio-X")
            
            Text("Select a feature")
                .font(.largeTitle)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    DashboardView()
}
