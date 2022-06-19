//
//  ViewModel.swift
//  WeatherApp
//
//  Created by Erik Kokinda on 19/05/2022.
//

import Foundation




class APIService {
    static let shared = APIService()
    
    
    enum APIError: Error {
        case error(_ errorString: String)
    }
    
    public func getJSON(urlString: String,
                                      dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
                                      keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys,
                completion: @escaping (Result<Forecast,APIError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.error("Error: Invalid URL")))
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(.error("Error: \(error.localizedDescription)")))
                return
            }
            guard let data = data else {
                return completion(.failure(.error("Error: Invalid URL")))
            }
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = dateDecodingStrategy
            decoder.keyDecodingStrategy = keyDecodingStrategy
            do {
                let decodedData = try decoder.decode(Forecast.self, from: data)
                completion(.success(decodedData))
                return
            } catch let decodingError {
                completion(.failure(APIError.error("Error: \(decodingError.localizedDescription)")))
                return
            }
            
        }.resume()
    }
}
