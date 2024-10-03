//
//  MainViewModel.swift
//  ATurkcellApi2
//
//  Created by Sefa Aycicek on 3.10.2024.
//

import UIKit
import RxRelay
import RxSwift

class MainViewModel : BaseViewModel {
    let apiService : ApiServiceProtocol
    
    private var movieResponse : MovieResponse? = nil
    private var movieItems = [MovieUIModel]()
    var needUpdateUI = BehaviorRelay<Bool>(value: false)
    
    init(apiService : ApiServiceProtocol = ApiService()) {
        self.apiService = apiService
    }
    
    func searchMovies(query : String) {
        isLoading.accept(true)
        apiService.searchMovies(searchTerm: query)
            .observe(on: MainScheduler.instance)
            .subscribe { response in
                self.movieResponse = response
                
                let items = self.movieResponse?.result?.map { MovieUIModel(movie: $0) } ?? []
                self.movieItems = items
                /*self.movieItems.append(contentsOf: items)
                self.movieItems.append(contentsOf: items)
                self.movieItems.append(contentsOf: items)
                self.movieItems.append(contentsOf: items)
                self.movieItems.append(contentsOf: items)
                self.movieItems.append(contentsOf: items)
                self.movieItems.append(contentsOf: items)*/
                
                self.needUpdateUI.accept(true)
                self.isLoading.accept(false)
            } onFailure: { error in
                print(error)
                self.needUpdateUI.accept(true)
                self.isLoading.accept(false)
            }.disposed(by: disposeBag)
    }
    
    var itemCount : Int {
        return movieItems.count
    }
    
    func getItem(index : Int) -> MovieUIModel? {
        return movieItems[index]
    }
    
    
    /*func searchMovies(query : String, onComplete : @escaping ()->()) {
        apiService.searchMovies(searchTerm: query)
            .observe(on: MainScheduler.instance)
            .subscribe { response in
                self.movieResponse = response
                onComplete()
            } onFailure: { error in
                print(error)
            }.disposed(by: disposeBag)
    }*/
}
