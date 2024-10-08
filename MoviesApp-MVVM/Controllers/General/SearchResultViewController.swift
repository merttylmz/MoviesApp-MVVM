//
//  SearchResultViewController.swift
//  MoviesApp-MVVM
//
//  Created by Mert Yılmaz on 2.09.2024.
//

import UIKit
import SnapKit

protocol SearchResultViewControllerDelegate: AnyObject {
    func SearchResultViewControllerDidTappedItem(_ viewModel: TitlePreviewViewModel)
}

class SearchResultViewController: UIViewController {

    public var titles: [Title] = [Title]()
    
    public weak var delegate: SearchResultViewControllerDelegate?
    
    // MARK: - Properties
    lazy var searchResultCollectionView =  UICollectionView()
    /*
    {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 11, height: 200)
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        
        //burda neden screenwidth ulaşamıyorum
        
        return collectionView
    }()
    */
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setupCollectionView()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultCollectionView.frame = view.bounds
    }
    
    
    
    // MARK: - Helpers
    
    func setupCollectionView(){
        // layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (screenWidth / 3) - 10 , height: screenHeight / 4)
        //layout.minimumInteritemSpacing = 3
        //searchResultCollectionView
        searchResultCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        searchResultCollectionView.delegate = self
        searchResultCollectionView.dataSource = self
        searchResultCollectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        
        view.addSubview(searchResultCollectionView)
    }
    
    
    
    
}

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        let title = titles[indexPath.row]
        cell.configure(with: title.poster_path ?? "")
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        let titleName = title.original_title ?? ""
        
        APICaller.shared.getMovie(with: titleName) { [weak self]result in
            
            
            switch result {
            case .success(let videoId):
                
                    guard let videoId = videoId else {return}
                    self?.delegate?.SearchResultViewControllerDidTappedItem(TitlePreviewViewModel(title: titleName, youtubeView: String(videoId), titleOverview: title.overview ?? ""))
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
      
    }
    
}
