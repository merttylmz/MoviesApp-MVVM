//
//  HomeViewController.swift
//  MoviesApp-MVVM
//
//  Created by Mert Yılmaz on 27.08.2024.
//

import UIKit
import SnapKit

enum Sections: Int {
    case TrendingMovies = 0
    case Popular = 1
    case TrendingTv = 2
    case Upcoming = 3
    case topRated = 4
}



class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    private var homeFeedTable = UITableView(frame: .zero, style: .grouped)
    
    let sectionTitles = ["Trending Movies","Populer","Trending TV", "Upcoming Movies", "Top Rated"]
    
    private var randomTrendingMovie: Title?
    private var headerView: HeroHeadUIView?
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupHomeUI()
        configureNavigationBar()
        configureHeroHeaderView()
    }
    
    
    // MARK: - Helpers
    private func setupHomeUI(){
        view.backgroundColor = .systemBackground
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        homeFeedTable.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        view.addSubview(homeFeedTable)
        homeFeedTable.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        // Header View
        setupHeaderView()
    }
    private func setupHeaderView(){
        headerView = HeroHeadUIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight * 0.5))
        homeFeedTable.tableHeaderView = headerView
    }
    
    private func configureNavigationBar(){
        
        lazy var image = UIImage(systemName: "sparkles.tv")
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        navigationController?.navigationBar.tintColor = .systemRed
    }
    

    private func configureHeroHeaderView() {
        APICaller.shared.getTrendingMovies { [weak self] result in
            switch result {
            case .success(let titles):
                let selectedTitle = titles.randomElement()
                self?.randomTrendingMovie = titles.randomElement()
                self?.headerView?.configure(with: TitleViewModel(titleName: selectedTitle?.original_title ?? "", posterURL: selectedTitle?.poster_path ?? ""))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}
    // MARK: - Extension and Functions
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else { 
            return UITableViewCell()
        }
        
        cell.delegate = self
        
        switch indexPath.section {
        case Sections.TrendingMovies.rawValue:
            APICaller.shared.getTrendingMovies { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.TrendingTv.rawValue:
            APICaller.shared.getTrendingTVs { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.Popular.rawValue:
            APICaller.shared.getPopular { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.Upcoming.rawValue:
            APICaller.shared.getUpcomingMovies { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.topRated.rawValue:
            APICaller.shared.getTopRated { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        default:
            return UITableViewCell()
        }
        return cell
    }
        
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        header.textLabel?.font = .systemFont(ofSize: titleFontSize, weight: .semibold)
        header.textLabel?.frame = CGRect(x: 11, y: 11, width: 100, height: 200)
        header.textLabel?.textColor = .lightGray
        header.textLabel?.text = header.textLabel?.text?.uppercased()
    }
     
}

extension HomeViewController: CollectionViewTableViewCellDelegate {
    func CollectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel) {
        
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel)
            //vc.hidesBottomBarWhenPushed = false
            //vc.modalPresentationStyle = .fullScreen
            //vc.modalTransitionStyle = .coverVertical
            self?.navigationController?.pushViewController(vc, animated: true)
            //self?.navigationController?.interactivePopGestureRecognizer?.delegate = nil


        }
        
    }
}
