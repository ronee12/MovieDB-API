//
//  LandingPageViewModel.swift
//  Movie DB API
//
//  Created by Mehedi Hasan on 5/8/22.
//

import Foundation

struct MovieModel {
    let moviePosterUrl: String
    let movieName: String
    let movieDescription: String
}

class LandingPageViewModel {
    
    private var dataCollection: [MovieModel] = []
    let interactor: MovieServiceInteractor
    
    init() {
        self.interactor = MovieServiceManager()
    }
    
    func getMovieList(searchText: String, completion: @escaping (Bool) -> Void) {
        dataCollection.removeAll()
        interactor.getMovieList(with: searchText) { [weak self] result in
            guard let self = self else {
                completion(false)
                return
            }
            
            switch result {
            case .success(let movieData):
                self.dataCollection = movieData.results.map ({
                    return MovieModel(moviePosterUrl: $0.posterUrl, movieName: $0.originalTitle, movieDescription: $0.overview)
                })
                completion(true)
                
            case .failure(let error):
                print("failed with error \(error.localizedDescription)")
                completion(false)
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
