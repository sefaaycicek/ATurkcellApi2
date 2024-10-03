//
//  ViewController.swift
//  ATurkcellApi2
//
//  Created by Sefa Aycicek on 3.10.2024.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    let CELL_PADDING : CGFloat = 10
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar : UISearchBar!
    
    let viewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        observeItems()
        viewModel.searchMovies(query: "star")
        
        /*viewModel.searchMovies(query: "star", onComplete: {
            
        })*/
    }
    
    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "MovieCollectionCell", bundle: nil),
                                forCellWithReuseIdentifier: "MovieCollectionCell")
        
        let viewLayout = UICollectionViewFlowLayout()
        viewLayout.scrollDirection = .vertical
        collectionView.collectionViewLayout = viewLayout
    }
    
    func observeItems() {
        
        searchBar.rx.text.orEmpty
            .debounce(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { searchText in
                self.viewModel.searchMovies(query: searchText)
            }.disposed(by: self.viewModel.disposeBag)
        
        
        viewModel.needUpdateUI
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                print("result : \(result)")
                self.collectionView.reloadData()
            }.disposed(by: self.viewModel.disposeBag)
        
        viewModel.isLoading.subscribe { isLoading in
            print("start progress")
        }.disposed(by: self.viewModel.disposeBag)
        
    }
}

extension ViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let model = viewModel.getItem(index: indexPath.row) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionCell", for: indexPath) as! MovieCollectionCell
            cell.configure(model: model)
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension ViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // CGRect
        // CGPoint
        /*if (indexPath.row + 1).isMultiple(of: 3) {
            return CGSize(width: collectionView.bounds.width  - CELL_PADDING * 2,
                          height: collectionView.bounds.width - CELL_PADDING * 2)
        }*/
        let collectionViewSize = collectionView.bounds.width - CELL_PADDING * 3
        let width = collectionViewSize / 2
        let ratio = 445.0 / 300.0
        let height = width * ratio
        
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: CELL_PADDING, left: CELL_PADDING, bottom: CELL_PADDING, right: CELL_PADDING)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CELL_PADDING
    }
}

/*extension ViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchMovies(query: searchBar.text ?? "star")
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchMovies(query: searchBar.text ?? "star")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    
        return true
    }
}
*/
