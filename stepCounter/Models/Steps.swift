//
//  Steps.swift
//  stepCounter
//
//  Created by Austin Tran on 10/19/25.
//

import Foundation

struct Step: Identifiable {
    let id = UUID()
    let count: Int
    let date: Date
}
