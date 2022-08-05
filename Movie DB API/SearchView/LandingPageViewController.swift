//
//  ViewController.swift
//  Movie DB API
//
//  Created by Mehedi Hasan on 5/8/22.
//

import UIKit

class LandingPageViewController: UIViewController {

    private lazy var movieTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = .white
        tableView.register(MovieListCell.self, forCellReuseIdentifier: MovieListCell.id)
        return tableView
    }()
    
    private lazy var loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView(style: .large)
        return loader
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(false, animated: true)
        setupViews()
    }
    
    private func setupViews() {
        self.view.addSubview(movieTableView)
        self.view.addSubview(loader)
        
        loader.centerY(view: self.view)
        loader.centerX(view: self.view)
        movieTableView.anchor(top: self.view.topAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor)
    }
}

extension LandingPageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = movieTableView.dequeueReusableCell(withIdentifier: MovieListCell.id, for: indexPath) as? MovieListCell else {
            return UITableViewCell()
        }
        return cell
    }
}

extension LandingPageViewController: UITableViewDelegate {
    
}


