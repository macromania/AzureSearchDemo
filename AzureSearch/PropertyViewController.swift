//
//  PropertyViewController.swift
//  AzureSearch
//
//  Created by Mahmut Canga on 05/01/2017.
//  Copyright © 2017 Canga IT Solutions. All rights reserved.
//

import UIKit
import Kingfisher

class PropertyViewController: UIViewController {
    
    var tableView: UITableView? {
        
        didSet {
            
            tableView?.dataSource = self
            tableView?.delegate = self
            tableView?.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            tableView?.rowHeight = UITableViewAutomaticDimension
            tableView?.estimatedRowHeight = 80.0
            tableView?.register(UINib(nibName: "PropertyDetailViewCell", bundle: nil), forCellReuseIdentifier: "PropertyDetailViewCell")
        }
    }
    
    var listingId: String?
    
    var asset: Asset?
    
    var tableViewItemCount: Int = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        
        view.addSubview(tableView!)
        view.backgroundColor = UIColor.white
        
        print("Loading listing \(listingId)")
        
        guard let listingIdValidated = listingId else {
            
            print("No prop details for listingId \(listingId)")
            return
        }
        
        Network().fetch(listingDetailsFor: listingIdValidated) { (asset: Asset?) in
            
            self.asset = asset
            self.tableViewItemCount = 7
            self.tableView?.reloadData()
        }
    }
}

extension PropertyViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension PropertyViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tableViewItemCount
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        (cell as? PropertyDetailViewCell)?.thumbnail.kf.cancelDownloadTask()
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PropertyDetailViewCell", for: indexPath) as! PropertyDetailViewCell
        
        switch indexPath.row {
            
        case 0:
            cell.title.text = "Description"
            cell.details.text = asset?.description
            
            if let thumbnail = asset?.thumbnail, let url = URL(string: thumbnail) {
                
                cell.thumbnail.kf.indicatorType = .activity
                cell.thumbnail.kf.setImage(with: url)
                
            }
            
        case 1:
            cell.title.text = "Type"
            cell.details.text = asset?.type
            
        case 2:
            cell.title.text = "Beds"
            
            if let beds = asset?.beds {
                
                cell.details.text = "\(beds)"
            }
            
        case 3:
            cell.title.text = "Baths"
            
            if let baths = asset?.baths {
                
                cell.details.text = "\(baths)"
            }

            
        case 4:
            cell.title.text = "Sqft"
            
            if let sqft = asset?.sqft {
                
                cell.details.text = "\(sqft)"
            }
            
        case 5:
            cell.title.text = "Status"
            cell.details.text = asset?.status
            
        case 6:
            cell.title.text = "Address"
            
            var address = ""
            
            if let unit = asset?.unit {
                
                address += "\(unit)\n"
            }
            
            if let street = asset?.street {
                
                address += "\(street)\n"
            }
            
            if let city = asset?.city {
                
                address += "\(city)\n"
            }
            
            if let postCode = asset?.postCode {
                
                address += "\(postCode)\n"
            }


            
            cell.details.text = address

            
        default:
            
            cell.title.text = "\(indexPath.row)"
            

        }
        
        return cell
    }
}




















