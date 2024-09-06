//
//  SearchViewController.swift
//  MoviesApp-MVVM
//
//  Created by Mert Yılmaz on 27.08.2024.
//

import UIKit

class SearchViewController: UIViewController {

    // MARK: - Properties
    
    private var titles: [Title] = [Title]()
    
    
    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: SearchResultViewController())
        searchController.searchBar.placeholder = "Search for a Movie or Tv show"
        searchController.searchBar.searchBarStyle = .minimal
        searchController.hidesNavigationBarDuringPresentation = true
        return searchController
    }()
    
    
    private let searchTable: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGreen
        
        setupSearchUI()
        applyConstraints()
        
        fetchDiscoverMovies()
        searchController.searchResultsUpdater = self
    }
    
    // MARK: - Helpers
    func setupSearchUI(){
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        view.addSubview(searchTable)
        searchTable.delegate = self
        searchTable.dataSource = self
        
        navigationItem.searchController = searchController
        navigationController?.navigationBar.tintColor = .white
    }
    
    func applyConstraints(){
        // TableView - Constaints
        searchTable.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
    }

    func fetchDiscoverMovies(){
        APICaller.shared.getDiscoverMovies { [weak self] result in
            switch result {
            case .success(let titles):
                
                self?.titles = titles
                
                DispatchQueue.main.async {
                    self?.searchTable.reloadData()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}

// MARK: - Extensions and Functions

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        let title = titles[indexPath.row]
        let model = TitleViewModel(titleName: title.original_title ?? "Unknown name", posterURL: title.poster_path ?? "")
        cell.configure(with: model)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        
        guard let titleName = title.original_title ?? title.original_name else {return}
        
        APICaller.shared.getMovie(with: titleName) { result in
            
            
            switch result {
            case .success(let videoId):
                
                DispatchQueue.main.async {
                    
                    guard let videoId = videoId else {return}
                    
                    let vc = TitlePreviewViewController()
                    
                    vc.configure(with: TitlePreviewViewModel(title: titleName, youtubeView: String(videoId), titleOverview: title.overview ?? ""))
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension SearchViewController: UISearchResultsUpdating, SearchResultViewControllerDelegate {
    
    
    
    func updateSearchResults(for searchController: UISearchController) {
        
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultsController = searchController.searchResultsController as? SearchResultViewController else {return}
        resultsController.delegate = self
        
        APICaller.shared.searchMovies(with: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let titles):
                    resultsController.titles = titles
                    resultsController.searchResultCollectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }

    }
    
    func SearchResultViewControllerDidTappedItem(_ viewModel: TitlePreviewViewModel) {
        
        DispatchQueue.main.async { [weak self] in
            
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel)
            
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}
