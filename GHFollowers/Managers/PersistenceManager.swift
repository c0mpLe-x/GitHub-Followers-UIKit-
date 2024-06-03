//
//  PersistenceManager.swift
//  GHFollowers
//
//  Created by Він on 02.06.2024.
//

import Foundation

enum PersistenceActionType {
    case add, remove
}

enum PersistenceManager {
    static private let defaults = UserDefaults.standard
    
    enum Keys {
        static let favorites = "favorites"
    }
    
    static func updateWith(favorite: Follower, actionType: PersistenceActionType) async throws {
        var storedFavourites = try await retrieveFavorites()
        switch actionType {
        case .add:
            guard !storedFavourites.contains(where: { $0 == favorite }) else { 
                throw GFError.alreadyInFavorites
            }
            storedFavourites.append(favorite)
        case .remove:
            storedFavourites.removeAll(where: { $0 == favorite })
        }
        
        try save(favotites: storedFavourites)
    }
    
    static func retrieveFavorites() async throws -> [Follower] {
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
            return []
        }

        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode([Follower].self, from: favoritesData)
        } catch {
            throw GFError.unableToFavorite
        }
    }
    
    static func save(favotites: [Follower]) throws {
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let encodeFavorites = try encoder.encode(favotites)
            defaults.setValue(encodeFavorites, forKey: Keys.favorites)
        } catch {
            throw GFError.unableToFavorite
        }
    }
}
