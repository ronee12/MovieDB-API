//
//  LandingPageViewModel.swift
//  Movie DB API
//
//  Created by Mehedi Hasan on 5/8/22.
//

import Foundation

struct MovieModel {
    let id: Int
    let moviePosterUrl: String?
    let movieName: String?
    let movieDescription: String?
}

class LandingPageViewModel {
    
    private var dataCollection: [MovieModel] = []
    let interactor: MovieServiceInteractor
    
    init() {
        self.interactor = MovieServiceManager()
    }
    
    func getMovieList(searchText: String, completion: @escaping () -> Void) {
        dataCollection.removeAll()
        if searchText.isEmpty {
            completion()
            return
        }
        
        interactor.getMovieList(with: searchText) { [weak self] result in
            guard let self = self else {
                completion()
                return
            }
            
            switch result {
            case .success(let movieData):
                self.dataCollection = movieData.results.map ({
                    return MovieModel(id: $0.id, moviePosterUrl: $0.posterUrl, movieName: $0.originalTitle, movieDescription: $0.overview)
                })
                completion()
                
            case .failure(let error):
                print("failed with error \(error.localizedDescription)")
                completion()
            }
        }
    }
    
}

extension LandingPageViewModel {
    
    var numberOfRows: Int {
        return dataCollection.count
    }
    
    func getMovieModel(indexPath: IndexPath) -> MovieModel {
        return dataCollection[indexPath.row]
    }
}
