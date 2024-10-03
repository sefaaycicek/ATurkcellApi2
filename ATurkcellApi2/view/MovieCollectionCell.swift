//
//  MovieCollectionCell.swift
//  ATurkcellApi2
//
//  Created by Sefa Aycicek on 3.10.2024.
//

import UIKit
import Kingfisher

class MovieCollectionCell: UICollectionViewCell {

    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieLabel: UILabel!
    
    func configure(model : MovieUIModel) {
        movieLabel.text = model.title
        //movieImageView.kf.setImage(with: model.imageUri)
        movieImageView.kf.setImage(with: model.imageUri) { item in
            print((try? item.get().image)?.size)
        }
        
        //let image = UIImage(named: "car")
        //movieImageView.image = image
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
