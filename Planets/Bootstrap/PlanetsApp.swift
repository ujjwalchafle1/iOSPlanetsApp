//
//  PlanetsApp.swift
//  Planets
//
//  Created by Ujjwal on 28/04/2023.
//

import SwiftUI

@main
struct PlanetsApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            PlanetListView(
                viewModel: PlanetsViewModel(
                    service: DefaultPlanetsService(
                        offlineService: PlanetsOfflineDataManager(
                            context: persistenceController.container.viewContext
                        )
                    )
                )
            )
        }
    }
}
