//
//  Planet.swift
//  Planets
//
//  Created by Ujjwal Chafle on 02/05/2023.
//

import Foundation

struct Planets: Codable {
    let results: [Planet]
}

struct Planet: Codable, Hashable {
    let name: String
    let diameter: String
}
