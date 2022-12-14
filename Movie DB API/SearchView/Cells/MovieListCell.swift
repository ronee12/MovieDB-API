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
    
    private var movieId: Int = 0
    
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
    
    func configure(model: MovieModel) {
        movieNameLabel.text = model.movieName
        descriptionLabel.text = model.movieDescription
        self.movieId = model.id
        
        if let moviePosterUrl = model.moviePosterUrl {
            MovieServiceManager().loadWith(imageUrl: moviePosterUrl) { [weak self] result in
                
                guard let self = self else {
                    return
                }
                
                if self.movieId != model.id {
                    return
                }
                
                switch result {
                case .success(let image):
                    DispatchQueue.main.async {
                        self.moviePosterView.image = image
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.moviePosterView.image  = UIImage(named: "placeHolderImage")
                    }
                    print("image fetching failed with error \(error.localizedDescription)")
                }
            }
        } else {
            self.moviePosterView.image = UIImage(named: "placeHolderImage")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
