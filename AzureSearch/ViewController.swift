//
//  ViewController.swift
//  AzureSearch
//
//  Created by Mahmut Canga on 04/01/2017.
//  Copyright © 2017 Canga IT Solutions. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var searchbar: UISearchBar! {
        
        didSet {
            
            searchbar.delegate = self
        }
    }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var tableView: UITableView! {
        
        didSet {
            
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        }
    }
    
    var searchResult: SearchResult?
    
    var searchResultCount:Int = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        activityIndicator.startAnimating()
        Network().fetchTotalCount(result: fetchTotalDidComplete)
    }
    
    func fetchTotalDidComplete(searchResult: SearchResult?) {
        
        activityIndicator.stopAnimating()
        
        guard let searchCount = searchResult?.count else {
            
            searchbar.placeholder = "Search properties..."
            return
        }
        
        searchResultCount = searchCount
        searchbar.placeholder = "Search \(searchCount) properties..."
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("search suggestion did click \(searchResult?.assets?[indexPath.row].listingId)")
        
        let propertyViewController = PropertyViewController()
        propertyViewController.listingId = searchResult?.assets?[indexPath.row].listingId
        navigationController?.pushViewController(propertyViewController, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return searchResultCount
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let assetsCount = searchResult?.assets?.count, indexPath.row < assetsCount else {
            
            return UITableViewCell()
        }
        
        guard let asset = searchResult?.assets?[indexPath.row] else {
            
            return UITableViewCell()
        }
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "tablecell")
        cell.textLabel?.text = asset.searchText
        return cell
    }
}

extension ViewController: UISearchBarDelegate {
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        Network().fetch(suggestionsFor: searchText) { (searchResult: SearchResult?) in
            
            self.searchResult = searchResult
            self.tableView.reloadData()
        }
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let searchResultViewController = SearchResultViewController()
        searchResultViewController.keyword = searchBar.text
        navigationController?.pushViewController(searchResultViewController, animated: true)
    }
}











