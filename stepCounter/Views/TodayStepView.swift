//
//  TodayStepView.swift
//  stepCounter
//
//  Created by Austin Tran on 10/19/25.
//

import SwiftUI

struct TodayStepView: View {
    let steps: [Step]

    private var latestDate: Date? {
        steps.last?.date
    }
    
    var body: some View {
        VStack {
            Text("\(steps.last?.count ?? 0) steps")
                .font(Font.largeTitle.bold())
        }
        .frame(maxWidth: .infinity, maxHeight: 150)
        .background(Color(.orange))
        .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
        .overlay(alignment: .topLeading) {
            HStack {
                Image(systemName: "flame")
                    .foregroundStyle(.red)
                Text("Today")
            }.padding()
            .font(.caption.bold())
        }
        .overlay(alignment: .bottomTrailing) {
            if let date = latestDate {
                Text(
                    date.formatted(
                        date: Date.FormatStyle.DateStyle.abbreviated,
                        time: Date.FormatStyle.TimeStyle.omitted
                    )
                )
                .font(Font.caption.bold())
                .padding()
            }
        }.padding()
    }
}

#Preview {
    TodayStepView(steps: [])
}
