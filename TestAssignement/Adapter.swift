//
//  Adapter.swift
//  TestAssignement
//
//  Created by Андрей Гедзюра on 30.01.2021.
//

import Foundation

/// Adapter class that decodes data received from the server and transforms it into view model.
class DataDecoder {
    
    /// Transforms data into suitable form.
    /// - Parameter data: Data that needed to be decoded and transformed. JSON format.
    /// - Returns: Returns Result that contains either the touple of 2 arrays or an error. One with elements and the other with names ordered with internal rules.
    class func fromJSONData(_ data: Data) -> Result<(dataArray: [Item], order: [String]), Error> {
        guard let jsonObject = try? JSONSerialization.jsonObject(with: data) as? Dictionary<String, Any> else {
            return Result.failure(DecodingError.invalidData)
        }
        guard let data = jsonObject["data"] as? [Dictionary<String, Any>], let order = jsonObject["view"] as? [String] else {
            return Result.failure(DecodingError.ivalidJSONKeys)
        }
        var transformedData: [Item] = []
        for item in data {
            guard let content = item["data"] as? Dictionary<String, Any> else {
                return Result.failure(DecodingError.invalidContentKeys)
            }
            if let selectedId = content["selectedId"] as? Int {
                let selector = Selector(name: item["name"] as? String, selectedId: selectedId, variants: content["variants"] as? [Dictionary<String, Any>])
                transformedData.append(selector)
            } else if let url = content["url"] as? String {
                let picture = Picture(name: item["name"] as? String, url: url, text: content["text"] as? String)
                transformedData.append(picture)
            } else if let text = content["text"] as? String {
                let text = TextBlock(name: item["name"] as? String, text: text)
                transformedData.append(text)
            }
        }
        guard !transformedData.isEmpty else {
            return Result.failure(DecodingError.emptyData)
        }
        return Result.success((transformedData, order))
    }
    
    /// Errors that can occur durin decoding.
    enum DecodingError: LocalizedError {
        case invalidData
        case ivalidJSONKeys
        case invalidContentKeys
        case emptyData
        var errorDescription: String? {
            switch self {
            case .invalidData:
                return "Data content doesn't match JSON Object Type."
            case .ivalidJSONKeys:
                return "JSON object keys doesn't match received ones."
            case .invalidContentKeys:
                return "Content keys doesn't match received ones."
            case .emptyData:
                return "Empty data."
            }
        }
    }
}
