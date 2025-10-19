//
//  DetailedDayView.swift
//  stepCounter
//
//  Created by Austin Tran on 10/19/25.
//

import SwiftUI
import Charts

struct DetailedDayView: View {
    let steps: [Step]
    @State private var hourlySteps: [Step] = []
    @State private var healthStore = HealthStore()
    @AppStorage("stepGoal") var goal: Int = 10000
    
    private var selectedDate: Date {
        steps.first?.date ?? Date()
    }
    
    private var totalSteps: Int {
        hourlySteps.reduce(0) { $0 + $1.count }
    }
    
    private var peakHour: Step? {
        hourlySteps.max(by: { $0.count < $1.count })
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Summary Card
                VStack(alignment: .leading, spacing: 12) {
                    Text(selectedDate.formatted(date: .complete, time: .omitted))
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    HStack(alignment: .bottom, spacing: 4) {
                        Text("\(totalSteps)")
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: totalSteps >= goal
                                        ? [Color(red: 0.51, green: 0.82, blue: 0.29), Color(red: 0.40, green: 0.72, blue: 0.20)]
                                        : [Color(red: 1.0, green: 0.58, blue: 0.0), Color(red: 1.0, green: 0.45, blue: 0.0)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                        Text("steps")
                            .font(.title3)
                            .foregroundColor(.secondary)
                            .padding(.bottom, 8)
                    }
                    
                    if let peak = peakHour {
                        HStack {
                            Image(systemName: "chart.bar.fill")
                                .foregroundColor(.orange)
                            Text("Peak: \(peak.count) steps at \(peak.date.formatted(date: .omitted, time: .shortened))")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color(.systemBackground))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color(.systemGray4).opacity(0.3), lineWidth: 1.5)
                )
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                
                // Hourly Chart
                VStack(alignment: .leading, spacing: 12) {
                    Text("Hourly Breakdown")
                        .font(.headline)
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    
                    Chart {
                        ForEach(hourlySteps) { step in
                            BarMark(
                                x: .value("Hour", step.date, unit: .hour),
                                y: .value("Steps", step.count)
                            )
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color(red: 1.0, green: 0.58, blue: 0.0), Color(red: 1.0, green: 0.45, blue: 0.0)],
                                    startPoint: .bottom,
                                    endPoint: .top
                                )
                            )
                        }
                    }
                    .frame(height: 200)
                    .chartYAxis {
                        AxisMarks(position: .leading)
                    }
                    .chartXAxis {
                        AxisMarks(values: .stride(by: .hour, count: 3)) { value in
                            if let date = value.as(Date.self) {
                                AxisValueLabel {
                                    Text(date.formatted(date: .omitted, time: .shortened))
                                        .font(.caption2)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color(.systemBackground))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color(.systemGray4).opacity(0.3), lineWidth: 1.5)
                )
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                
                // Hourly List
                VStack(spacing: 0) {
                    ForEach(hourlySteps.filter { $0.count > 0 }) { step in
                        HStack(spacing: 12) {
                            Text(step.date.formatted(date: .omitted, time: .shortened))
                                .font(.subheadline.bold())
                                .foregroundColor(.secondary)
                                .frame(width: 70, alignment: .leading)
                            
                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .fill(Color(.systemGray5))
                                    .frame(height: 20)
                                    .cornerRadius(4)
                                
                                Rectangle()
                                    .fill(
                                        LinearGradient(
                                            colors: [Color(red: 1.0, green: 0.58, blue: 0.0), Color(red: 1.0, green: 0.45, blue: 0.0)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .frame(width: max(CGFloat(step.count) / CGFloat(peakHour?.count ?? 1) * 200, 2), height: 20)
                                    .cornerRadius(4)
                            }
                            .frame(width: 200)
                            
                            Text("\(step.count)")
                                .font(.subheadline.bold())
                                .foregroundColor(.primary)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        
                        if step.id != hourlySteps.filter({ $0.count > 0 }).last?.id {
                            Divider()
                                .padding(.leading, 98)
                        }
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color(.systemBackground))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color(.systemGray4).opacity(0.3), lineWidth: 1.5)
                )
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
            }
            .padding()
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            do {
                hourlySteps = try await healthStore.fetchHourlySteps(for: selectedDate)
            } catch {
                print("Error fetching hourly steps: \(error)")
            }
        }
    }
}

#Preview {
    NavigationView {
        DetailedDayView(steps: [
            Step(count: 12543, date: Date())
        ])
    }
}
