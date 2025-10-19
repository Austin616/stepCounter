//
//  HealthStore.swift
//  stepCounter
//
//  Created by Austin Tran on 10/19/25.
//

import Foundation
import HealthKit
import Observation

enum HealthError: Error {
    case HealthDataNotAvailable
}

@Observable
class HealthStore {
    
    var steps: [Step] = []
    var healthStore: HKHealthStore?
    var lastError: Error?
    
    
    init() {
        if HKHealthStore.isHealthDataAvailable() {
            self.healthStore = HKHealthStore()
        }
        else {
            lastError = HealthError.HealthDataNotAvailable
        }
    }
    
    func calculateSteps() async throws {
        guard let healthStore = self.healthStore else { return }
        
        let calender = Calendar(identifier: .gregorian)
        let startDate = calender.date(byAdding: .day, value: -7, to: Date())
        let endDate = Date()
        
        let stepType = HKQuantityType(.stepCount)
        let everyDay = DateComponents(day: 1)
        let thisWeek = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        let stepsThisWeek = HKSamplePredicate.quantitySample(type: stepType, predicate: thisWeek)
        
        let anchorDate = calender.startOfDay(for: Date())
        let sumOfStepsData = HKStatisticsCollectionQueryDescriptor(predicate: stepsThisWeek, options: .cumulativeSum, anchorDate: anchorDate, intervalComponents: everyDay)
        
        let stepsCount = try await sumOfStepsData.result(for: healthStore)
        
        guard let startDate = startDate else { return }
        
        stepsCount.enumerateStatistics(from: startDate, to: endDate) { statistics, stop in
            let count = statistics.sumQuantity()?.doubleValue(for: .count())
            let step = Step(count: Int(count ?? 0), date: statistics.startDate)
            if step.count > 0 {
                self.steps.append(step)
            }
        }
    }

    func fetchHourlySteps(for date: Date) async throws -> [Step] {
        guard let healthStore = self.healthStore else {
            throw HealthError.HealthDataNotAvailable
        }
        
        guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            throw HKError(.errorInvalidArgument)
        }
        
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: endOfDay)
        let samplePredicate = HKSamplePredicate.quantitySample(type: stepType, predicate: predicate)
        
        let query = HKStatisticsCollectionQueryDescriptor(
            predicate: samplePredicate,
            options: .cumulativeSum,
            anchorDate: startOfDay,
            intervalComponents: DateComponents(hour: 1)
        )
        
        let results = try await query.result(for: healthStore)
        
        var hourlySteps: [Step] = []
        
        results.enumerateStatistics(from: startOfDay, to: endOfDay) { statistics, _ in
            let count = statistics.sumQuantity()?.doubleValue(for: .count()) ?? 0
            let step = Step(count: Int(count), date: statistics.startDate)
            hourlySteps.append(step)
        }
        
        return hourlySteps
    }
    
    func requestAuthorization() async {
        guard let stepType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount) else { return }
        guard let healthStore = self.healthStore else { return }
        
        do {
            try await healthStore.requestAuthorization(toShare: [], read: [stepType])
        }
        catch {
            self.lastError = error
        }
    }
}
