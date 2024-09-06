//
//  UpcomingViewController.swift
//  MoviesApp-MVVM
//
//  Created by Mert Yılmaz on 27.08.2024.
//

import UIKit

class UpcomingViewController: UIViewController {

    // MARK: - Properties

    private var titles: [Title] = [Title]()
    private let upcomingTable = UITableView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        setupUpcomingUI()
        fetchUpcoming()
        print(titles)
    }
    
    // MARK: - Helpers
    
    private func fetchUpcoming(){
        APICaller.shared.getUpcomingMovies {[weak self] result in
            switch result {
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.sync {
                    self?.upcomingTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
        
    
    private func setupUpcomingUI(){
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        title = "Upcoming"
        
        upcomingTable.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        view.addSubview(upcomingTable)
        upcomingTable.delegate = self
        upcomingTable.dataSource = self
        
        // - Constraints
        upcomingTable.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
    }


}

// MARK: - Extension and Functions
extension UpcomingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        
        let title = titles[indexPath.row]
        cell.configure(with: TitleViewModel.init(titleName: title.original_name ?? title.original_title ?? "Unknown", posterURL: title.poster_path ?? ""))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
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
