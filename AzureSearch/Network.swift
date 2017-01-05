//
//  Network.swift
//  AzureSearch
//
//  Created by Mahmut Canga on 04/01/2017.
//  Copyright © 2017 Canga IT Solutions. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

struct Search {
    
    static let domain: String = "https://cangasearchdemo.search.windows.net/indexes/realestate-us-sample/docs"
    static let apiVersion: String = "api-version=2015-02-28"
    
    static let totalCount: String = {
        
        return domain + "?" + apiVersion + "&$count=true"
    }()
    
    static let suggestions: String = {
        
        return domain + "/suggest/?" + apiVersion + "&suggesterName=sg&fuzzy=true&search="
    }()
    
    static let keyword: String = {
        
        return domain + "?" + apiVersion + "&$count=true&fuzzy=true&search="
    }()

    
}

class Network {
    
    let headers: HTTPHeaders = [
        "Accept": "application/json;odata.metadata=none",
        "api-key": "F81DA8C24F4C5345209EC2094093C32E"
    ]
    
    func fetchTotalCount(result: @escaping (_ searchResult: SearchResult?) -> Void) {
        
        
        Alamofire.request(Search.totalCount, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
        
                print(response.request)
                
                switch response.result {
                    
                case .success(let value):
                    let searchResult = Mapper<SearchResult>().map(JSONObject: value)
                    result(searchResult)
                    print("Search result for total count: \(searchResult?.count)")
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    
                }
        }
    }
    
    func fetch(suggestionsFor keyword: String, result: @escaping (_ searchResult: SearchResult?) -> Void) {
        
        guard let keywordEncoded = keyword.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            
            result(nil)
            return
        }
        
        Alamofire.request(Search.suggestions + keywordEncoded, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                
                print(response.request)
                
                switch response.result {
                    
                case .success(let value):
                    let searchResult = Mapper<SearchResult>().map(JSONObject: value)
                    result(searchResult)
                    print("Search result for suggestions: \(searchResult?.assets?.count)")
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    
                }
        }
    }
    
    func fetch(listingDetailsFor listingId: String, result: @escaping (_ asset: Asset?) -> Void) {
        
        Alamofire.request(Search.domain + "/" + listingId + "?" + Search.apiVersion, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                
                print(response.request)
                
                switch response.result {
                    
                case .success(let value):
                    let asset = Mapper<Asset>().map(JSONObject: value)
                    result(asset)
                    print("Search result for suggestions: \(asset?.description)")
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    
                }
        }
    }
    
    func fetch(resultsFor keyword: String, result: @escaping (_ searchResult: SearchResult?) -> Void) {
        
        guard let keywordEncoded = keyword.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            
            result(nil)
            return
        }
        
        Alamofire.request(Search.keyword + keywordEncoded, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                
                print(response.request)
                
                switch response.result {
                    
                case .success(let value):
                    let searchResult = Mapper<SearchResult>().map(JSONObject: value)
                    result(searchResult)
                    print("Search result for suggestions: \(searchResult?.assets?.count)")
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    
                }
        }
    }
}
















