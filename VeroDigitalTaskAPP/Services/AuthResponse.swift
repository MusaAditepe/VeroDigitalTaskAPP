//
//  AuthResponse.swift
//  VeroDigitalTaskAPP
//
//  Created by Musa Adıtepe on 12.02.2025.
//

import Foundation

struct AuthResponse: Codable {
    let oauth: OAuth
    
    struct OAuth: Codable {
        let access_token: String
        let expires_in: Int
        let token_type: String
        let scope: String?
    }
}

