//
//  MovieServiceManager.swift
//  Movie DB API
//
//  Created by Mehedi Hasan on 5/8/22.
//

import Foundation

protocol MovieServiceInteractor {
    func getMovieList(with searchText: String, completion: @escaping (Result<MovieServiceResponse, MovieServiceError>) -> Void)
}

struct MovieService: Decodable {
    let id: Int
    let originalTitle: String
    let overview: String
    let posterUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id, overview
        case originalTitle = "original_title"
        case posterUrl = "poster_path"
    }
}

struct MovieServiceResponse: Decodable {
    let results: [MovieService]
    let page: Int
}

enum MovieServiceError: Error, LocalizedError {
    case urlParsingError
    case responseError(Error)
    case dataNilError
    case decodeError
    
    var errorDescription: String? {
        switch self {
        case .urlParsingError:
            return "Could not parse from string to URL"
        case .responseError(let error):
            return "Data fetching is failed with error \(error.localizedDescription)"
        case .dataNilError:
            return "Fetched data is nil"
        case .decodeError:
            return "Could not parse response data"
        }
    }
    
}

class MovieServiceManager {
    
    let apiKey: String = "38e61227f85671163c275f9bd95a8803"
    let baseUrl: String = "https://api.themoviedb.org/3/search/movie"
    let fullUrl: String
    
    init() {
        fullUrl = "\(baseUrl)?api_key=\(apiKey)"
    }
}

extension MovieServiceManager: MovieServiceInteractor {
    func getMovieList(with searchText: String, completion: @escaping (Result<MovieServiceResponse, MovieServiceError>) -> Void) {
        let urlString = "\(fullUrl)&query=\(searchText)"
        
        print("full url \(urlString)")
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.urlParsingError))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                completion(.failure(.responseError(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.dataNilError))
                return
            }
            
            guard let movieData = try? JSONDecoder().decode(MovieServiceResponse.self, from: data) else {
                print("could not decode")
                completion(.failure(.decodeError))
                return
            }
            
            print("Fetched movie count \(movieData.results.count)")
            completion(.success(movieData))
            return
        }.resume()
    }
}