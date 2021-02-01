//
//  ViewModelController.swift
//  TestAssignement
//
//  Created by Андрей Гедзюра on 31.01.2021.
//

import Foundation

/// This class provides the model in the way that can be used in the view.
class ViewModelController {
    
    /// Item storage.
    private var data: [Item] = []
    private let networkManager = NetworkManager()
    
    /// Requests items from the server and transforms them into suitable form.
    /// - Parameter completion: Block of code that executes after the data is received and transformed.
    func requestItems(completion: (success: () -> Void, failure: (Error) -> Void)) {
        networkManager.getData(completion: {result in
            switch result {
            case .success(let data):
                switch DataDecoder.fromJSONData(data) {
                case .success((let array, let order)):
                    let sortedArray = order.compactMap({item -> Item? in
                        guard let arrayItem = array.first(where: {$0.name == item}) else {
                            return nil
                        }
                        return arrayItem
                    })
                    self.data = sortedArray
                    completion.success()
                case .failure(let error):
                    completion.failure(error)
                }
            case .failure(let error):
                completion.failure(error)
            }
        })
    }
    
    /// Provides item at the specified position.
    /// - Parameter index: The index of the element.
    /// - Returns: Returns either the item or an error.
    func itemAtIndex(_ index: Int) -> Result<Item, Error> {
        guard index < data.count else {
            return Result.failure(ModelError.invalidIndex)
        }
        return Result.success(data[index])
    }
    
    /// The number of items in the local storage.
    /// - Returns: Returns the number of items in the storage.
    func itemsCount() -> Int {
        return data.count
    }
    
    enum ModelError: LocalizedError {
        case invalidIndex
        var errorDescription: String? {
            switch self {
            case .invalidIndex:
                return "Index of the item is out of bounds."
            }
        }
    }
}
