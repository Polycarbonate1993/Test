//
//  PictureCell.swift
//  TestAssignement
//
//  Created by Андрей Гедзюра on 31.01.2021.
//

import UIKit
import Kingfisher

class PictureCell: UITableViewCell {

    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var textDescription: UILabel!
    var viewModel: Picture? {
        didSet {
            guard let model = viewModel, let url = URL(string: model.url) else {
                picture.image = nil
                textDescription.text = nil
                return
            }
            picture.kf.setImage(with: ImageResource(downloadURL: url, cacheKey: url.absoluteString))
            textDescription.text = model.text
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
