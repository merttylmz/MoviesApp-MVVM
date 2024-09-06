//
//  CollectionViewTableViewCell.swift
//  MoviesApp-MVVM
//
//  Created by Mert Yılmaz on 27.08.2024.
//

import UIKit

protocol CollectionViewTableViewCellDelegate: AnyObject {
    func CollectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel)
}



class CollectionViewTableViewCell: UITableViewCell {
    
    static let identifier = "CollectionViewTableViewCell"
    
    weak var delegate: CollectionViewTableViewCellDelegate?
    
    private var titles: [Title] = [Title]()
    
    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .orange
        createCollectionView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Helpers
    private func createCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: screenWidth * 0.3, height: screenHeight * 0.45)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top)
            make.left.equalTo(contentView.snp.left)
            make.right.equalTo(contentView.snp.right)
            make.bottom.equalTo(contentView.snp.bottom)
            
        }
    }
    
    public func configure(with titles: [Title]) {
        self.titles = titles
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    private func downloadTitleAt(indexPath: IndexPath) {
        print("Downloading \(titles[indexPath.row].original_title)")
    }
    
    
}

// MARK: - Extension
extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        guard let model = titles[indexPath.row].poster_path else {
            return UICollectionViewCell()
        }
        //print(model.count)
        cell.configure(with: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        
        guard let titleName = title.original_title ?? title.original_name else {return}
        
        APICaller.shared.getMovie(with: titleName + "trailer") { [weak self] result in
            
            switch result {
                
            case .success(let videoId):
                guard let videoId = videoId else {return}
                
                let title = self?.titles[indexPath.row]
                
                guard let titleOverview = title?.overview else {return}
                
                guard let strongSelf = self else {return}
                
                let viewModel = TitlePreviewViewModel(title: title?.original_title ?? titleName , youtubeView: String(videoId), titleOverview: titleOverview)
                
                self?.delegate?.CollectionViewTableViewCellDidTapCell(strongSelf, viewModel: viewModel)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
            
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
            
            let config = UIContextMenuConfiguration(identifier: nil,
                                                    previewProvider: nil) { [weak self] _ in
                let downloadAction = UIAction(title: "Download", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                    self?.downloadTitleAt(indexPath: indexPath)
                }
                return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
            }
            return config
        }
}
