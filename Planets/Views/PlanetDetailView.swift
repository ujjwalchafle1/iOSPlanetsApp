//
//  PlanetDetailView.swift
//  Planets
//
//  Created by Ujjwal Chafle on 02/05/2023.
//

import SwiftUI

struct PlanetDetailView: View {
    let planet: Planet?
    
    var body: some View {
        VStack(spacing: 16) {
            if let planet = planet {
                Image(systemName: "globe")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.secondary)
                    .padding()
                
                Text(planet.name)
                    .font(.title)
                    .fontWeight(.semibold)
                
                detailsRow(title: "Diameter", value: planet.diameter)
                
                Spacer()
            }
        }
    }
    
    
    private func detailsRow(title: String, value: String) -> some View {
        HStack(spacing: 8) {
            Text(title)
                .fontWeight(.semibold)
            
            Text(value)
                .foregroundColor(.secondary)
        }
    }
}
