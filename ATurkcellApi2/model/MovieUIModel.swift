//
//  MovieUIModel.swift
//  ATurkcellApi2
//
//  Created by Sefa Aycicek on 3.10.2024.
//

import UIKit

struct MovieUIModel {
    let title : String
    let year : String
    let poster : String
    
    init(movie : MovieEntity) {
        self.title = movie.title
        self.poster = movie.poster
        self.year = movie.year
    }
    
    var imageUri : URL? {
        return URL(string: poster)
    }
}
