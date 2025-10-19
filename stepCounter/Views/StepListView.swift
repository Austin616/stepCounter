//
//  StepListView.swift
//  stepCounter
//
//  Created by Austin Tran on 10/19/25.
//

import SwiftUI

struct StepListView: View {
    
    let steps: [Step]
    
    @AppStorage("stepGoal") var goal: Int = 10000
    
    var displaySteps: [Step] {
        if steps.count >= 7 {
            return Array(steps.prefix(7))
        } else {
            var result = steps
            // Add placeholder steps to reach 7 rows
            for i in steps.count..<7 {
                result.append(Step(count: 0, date: Date().addingTimeInterval(-86400 * Double(i))))
            }
            return result
        }
    }
    
    // Custom color scheme to match TodayStepView
    private func accentColor(for stepCount: Int) -> Color {
        if stepCount == 0 {
            return Color(.systemGray3)
        }
        return stepCount >= goal ? Color(red: 0.51, green: 0.82, blue: 0.29) : Color(red: 1.0, green: 0.58, blue: 0.0)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(displaySteps) { step in
                if step.count == 0 {
                    // Non-clickable placeholder row
                    HStack(spacing: 12) {
                        Circle()
                            .fill(Color(.systemGray4))
                            .frame(width: 12, height: 12)
                        Text("No data")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(step.date, style: .date)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .background(Color(.systemBackground))
                } else {
                    // Clickable row
                    NavigationLink(destination: DetailedDayView(steps: [step])) {
                        HStack(spacing: 12) {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: step.count >= goal
                                            ? [Color(red: 0.51, green: 0.82, blue: 0.29), Color(red: 0.40, green: 0.72, blue: 0.20)]
                                            : [Color(red: 1.0, green: 0.58, blue: 0.0), Color(red: 1.0, green: 0.45, blue: 0.0)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 12, height: 12)
                                .shadow(color: accentColor(for: step.count).opacity(0.3), radius: 2, x: 0, y: 1)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("\(step.count) steps")
                                    .font(.body)
                                    .foregroundColor(.primary)
                                
                                Text(step.date, style: .date)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .opacity(0.6)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .background(
                            LinearGradient(
                                colors: [
                                    Color(.systemBackground),
                                    accentColor(for: step.count).opacity(0.03)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    }
                }
                
                if step.id != displaySteps.last?.id {
                    Divider()
                        .padding(.leading, 40)
                }
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color(.systemGray4).opacity(0.3), lineWidth: 1.5)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    VStack {
        StepListView(steps: [
            Step(count: 12543, date: Date()),
            Step(count: 8234, date: Date().addingTimeInterval(-86400)),
            Step(count: 10500, date: Date().addingTimeInterval(-86400 * 2))
        ])
        .padding()
    }
}
