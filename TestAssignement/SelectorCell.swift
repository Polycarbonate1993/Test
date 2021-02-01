//
//  SelectorCell.swift
//  TestAssignement
//
//  Created by Андрей Гедзюра on 31.01.2021.
//

import UIKit

class SelectorCell: UITableViewCell {

    @IBOutlet weak var selector: UISegmentedControl!
    var alertDetails: ((_ id: UUID, _ name: String, _ selectedId: Int) -> Void)?
    var viewModel: Selector? {
        didSet {
            guard let selectorModel = viewModel else {
                return
            }
            selector.removeAllSegments()
            for (index, item) in selectorModel.variants.enumerated() {
                selector.insertSegment(withTitle: item.text, at: index, animated: true)
            }
            selector.selectedSegmentIndex = selectorModel.selectedId - 1
        }
    }
    
    @IBAction func segmentedControllTapped(_ sender: UISegmentedControl) {
        guard let selector = viewModel else {
            return
        }
        viewModel?.selectWithIndex(sender.selectedSegmentIndex)
        alertDetails?(selector.id, selector.name, selector.selectedId)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
