//
//  TitleCollectionViewCell.swift
//  MoviesApp-MVVM
//
//  Created by Mert Yılmaz on 30.08.2024.
//

import UIKit
import SDWebImage


class TitleCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TitleCollectionViewCell"
    
    private let posterImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
        
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    

    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = contentView.bounds

    }
    
    public func configure(with model: String) {
        
        guard let url = URL(string: "https://image.tmdb.org/t/p/original/\(model)") else {return}
        
        posterImageView.sd_setImage(with: url, completed: nil)
        
    }
    
    
    
    
}
