//
//  DashboardView.swift
//  Trio-X
//
//  Created by Kunal Yelne on 27/09/24.
//

import SwiftUI
import Swinject

struct DashboardView: View {
    
    @Environment(\.diContainer) private var diContainer: Container
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: ProcessMonitoringView(diContainer.resolve(ProcessMonitoringViewModel.self)!)) {
                    Label("Process Monitoring", systemImage: "gearshape")
                }
                NavigationLink(destination: FileIntegrityView(diContainer.resolve(FileIntegrityViewModel.self)!)) {
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
