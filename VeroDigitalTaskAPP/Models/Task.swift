//
//  Task.swift
//  VeroDigitalTaskAPP
//
//  Created by Musa Adıtepe on 12.02.2025.
//

import Foundation

struct Task: Codable {
    let task: String?
    let title: String?
    let description: String?
    let colorCode: String?
    
    enum CodingKeys: String, CodingKey {
        case task
        case title
        case description
        case colorCode = "colorCode"
    }
}

