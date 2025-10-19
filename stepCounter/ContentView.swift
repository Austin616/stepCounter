//
//  ContentView.swift
//  stepCounter
//
//  Created by Austin Tran on 10/19/25.
//

import SwiftUI

enum ViewMode: String, CaseIterable {
    case list = "List"
    case chart = "Chart"
}

struct ContentView: View {
    @State private var healthStore = HealthStore()
    @State private var selectedView: ViewMode = .list

    var body: some View {
        TabView {
            NavigationView {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        // Display today's steps
                        TodayStepView(steps: Array(healthStore.steps))
                        
                        // Segmented Control
                        Picker("View Mode", selection: $selectedView) {
                            ForEach(ViewMode.allCases, id: \.self) { mode in
                                Text(mode.rawValue).tag(mode)
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal)
                        
                        // Conditional View
                        switch selectedView {
                        case .list:
                            StepListView(steps: Array(healthStore.steps.dropFirst()))
                        case .chart:
                            StepChartView(steps: Array(healthStore.steps.dropFirst()))
                        }
                    }
                    .padding()
                }
                .navigationTitle("Home")
            }
            .task {
                await healthStore.requestAuthorization()
                do {
                    try await healthStore.calculateSteps()
                } catch {
                    print(error)
                }
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

#Preview {
    ContentView()
}
