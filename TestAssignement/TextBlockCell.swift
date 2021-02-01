//
//  TextBlockCell.swift
//  TestAssignement
//
//  Created by Андрей Гедзюра on 31.01.2021.
//

import UIKit

class TextBlockCell: UITableViewCell {
    
    @IBOutlet weak var textBlock: UILabel!
    var viewModel: TextBlock? {
        didSet {
            guard let block = viewModel else {
                textBlock.text = nil
                return
            }
            textBlock.text = block.text
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
