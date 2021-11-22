//
//  ViewController.swift
//  MovieCombineApp
//
//  Created by Amr on 21/11/2021.
//

import UIKit
import Combine

class MoviesTableViewDiffableDataSource: UITableViewDiffableDataSource<String?, Result> {}


class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    @Published var keyStroke: String = ""
    var cancellables: Set<AnyCancellable> = []
    var viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        setupObservers()
    }
}

// MARK: - Setup UI & Cells
extension ViewController {
    func registerCell(){
        let movieCell = UINib(nibName: MovieCell.reuseIdentifier, bundle: nil)
        tableView.register(movieCell, forCellReuseIdentifier: MovieCell.reuseIdentifier)
    }
}

//MARK: - UISearchBar Delegate
extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        self.keyStroke = searchText
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.keyStroke = ""
    }
}

//MARK: - Observers
extension ViewController {
    func setupObservers(){
         // MONITOR search bar textfield keystrokes
        
         $keyStroke
             .receive(on: RunLoop.main)
             .sink { (keyWordValue) in
                 print(keyWordValue)
                 self.viewModel.keyWordSearch = keyWordValue
         }.store(in: &cancellables)
         
         // DIFFABLE DS
         viewModel.diffableDataSource = MoviesTableViewDiffableDataSource(tableView: tableView) { (tableView, indexPath, model) -> UITableViewCell? in
             
             guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.reuseIdentifier, for: indexPath) as? MovieCell
             else { return UITableViewCell() }
             
             cell.movieObject = model
             return cell
         }
     }
}
