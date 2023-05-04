//
//  DefaultPlanetsService.swift
//  Planets
//
//  Created by Ujjwal Chafle on 02/05/2023.
//

import Foundation

/// Protocol to notify Success or Failure of the API call
protocol PlanetsService {
    func getPlanetsData(completion: @escaping (Result<[Planet], NetworkError>) -> Void)
}

/// service for handling api calls
struct DefaultPlanetsService: PlanetsService
{
    private var offlineService: PlanetsOfflineDataManager
    
    init(offlineService: PlanetsOfflineDataManager) {
        self.offlineService = offlineService
    }
    
    /// Function to make API call to get the  Planet data
    func getPlanetsData(completion: @escaping (Result<[Planet], NetworkError>) -> Void) {
        let planets = offlineService.fetch()
        if planets.isEmpty {
            NetworkManager.getData(method: .GET, endpoint: .planets, dictionary: nil, type: Planets.self) { result in
                switch result {
                    case .success(let data):
                        savePlanetsOffline(data.results)
                        completion(.success(data.results))
                    case .failure(let error):
                        completion(.failure(error))
                }
            }
        } else {
            completion(.success(planets))
        }
    }
    
    private func savePlanetsOffline(_ planets: [Planet]) {
        for planet in planets {
            self.offlineService.addItem(planet: planet)
        }
    }
}
