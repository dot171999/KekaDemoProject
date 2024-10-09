//
//  NetworkManager.swift
//  KekaDemoProject
//
//  Created by Aryan Sharma on 09/10/24.
//

import Foundation

class NetworkManager: NetworkManagerProtocol {
    func getData(from url: URL) async throws -> Data {
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
    
    func getModel<T: Decodable>(from url: URL) async throws -> T {
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let model = try JSONDecoder().decode(T.self, from: data)
        return model
    }
}
