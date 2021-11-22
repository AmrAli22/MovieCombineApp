//
//  Services.swift
//  MovieCombineApp
//
//  Created by Amr on 21/11/2021.
//

import UIKit
class Service {
    let API_KEY = "k_5w36e450"
    let endpoint = "https://imdb-api.com/en/API/SearchMovie/"
    
    static var sharedInstance = Service()
    private init(){}
    
    func fetchFilms(for keyWordSearch: String, completionHandler: @escaping ([Result]) -> Void) {
        
        guard let endpoint = URL(string: endpoint + API_KEY + "/" + keyWordSearch) else { return }

        let task = URLSession.shared.dataTask(with: endpoint, completionHandler: { (data, response, error) in
            print("response\(response)")
            print("data\(data)")
            print("error\(error)")
          if let error = error {
            print("Error with fetching films: \(error)")
            return
          }
          
          guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
            print("Error with the response, unexpected status code: \(response)")
            return
          }

          if let data = data,
            let filmSummary = try? JSONDecoder().decode(Response.self, from: data) {
              print("filmSummary\(filmSummary)")
            completionHandler(filmSummary.results ?? [])
          }
        })
        task.resume()
      }
}
