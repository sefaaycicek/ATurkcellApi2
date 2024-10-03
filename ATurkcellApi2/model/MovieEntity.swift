//
//  MovieEntity.swift
//  ATurkcellApi2
//
//  Created by Sefa Aycicek on 3.10.2024.
//

import UIKit

struct MovieResponse: Codable {
    let success: Bool
    let result: [MovieEntity]?
}

struct MovieEntity: Codable {
    let title: String
    let year: String
    let imdbID: String
    let type: String
    let poster: String
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID = "imdbID"
        case type = "Type"
        case poster = "Poster"
    }
}
