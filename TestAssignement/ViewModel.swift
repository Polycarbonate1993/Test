//
//  ViewModel.swift
//  TestAssignement
//
//  Created by Андрей Гедзюра on 30.01.2021.
//

import Foundation

/// General wrapper class for data received from the server.
class Item {
    /// Id of each unique sample of the class.
    let id = UUID()
    var name: String
    
    init(name: String? = nil) {
        self.name = name ?? ""
    }
}

/// Specified wrapper class for data from the server that represents picture.
class Picture: Item {
    
    /// URL that stores the image on the server.
    var url: String
    
    /// Picture description.
    var text: String
    
    init(name: String? = nil, url: String? = nil, text: String? = nil) {
        self.url = url ?? ""
        self.text = text ?? ""
        super.init(name: name)
    }
}

/// Specified wrapper class for data from the server that represents text block.
class TextBlock: Item {
    
    /// The actual text block.
    var text: String
    
    init(name: String?, text: String? = nil) {
        self.text = text ?? ""
        super.init(name: name)
    }
}

/// Specified wrapper class for data from the server tha represents some element picker.
class Selector: Item {
    
    /// Selected element from the pool of elements.
    var selectedId: Int
    
    /// The pool os elements.
    var variants: [(id: Int, text: String)]
    
    /// Select specified element from the pool.
    /// - Parameter index: Index of the element that needs to be selected.
    func selectWithIndex(_ index: Int) {
        selectedId = index + 1
    }
    
    init(name: String?, selectedId: Int?, variants: [Dictionary<String, Any>]?) {
        self.selectedId = selectedId ?? 0
        self.variants = []
        super.init(name: name)
        if let variants = variants {
            for item in variants {
                guard let id = item["id"] as? Int, let text = item["text"] as? String else {
                    return
                }
                self.variants.append((id: id, text: text))
            }
        }
    }
}

