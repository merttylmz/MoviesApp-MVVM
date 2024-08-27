//
//  HomeViewController.swift
//  MoviesApp-MVVM
//
//  Created by Mert Yılmaz on 27.08.2024.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    private var homeFeedTable = UITableView(frame: .zero, style: .grouped)
    
    let sectionTitles = ["Trending Movies","Populer","Trending TV", "Upcoming Movies", "Top Rated"]
    
// MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .darkGray
        
        setupUI()
        configureNavigationBar()
    }
    
    
    // MARK: - Helpers
    func setupUI(){
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        homeFeedTable.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        view.addSubview(homeFeedTable)
        homeFeedTable.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        // Header
        let headerView = HeroHeadUIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight * 0.37))
        homeFeedTable.tableHeaderView = headerView
    }

    func configureNavigationBar(){
        
        lazy var image = UIImage(systemName: "sparkles.tv")
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        navigationController?.navigationBar.tintColor = .systemRed
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
        let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath)
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
        header.textLabel?.font = .systemFont(ofSize: fontSize, weight: .semibold)
        header.textLabel?.frame = CGRect(x: 11, y: 11, width: 100, height: 200)
        header.textLabel?.textColor = .lightGray
        //header.textLabel?.text = header.textLabel?.text?.lowercased()
    }
     
}
