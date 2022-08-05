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
    
    private var viewModel: LandingPageViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        viewModel = LandingPageViewModel()
        setupSearchController()
        setupViews()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            movieTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        movieTableView.contentInset = .zero
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loader.startAnimating()
        viewModel.getMovieList(searchText: "Marvel") { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.loader.stopAnimating()
                self.movieTableView.reloadData()
            }
        }
    }
    
    private func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.text = "Marvel"
        searchController.searchBar.placeholder = "Search movies"
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = true
    }
    
    private func setupViews() {
        self.view.addSubview(movieTableView)
        self.view.addSubview(loader)
        
        loader.centerY(view: self.view)
        loader.centerX(view: self.view)
        movieTableView.anchor(top: self.view.topAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor)
    }
}

extension LandingPageViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        loader.startAnimating()
        viewModel.getMovieList(searchText: searchText) { [weak self] in
            DispatchQueue.main.async {
                self?.loader.stopAnimating()
                self?.movieTableView.reloadData()
            }
        }
    }
}

extension LandingPageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = movieTableView.dequeueReusableCell(withIdentifier: MovieListCell.id, for: indexPath) as? MovieListCell else {
            return UITableViewCell()
        }
        
        let model = viewModel.getMovieModel(indexPath: indexPath)
        cell.configure(model: model)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Movie List"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
}

extension LandingPageViewController: UITableViewDelegate {
    
}


