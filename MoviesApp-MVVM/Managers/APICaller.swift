//
//  APICaller.swift
//  MoviesApp-MVVM
//
//  Created by Mert Yılmaz on 29.08.2024.
//

import Foundation

struct Constant {
    static var url = "api.themoviedb.org/3/trending/movie/day?api_key=b3d14fe0033bac282efa8e8652e9c0a9"
    static let API_KEY = ""
    static let baseURL = "https://api.themoviedb.org"
}

enum APIError: Error {
    case failedGetData
}

enum APIEndpoint: String {
    case trendingMovies = "/3/trending/movie/day"
    case trendingTVs = "/3/trending/tv/day"
    case upcomingMovies = "/3/movie/upcoming"
    case popularMovies = "/3/movie/popular"
    case topRatedMovies = "/3/movie/top_rated"
}



class APICaller {
    static let shared = APICaller()
    
    
    
    func fetchData(from endpoint: APIEndpoint, completion: @escaping (Result<[Title],Error>) -> Void){
        
        guard let url = URL(string: "\(Constant.baseURL)\(endpoint.rawValue)?api_key=\(Constant.API_KEY)") else { return }

        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do{
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            }catch{
                completion(.failure(APIError.failedGetData))
            }
        }
        task.resume()
    }
    
    func getTrendingMovies(completion: @escaping(Result<[Title], Error>) -> Void){
        fetchData(from: .trendingMovies, completion: completion)
    }
    
    func getTrendingTVs(completion: @escaping (Result<[Title], Error>) -> Void) {
        fetchData(from: .trendingTVs, completion: completion)
    }
    
    func getUpcomingMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        fetchData(from: .upcomingMovies, completion: completion)
    }

    func getPopular(completion: @escaping (Result<[Title], Error>) -> Void) {
        fetchData(from: .popularMovies, completion: completion)
    }

    func getTopRated(completion: @escaping (Result<[Title], Error>) -> Void) {
        fetchData(from: .topRatedMovies, completion: completion)
    }

    func getDiscoverMovies(completion: @escaping (Result<[Title],Error>) -> Void) {
        
        guard let url = URL(string: "\(Constant.baseURL)/3/discover/movie?api_key=\(Constant.API_KEY)&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate") else {return}
                
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do{
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            }catch{
                completion(.failure(APIError.failedGetData))
            }
        }
        task.resume()
    }
}

//  https://api.themoviedb.org/3/discover/movie?api_key=\b3d14fe0033bac282efa8e8652e9c0a9&sort_by=popularity.desc&page=1&with_watch_monetization_types=flatrat
