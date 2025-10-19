//
//  StepChartView.swift
//  stepCounter
//
//  Created by Austin Tran on 10/19/25.
//

import SwiftUI
import Charts

struct StepChartView: View {
    let steps: [Step]
    @AppStorage("stepGoal") var goal: Int = 10000
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Chart {
                ForEach(steps.prefix(7)) { step in
                    BarMark(
                        x: .value("Date", step.date, unit: .day),
                        y: .value("Steps", step.count)
                    )
                    .foregroundStyle(
                        LinearGradient(
                            colors: step.count >= goal
                                ? [Color(red: 0.51, green: 0.82, blue: 0.29), Color(red: 0.40, green: 0.72, blue: 0.20)]
                                : [Color(red: 1.0, green: 0.58, blue: 0.0), Color(red: 1.0, green: 0.45, blue: 0.0)],
                            startPoint: .bottom,
                            endPoint: .top
                        )
                    )
                    .cornerRadius(4)
                }
                
                // Goal line
                RuleMark(y: .value("Goal", goal))
                    .foregroundStyle(.secondary)
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [5, 5]))
                    .annotation(position: .top, alignment: .trailing) {
                        Text("Goal")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
            }
            .frame(height: 250)
            .chartYAxis {
                AxisMarks(position: .leading)
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) { _ in
                    AxisValueLabel(format: .dateTime.month().day())
                }
            }
        }
        .padding(20)
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
}

#Preview {
    StepChartView(steps: [
        Step(count: 12543, date: Date()),
        Step(count: 8234, date: Date().addingTimeInterval(-86400)),
        Step(count: 10500, date: Date().addingTimeInterval(-86400 * 2))
    ])
    .padding()
}
