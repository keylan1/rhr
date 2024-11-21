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
    
    func getBaselineRHR() async {
        let baselineType = HKObjectType.quantityType(forIdentifier: .restingHeartRate)!
        
        //predicate for the sample data eg. 14 days min baseline
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        guard let endDate = calendar.date(byAdding: .day, value: 1, to: today) else {
            fatalError("Could not create end date")
        }
        
        //guard let minStartDate = calendar.date(byAdding: .day, value: -14, to: endDate) else {
        //    fatalError("Start date less than 14 days")
        //}
        
        guard let idealStartDate = calendar.date(byAdding: .day, value: -45, to: endDate) else {
            fatalError("Start date less than 45 days")
        }
        
        let idealBaselineTime = HKQuery.predicateForSamples(withStart: idealStartDate, end: endDate)
        
        // query descriptior
        let rhrType = HKQuantityType(.restingHeartRate)
        let rhrIdealBaseline = HKSamplePredicate.quantitySample(type: rhrType, predicate: idealBaselineTime)
        let everyDay = DateComponents(day: 1)
        
        let idealBaselineQuery = HKStatisticsCollectionQueryDescriptor(predicate: rhrIdealBaseline, options: .discreteAverage, anchorDate: endDate, intervalComponents: everyDay)
        
        if let minBaseline = try? await idealBaselineQuery.result(for: healthStore) {
            minBaseline.enumerateStatistics(from: idealStartDate, to: endDate) {
                (statistics, stop) in
                if let quantity = statistics.averageQuantity() {
                    let date = statistics.startDate
                    let value = quantity.doubleValue(for: HKUnit.count())
                    
                    let dailyRHRArray = []
                        //date.addDay(date: date, value: value)
                }
            }
        } else {
            fatalError("Could not get min baseline")
            }
        
        //initialresultshandler where you process the information from the query
        // calculate averageQuantity?
        //store in variable or add function to calculate against daily rhr?
        
        
    }
}


