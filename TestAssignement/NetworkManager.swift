//
//  NetworkManager.swift
//  TestAssignement
//
//  Created by Андрей Гедзюра on 30.01.2021.
//

import Foundation

/// Performs request to the server and gives response in simple way.
class NetworkManager {
    private var baseURL: URL
    
    init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    convenience init(baseURL: String) {
        guard let url = URL(string: baseURL) else {
            fatalError("Invalid string representation of URL.")
        }
        self.init(baseURL: url)
    }
    
    convenience init() {
        self.init(baseURL: "https://pryaniky.com")
    }
    
    /// Performs a request on the server and receives response.
    /// - Parameter completion: Block of code that executes after receiving response from the server. It receives as argument enum that contains either data from the server or error.
    func getData(completion: @escaping(Result<Data, Error>) -> Void) {
        let url = baseURL.appendingPathComponent("/static/json/sample.json")
        let task = URLSession.shared.dataTask(with: url, completionHandler: {data, response, error in
            if let error = error {
                completion(Result.failure(error))
                return
            }
            guard (response as? HTTPURLResponse) != nil else {
                completion(Result.failure(NetworkError.invalidResponseType))
                return
            }
            guard let data = data else {
                completion(Result.failure(NetworkError.emptyData))
                return
            }
            completion(Result.success(data))
        })
        task.resume()
    }
    
    /// Errors that occur during network communicztion.
    enum NetworkError: LocalizedError {
        case invalidResponseType
        case emptyData
        var errorDescription: String? {
            switch self {
            case .invalidResponseType:
                return "Invalid response type received during sending network request."
            case .emptyData:
                return "Data is missing in the response."
            }
        }
    }
}
