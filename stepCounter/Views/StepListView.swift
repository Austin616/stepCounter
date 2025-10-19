//
//  StepListView.swift
//  stepCounter
//
//  Created by Austin Tran on 10/19/25.
//

import SwiftUI

struct StepListView: View {
    
    let steps: [Step]
    var body: some View {
        List(steps) { step in
            NavigationLink(destination: DetailedDayView(steps: [step])) {
                HStack {
                    Circle()
                        .frame(width: 20, height: 20)
                        .foregroundColor(isUnderGoal(steps: step.count, goal: 5000) ? .red : .green
                        )
                    Text("\(step.count) steps")
                    Spacer()
                    Text(step.date, style: .date)
                }
            }
        }
        .scrollContentBackground(.hidden)
    }
}

#Preview {
    StepListView(steps: [])
}

