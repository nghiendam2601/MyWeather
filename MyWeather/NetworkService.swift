//
//  NetworkService.swift
//  MyWeather
//
//  Created by DamMinhNghien on 14/9/24.
//

import Foundation
enum NetworkError: Error {
    case urlError
    case decodingError
    case responseError
}

class NetworkService {
    static let shared = NetworkService()
    
    private init() {}
    
    func fetchData<T: Decodable>(from urlString: String, responseType: T.Type) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw NetworkError.urlError
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw NetworkError.responseError
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError
        }
    }
}
