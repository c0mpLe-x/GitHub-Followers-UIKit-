//
//  NetworkManager.swift
//  GHFollowers
//
//  Created by Він on 31.05.2024.
//

import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    let baseURL = "https://api.github.com/users/"
    let cache = NSCache<NSURL, UIImage>()
    
    private init() {}
    
    func getFollowers(for username: String, page: Int) async throws -> [Follower] {
        let endpoint = baseURL + "\(username)/followers?per_page=100&page=\(page)"
        
        guard let url = URL(string: endpoint) else {
            throw GFError.invalidUsername
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw GFError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode([Follower].self, from: data)
        } catch {
            throw GFError.invalidData
        }
    }
}
