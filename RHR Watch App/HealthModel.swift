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
    }


