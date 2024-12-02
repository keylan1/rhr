//
//  HealthModel.swift
//  RHR Watch App
//
//  Created by Sarah Keller on 23.10.24.
//

import Foundation
import HealthKit

class HealthModel: HealthModelProtocol {    
    let healthStore = HKHealthStore()
    @Published var isAuthorized = false
    
    // Request authorization to access HealthKit.
    func requestAuthorization() async {
        // The quantity type to read from the health store.
        let rhr = HKObjectType.quantityType(forIdentifier: .restingHeartRate)!
        
        // Request authorization for those quantity types. in a do catch and not try? await because you want the error
        do {
            try await
            healthStore.requestAuthorization(toShare: [], read: [rhr])
            DispatchQueue.main.async {
                self.isAuthorized = true
            }
        } catch {
            print("Healthkit authorization failed \(error.localizedDescription)")
            DispatchQueue.main.async {
                self.isAuthorized = false
            }
        }
    }
    //withCHeckedContinuation used to replace completion handlers to use the async/await method (newer) may be some issues with healthkit data though?
    func getRestingHeartRate(completion: @escaping (Double?) -> Void) {
        //Doc says HKSampleType, but that's less used than HKObjectType which has factory methods
        let rhr = HKObjectType.quantityType(forIdentifier: .restingHeartRate)!
        
        let query = HKSampleQuery(sampleType: rhr, predicate: nil, limit: 1, sortDescriptors: nil) {
            query, results, error in
            
            guard let sample = results?.first as? HKQuantitySample else {
                // Handle any errors here.
                print("No rhr data available")
                completion(nil)
                return
            }
            //HKQuantitySample ] HKUnit
            let rhrValue = sample.quantity.doubleValue(for: HKUnit(from: "count/min"))
            completion(rhrValue)
        }
        healthStore.execute(query)
    }
    
    func getBaselineRHR(completion: @escaping (Double?) -> Void) {
        let baselineType = HKObjectType.quantityType(forIdentifier: .restingHeartRate)!
        
        //predicate for the sample data eg. 14 days min baseline
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        guard let endDate = calendar.date(byAdding: .day, value: 1, to: today) else {
            print("Could not create end date")
            return
        }
        
        //guard let minStartDate = calendar.date(byAdding: .day, value: -14, to: endDate) else {
        //    fatalError("Start date less than 14 days")
        //}
        
        guard let idealStartDate = calendar.date(byAdding: .day, value: -45, to: endDate) else {
            print("Start date less than 45 days")
            return
        }
        
        let idealBaselineTime = HKQuery.predicateForSamples(withStart: idealStartDate, end: endDate)
        
        // query descriptior
        //let rhrType = HKQuantityType(.restingHeartRate)
        //let rhrIdealBaseline = HKSamplePredicate.quantitySample(type: rhrType, predicate: idealBaselineTime)
        let everyDay = DateComponents(day: 1)
        
        //let idealBaselineQuery = HKStatisticsCollectionQueryDescriptor(predicate: rhrIdealBaseline, options: .discreteAverage, anchorDate: endDate, intervalComponents: everyDay)
        
        let idealBaselineQuery = HKStatisticsCollectionQuery(quantityType: baselineType, quantitySamplePredicate: idealBaselineTime, options: .discreteAverage, anchorDate: endDate, intervalComponents: everyDay)
        //var baselineRHR: Double = 0
        
        //if let baseline = try? await idealBaselineQuery.result(for: healthStore) {
        idealBaselineQuery.initialResultsHandler = {query, results, error in
            if let error = error {
                print("Error fetching baseline: \(error)")
                completion(nil)
                return
            }
            
            guard let statsCollection = results else {
                assertionFailure("No results from query")
                return
            }
            var dailyRHRArray: [(date: Date, value: Double)] = []
            var totalRHR: Double = 0
            var averageRHR: Double = 0
            
            statsCollection.enumerateStatistics(from: idealStartDate, to: endDate) {
                (statistics, stop) in
                if let quantity = statistics.averageQuantity() {
                    let date = statistics.startDate
                    let value = quantity.doubleValue(for: HKUnit(from: "count/min"))
                    
                    let daily = (date: date, value: value)
                    
                    dailyRHRArray.append(daily)
                    
                    totalRHR += daily.value
                }
            }
            averageRHR = totalRHR / Double(dailyRHRArray.count)
            let baselineRHR = averageRHR.rounded()
            completion(baselineRHR)
            //initialresultshandler where you process the information from the query
            // calculate averageQuantity?
            //store in variable or add function to calculate against daily rhr?
        }
        healthStore.execute(idealBaselineQuery)
    }
    
    func compare(completion: @escaping(String?) -> Void) {
        getRestingHeartRate {result in
            if let restingHeartRate = result {
                self.getBaselineRHR {baseline in
                    if let baselineRHR = baseline {
                        let diff = restingHeartRate - baselineRHR
                        let toCompare = 0.1 * baselineRHR
                        if diff >= toCompare {
                            completion("Elevated")
                        } else {
                            completion("Normal")
                        }
                    } else {
                        completion(nil)
                    }
                }
            } else {
                completion(nil)
            }
        }
    }
}
