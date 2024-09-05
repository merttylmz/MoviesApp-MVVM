//
//  TitlePreviewViewController.swift
//  MoviesApp-MVVM
//
//  Created by Mert Yılmaz on 5.09.2024.
//

import UIKit
import WebKit

class TitlePreviewViewController: UIViewController {
    
    // MARK: - Properties
    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    private let titleLabel: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22,weight: .bold)
        label.numberOfLines = 0
        label.text = "StarWars"
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        label.text = "This is the magnaficant movie ever seen falan yazabilrisin."
        return label
    }()
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        button.setTitle("Download", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 7
        button.layer.masksToBounds = true
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConstraints()
        
    }
    
    // MARK: - Helpers
    func setupConstraints(){
        view.addSubview(webView)
        view.addSubview(titleLabel)
        view.addSubview(overviewLabel)
        view.addSubview(downloadButton)
        
        
        // WebView - Constraints
        webView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.height.equalTo(screenHeight * 0.25)
        }
        
        // TitleLabel - Constraints
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(webView.snp.bottom).offset(screenWidth * 0.03)
            make.left.equalTo(view.snp.left).offset(screenWidth * 0.025)
        }
        
        // CommentLabel - Constraints
        overviewLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(screenWidth * 0.03)
            make.left.equalTo(titleLabel.snp.left)
            make.right.equalTo(view.snp.right)
        }
        
        // Button - Constraints
        downloadButton.snp.makeConstraints { make in
            make.top.equalTo(overviewLabel.snp.bottom).offset(screenWidth * 0.03)
            make.left.equalTo(overviewLabel.snp.left)
            make.width.equalTo(screenWidth*0.25)
            
        }
        
    }
    func configure(with model: TitlePreviewViewModel) {
        titleLabel.text = model.title
        overviewLabel.text = model.titleOverview
        
        guard let url = URL(string: "https://www.youtube.com/watch?v=\(model.youtubeView)") else {return}
        print(url)
        webView.load(URLRequest(url: url))
    }
    
}
