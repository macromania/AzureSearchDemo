//
//  SearchResultViewController.swift
//  AzureSearch
//
//  Created by Mahmut Canga on 05/01/2017.
//  Copyright © 2017 Canga IT Solutions. All rights reserved.
//

import UIKit
import Kingfisher

class SearchResultViewController: PropertyViewController {
    
    var keyword: String?
    
    var searchResult: SearchResult?
    
    override func viewDidLoad() {
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        
        view.addSubview(tableView!)
        view.backgroundColor = UIColor.white
        
        guard let keywordValidated = keyword else {
            
            print("No prop details for listingId \(keyword)")
            return
        }
        
        navigationItem.title = keywordValidated
        
        Network().fetch(resultsFor: keywordValidated) { (searchResult: SearchResult?) in
            
            self.searchResult = searchResult
            self.tableView?.reloadData()
            
            if let count = searchResult?.count {
                
                self.navigationItem.title = keywordValidated + " - \(count) results"
            }
            
        }
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let asset = searchResult?.assets?[indexPath.row] else {
            
            return
        }
        
        let propertyViewController = PropertyViewController()
        propertyViewController.listingId = asset.listingId
        navigationController?.pushViewController(propertyViewController, animated: true)

    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let searchResultCount = searchResult?.assets?.count else {
            
            return 0
        }
        
        return searchResultCount
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let asset = searchResult?.assets?[indexPath.row] else {
            
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PropertyDetailViewCell", for: indexPath) as! PropertyDetailViewCell
        
        cell.title.text = asset.status
        cell.details.text = asset.description
        
        if let thumbnail = asset.thumbnail, let url = URL(string: thumbnail) {
            
            cell.thumbnail.kf.indicatorType = .activity
            cell.thumbnail.kf.setImage(with: url)
            
        }
        
        return cell
    }

}