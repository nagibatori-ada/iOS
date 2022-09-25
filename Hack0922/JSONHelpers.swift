//
//  JSONHelpers.swift
//  Hack0922
//
//  Created by Tema Sysoev on 24.09.2022.
//

import Foundation

struct OracleJSON: Codable{
    let ticker: String
    let name: String
    let volume: String
    let volume_24h: String
    let stakeholders: Int
    let price: String
}

struct LaunchpadJSON: Codable{
    let id: Int
    let asset_b: AssetJSON
    let asset_a: AssetJSON
    let weight_a: String
    let weight_b: String
}
struct AssetJSON: Codable{
    let id: Int
    let name: String
    let ticker: String
    let volume_24h: Int
}
