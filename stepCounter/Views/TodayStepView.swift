//
//  TodayStepView.swift
//  stepCounter
//
//  Created by Austin Tran on 10/19/25.
//

import SwiftUI

struct TodayStepView: View {
    let steps: [Step]
    @AppStorage("stepGoal") var goal: Int = 10000
    
    private var todaySteps: Int {
        steps.last?.count ?? 0
    }
    
    private var progress: Double {
        min(Double(todaySteps) / Double(goal), 1.0)
    }
    
    private var latestDate: Date? {
        steps.last?.date
    }
    
    // Custom color scheme
    private var accentColor: Color {
        progress >= 1.0 ? Color(red: 0.51, green: 0.82, blue: 0.29) : Color(red: 1.0, green: 0.58, blue: 0.0)
    }
    
    private var gradientColors: [Color] {
        if progress >= 1.0 {
            return [Color(red: 0.51, green: 0.82, blue: 0.29), Color(red: 0.40, green: 0.72, blue: 0.20)]
        } else {
            return [Color(red: 1.0, green: 0.58, blue: 0.0), Color(red: 1.0, green: 0.45, blue: 0.0)]
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                Image(systemName: "figure.walk")
                    .foregroundStyle(accentColor)
                    .font(.title3)
                Text("Today")
                    .font(.subheadline.bold())
                    .foregroundColor(.secondary)
                Spacer()
                if let date = latestDate {
                    Text(date.formatted(date: .abbreviated, time: .omitted))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            // Step Count
            VStack(alignment: .leading, spacing: 4) {
                Text("\(todaySteps)")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: gradientColors,
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                Text("steps")
                    .font(.title3)
                    .foregroundColor(.secondary)
            }
            
            // Progress Bar
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("Goal: \(goal)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("\(Int(progress * 100))%")
                        .font(.caption.bold())
                        .foregroundColor(accentColor)
                }
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(.systemGray5))
                            .frame(height: 8)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(
                                LinearGradient(
                                    colors: gradientColors,
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geometry.size.width * progress, height: 8)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: progress)
                    }
                }
                .frame(height: 8)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(.systemBackground),
                            accentColor.opacity(0.05)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(accentColor.opacity(0.2), lineWidth: 1.5)
        )
        .shadow(color: accentColor.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    VStack {
        TodayStepView(steps: [
            Step(count: 7543, date: Date())
        ])
        .padding()
        
        TodayStepView(steps: [
            Step(count: 12543, date: Date())
        ])
        .padding()
    }
}
