//
//  ApiService.swift
//  ATurkcellApi2
//
//  Created by Sefa Aycicek on 3.10.2024.
//

import UIKit
import RxAlamofire
import RxSwift
import Alamofire

class ApiService : ApiServiceProtocol {
    private let manager = HTTPManager.shared
    private let encoding = JSONEncoding.default
    
    func searchMovies(searchTerm: String) -> Single<MovieResponse?> {
        let url = Endpoints.searchMovies.with(query: searchTerm)
        return self.request(methodType: .post, url: url)
    }
    
    private func request<T : Codable>(methodType : HTTPMethod, url : URL, parameters : [String : AnyObject]? = nil) -> Single<T?> {
        
        let validateRange = Array(200..<400) + Array(402..<501)
        
        var httpHeader = HTTPHeaders()
        httpHeader.add(name: "Content-Type", value: "application/json")
        httpHeader.add(name: "authorization", value: Constants.token)
        
        return manager.rx.request(methodType, url, parameters: parameters, encoding: encoding, headers: httpHeader)
            .validate(statusCode: validateRange)
            .responseString()
            .asSingle()
            .catch({ error -> Single<(HTTPURLResponse, String)> in
                var response = 0
        
                if let responseCode = error.asAFError?.responseCode {
                    response = responseCode
                    if responseCode == 401 {
                        return Single.error(NSError(domain: "Lütfen giriş yapınız", code: responseCode))
                    }
                }
                
                return Single.error(NSError(domain: "Genel bi hata oluştu", code: response))
            })
            .flatMap { json -> Single<T?> in
                let jsonString = json.1
                let statusCode = json.0.statusCode
                
                guard let data = jsonString.data(using: .utf8) else { return Single.just(nil) }
                
                if statusCode == 200 {
                    do {
                        let response = try JSONDecoder().decode(T.self, from: data)
                        return Single.just(response)
                    } catch {
                        // log error
                    }
                }
                
                return Single.just(nil)
            }
    }
    
}

class HTTPManager : Alamofire.Session {
    static let shared : HTTPManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        
        let interceptor = OAuthHandler()
        let manager = HTTPManager(configuration: configuration, interceptor: interceptor)
        return manager
    }()
}


protocol ApiServiceProtocol {
    func searchMovies(searchTerm : String) -> Single<MovieResponse?>
}
