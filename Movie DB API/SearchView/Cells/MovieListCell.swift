//
//  MovieListCell.swift
//  Movie DB API
//
//  Created by Mehedi Hasan on 5/8/22.
//

import UIKit

class MovieListCell: UITableViewCell {

    static var id: String {
        return "MovieListCell"
    }
    
    private lazy var moviePosterView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "placeHolderImage")
        imageView.contentMode  = .scaleAspectFit
        return imageView
    }()
    
    private lazy var movieNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "TimesNewRomanPSMT", size: 16)
        label.text = "Captain Marvel"
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "TimesNewRomanPSMT", size: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        setupViews()
    }
    
    private func setupViews() {
        self.addSubview(containerView)
        containerView.addSubview(moviePosterView)
        containerView.addSubview(movieNameLabel)
        containerView.addSubview(descriptionLabel)
        
        containerView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor)
        
        moviePosterView.anchor(left: containerView.leftAnchor, right: movieNameLabel.leftAnchor, paddingLeft: 10, paddingRight: 10, height: 150, width: 100)
        moviePosterView.topAnchor.constraint(greaterThanOrEqualTo: containerView.topAnchor, constant: 10).isActive = true
        moviePosterView.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: 10).isActive = true
        moviePosterView.centerY(view: containerView)
        
        movieNameLabel.anchor(top: containerView.topAnchor, bottom: descriptionLabel.topAnchor, right: containerView.rightAnchor, paddingTop: 5, paddingBottom: 7, paddingRight: 10)
        descriptionLabel.anchor(left: movieNameLabel.leftAnchor, right: movieNameLabel.rightAnchor)
        descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -5).isActive = true
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
