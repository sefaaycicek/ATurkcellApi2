//
//  BaseViewModel.swift
//  ATurkcellApi2
//
//  Created by Sefa Aycicek on 3.10.2024.
//

import UIKit
import RxRelay
import RxSwift

class BaseViewModel {
    let disposeBag = DisposeBag()
    let isLoading: BehaviorRelay<Bool> = .init(value: false)

}
