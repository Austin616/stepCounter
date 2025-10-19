//
//  ContentView.swift
//  stepCounter
//
//  Created by Austin Tran on 10/19/25.
//

import SwiftUI

struct ContentView: View {
    @State private var healthStore = HealthStore()

    var body: some View {
        TabView {
            NavigationView {
                StepListViewWithToday(steps: healthStore.steps)
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

// Custom wrapper view for the combined List
struct StepListViewWithToday: View {
    let steps: [Step]
    var body: some View {
        List {
            // Today view as first item
            Section {
                TodayStepView(steps: steps)
            }
            // Then your step rows
            Section {
                ForEach(steps) { step in
                    NavigationLink(destination: DetailedDayView(steps: [step])) {
                        HStack {
                            Circle()
                                .frame(width: 20, height: 20)
                                .foregroundColor(isUnderGoal(steps: step.count, goal: 5000) ? .red : .green)
                            Text("\(step.count) steps")
                            Spacer()
                            Text(step.date.formatted(date: .abbreviated, time: .omitted))
                        }
                    }
                }
            }
        }
        .listRowBackground(Color.white)
        .background(Color.white)
        .scrollContentBackground(.hidden)
    }
}


#Preview {
    ContentView()
}

