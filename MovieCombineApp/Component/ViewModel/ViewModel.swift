//
//  ViewModel.swift
//  MovieCombineApp
//
//  Created by Amr on 21/11/2021.
//

import UIKit
import Combine

class ViewModel{
    var cancellables: Set<AnyCancellable> = []

    let serviceProvider = Service.sharedInstance
     
     @Published var keyWordSearch: String = ""
     
     var diffableDataSource: MoviesTableViewDiffableDataSource!
     var snapshot = NSDiffableDataSourceSnapshot<String?, Result>()
    
    
    init(){
        $keyWordSearch
            .receive(on: RunLoop.main)
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { (_) in
                self.fetchMovies()
            }.store(in: &cancellables)
    }
            
    
    func fetchMovies() {
        serviceProvider.fetchFilms(for: keyWordSearch) { (results) in
              guard self.diffableDataSource != nil else { return }
              
              self.snapshot.deleteAllItems()
              self.snapshot.appendSections([""])
              
              if results.isEmpty
              {
                  self.diffableDataSource.apply(self.snapshot, animatingDifferences: true)
                  return
              }
          
              self.snapshot.appendItems(results, toSection: "")
              self.diffableDataSource.apply(self.snapshot, animatingDifferences: true)
          }
    }
}
