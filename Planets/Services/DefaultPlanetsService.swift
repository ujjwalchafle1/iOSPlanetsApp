//
//  DefaultPlanetsService.swift
//  Planets
//
//  Created by Ujjwal Chafle on 02/05/2023.
//

import Foundation

/// Protocol to notify Success or Failure of the API call
protocol PlanetsService {
    func getPlanetsData() async throws -> [Planet]
}

/// service for handling api calls
struct DefaultPlanetsService: PlanetsService
{
    private var offlineService: PlanetsOfflineDataManager
    
    init(offlineService: PlanetsOfflineDataManager) {
        self.offlineService = offlineService
    }
    
    /// Function to make API call to get the  Planet data
    ///
    @MainActor
    func getPlanetsData() async throws -> [Planet] {
        let planets = offlineService.fetch()
        if planets.isEmpty {
            do {
                let data = try await NetworkManager.getData(method: .GET, endpoint: .planets, dictionary: nil, type: Planets.self)
                savePlanetsOffline(data.results)
                return data.results
            } catch let error {
                throw error
            }
        } else {
            return planets
        }
    }
    
    private func savePlanetsOffline(_ planets: [Planet]) {
        for planet in planets {
            self.offlineService.addItem(planet: planet)
        }
    }
}
