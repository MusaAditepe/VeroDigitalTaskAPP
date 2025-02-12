//
//  NetworkManager.swift
//  VeroDigitalTaskAPP
//
//  Created by Musa Adıtepe on 12.02.2025.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private var accessToken: String?
    
    private init() {}
    
    private let loginURL = "https://api.baubuddy.de/index.php/login"
    private let tasksURL = "https://api.baubuddy.de/dev/index.php/v1/tasks/select"
    
    func authenticate(completion: @escaping (Result<String, Error>) -> Void) {
        let headers = [
            "Authorization": "Basic QVBJX0V4cGxvcmVyOjEyMzQ1NmlzQUxhbWVQYXNz",
            "Content-Type": "application/json"
        ]
        
        let parameters = [
            "username": "365",
            "password": "1"
        ]
        
        var request = URLRequest(url: URL(string: loginURL)!)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1)))
                return
            }
            
            do {
                let authResponse = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.accessToken = authResponse.oauth.access_token
                completion(.success(authResponse.oauth.access_token))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchTasks(completion: @escaping (Result<[Task], Error>) -> Void) {
        guard let accessToken = accessToken else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No access token"])))
            return
        }
        
        var request = URLRequest(url: URL(string: tasksURL)!)
        request.httpMethod = "GET"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1)))
                return
            }
            
            do {
                let tasks = try JSONDecoder().decode([Task].self, from: data)
                completion(.success(tasks))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

