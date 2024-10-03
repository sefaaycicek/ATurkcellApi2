//
//  Endpoints.swift
//  ATurkcellApi2
//
//  Created by Sefa Aycicek on 3.10.2024.
//

import UIKit

enum Endpoints: String {
    case searchMovies = "imdbSearchByName?query="
    case deleteMovies = "deleteImdbMovie?"
    
    var baseUrl : String {
        return "https://api.collectapi.com/imdb/"
    }
    
    var url: URL {
        return URL(string: baseUrl + self.rawValue)!
    }
    
    func with(query: String) -> URL {
        return URL(string: baseUrl + self.rawValue + query)!
    }
}
