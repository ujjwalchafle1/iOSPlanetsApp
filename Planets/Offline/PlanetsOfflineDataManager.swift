//
//  PlanetsOfflineDataManager.swift
//  Planets
//
//  Created by Ujjwal Chafle on 02/05/2023.
//

import Foundation
import CoreData

final class PlanetsOfflineDataManager {
    
    private var context: NSManagedObjectContext!
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func fetch() -> [Planet] {
        var planets: [Planet] = []
        
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<PlanetEntity> = PlanetEntity.fetchRequest()
        
        do {
            // Perform Fetch Request
            let items = try context.fetch(fetchRequest)
            planets = items.compactMap { offlinePlanet in
                return Planet(name: offlinePlanet.name ?? "N/A", diameter: offlinePlanet.diameter ?? "N/A")
            }
        } catch {
            print("Unable to Fetch Workouts, (\(error))")
        }
        return planets
    }
    
    func addItem(planet: Planet) {
        
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<PlanetEntity> = PlanetEntity.fetchRequest()
        let predicate = NSPredicate.init(format: "name == %@", planet.name)
        fetchRequest.predicate = predicate
        
        do {
            let isPlanetPresent = try context.fetch(fetchRequest)
            
            if isPlanetPresent.isEmpty {
                let newItem = PlanetEntity(context: context)
                newItem.name = planet.name
                newItem.diameter = planet.diameter
                try context.save()
            }
            
        } catch let error {
            print(error)
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
