//
//  TitleTableViewCell.swift
//  MoviesApp-MVVM
//
//  Created by Mert Yılmaz on 1.09.2024.
//

import UIKit

class TitleTableViewCell: UITableViewCell {
    
    static let identifier = "TitleTableViewCell"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    
    private let titlePosterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    private let playTitleButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setupUI(){
        contentView.addSubview(titlePosterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(playTitleButton)
        
        applyConstraints()
    }
    
    func applyConstraints(){
        // ImageView - Constraints
        titlePosterImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(5)
            make.bottom.equalTo(contentView).offset(-5)
            make.width.equalTo(120)
            make.left.equalTo(contentView).offset(5)
        }
        
        // Label - Constraints

        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(titlePosterImageView.snp.right).offset(30)
            make.centerY.equalTo(contentView)
            make.right.lessThanOrEqualTo(contentView).offset(-15)
        }
        
        // Label - Constraints

        playTitleButton.snp.makeConstraints { make in
            make.centerX.equalTo(titlePosterImageView.snp.centerX)
            make.centerY.equalTo(titlePosterImageView.snp.centerY)
        }
    }
    
    public func configure(with model: TitleViewModel){
        
        guard let url = URL(string: "https://image.tmdb.org/t/p/original/\(model.posterURL)") else {
            return print("sdgsd")
        }
        
        titlePosterImageView.sd_setImage(with: url, completed: nil)
        
        titleLabel.text = model.titleName
        
    }
    
}
