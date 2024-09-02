//
//  HeroHeadUIView.swift
//  MoviesApp-MVVM
//
//  Created by Mert Yılmaz on 28.08.2024.
//

import UIKit
import SnapKit

class HeroHeadUIView: UIView {
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImage()
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setupImage(){
        
        lazy var heroImageView = UIImageView()
        heroImageView.image = UIImage(named: "heroImage")
        addSubview(heroImageView)

        
        heroImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(screenHeight*0.35)
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
        playButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(0.295 * screenHeight)
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
            make.top.equalToSuperview().offset(0.295 * screenHeight)
            make.right.equalToSuperview().offset(-0.2 * screenWidth)
            make.width.equalTo(screenWidth * 0.25)

        }
    }
}
