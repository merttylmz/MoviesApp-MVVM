//
//  HeroHeadUIView.swift
//  MoviesApp-MVVM
//
//  Created by Mert Yılmaz on 28.08.2024.
//

import UIKit
import SnapKit

class HeroHeadUIView: UIView {
    
    lazy var heroImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImage()
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    // MARK: - HELPERS
    func setupImage(){
        
        
        heroImageView.image = UIImage(named: "heroImage")
        heroImageView.contentMode = .scaleToFill
        addSubview(heroImageView)

        
        heroImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(screenHeight * 0.5)
        }
        addGragiend()
    }
    
    func addGragiend(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }
    
    func setupButton(){
        lazy var playButton = UIButton()
        playButton.setTitle("Play", for: .normal)
        playButton.layer.borderColor = UIColor.white.cgColor
        playButton.layer.borderWidth = 1
        playButton.layer.cornerRadius = 6
        addSubview(playButton)
        print(screenWidth,screenHeight)
        playButton.snp.makeConstraints { make in
            make.top.equalTo(heroImageView.snp.bottom).offset(-screenHeight * 0.0476)
            make.left.equalToSuperview().offset(0.2 * screenWidth)
            make.width.equalTo(screenWidth * 0.25)
        }
        
        lazy var downloadButton = UIButton()
        downloadButton.setTitle("Download", for: .normal)
        downloadButton.layer.borderColor = UIColor.white.cgColor
        downloadButton.layer.borderWidth = 1
        downloadButton.layer.cornerRadius = 6
        addSubview(downloadButton)
        downloadButton.snp.makeConstraints { make in
            make.top.equalTo(heroImageView.snp.bottom).offset(-screenHeight * 0.0476)
            make.right.equalToSuperview().offset(-0.2 * screenWidth)
            make.width.equalTo(screenWidth * 0.25)

        }
    }
    public func configure(with model: TitleViewModel){
        guard let url = URL(string: "https://image.tmdb.org/t/p/original/\(model.posterURL)") else {return}
        
        heroImageView.sd_setImage(with: url, completed: nil)
        
    }
    
}
