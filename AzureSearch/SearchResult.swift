//
//  SearchResult.swift
//  AzureSearch
//
//  Created by Mahmut Canga on 04/01/2017.
//  Copyright © 2017 Canga IT Solutions. All rights reserved.
//

import Foundation
import ObjectMapper

class SearchResult: Mappable {
    
    var count: Int?
    var assets: [Asset]?
    var next: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        assets      <- map["value"]
        
        // OData Parsing
        count = map.JSON["@odata.count"] as? Int
        next = map.JSON["@odata.nextLink"] as? String
    }
}

class Asset: Mappable {
    
    var listingId: String?
    var beds: Int?
    var baths: Int?
    var description: String?
    var sqft: Int?
    var status: String?
    var source: String?
    var daysOnMarket: Int?
    var number: String?
    var street: String?
    var unit: String?
    var type: String?
    var city: String?
    var region: String?
    var countryCode: String?
    var postCode: String?
    var thumbnail: String?
    
    var searchText: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        listingId       <- map["listingId"]
        beds            <- map["beds"]
        baths           <- map["baths"]
        description     <- map["description"]
        sqft            <- map["sqft"]
        status          <- map["status"]
        source          <- map["source"]
        daysOnMarket    <- map["daysOnMarket"]
        number          <- map["number"]
        street          <- map["street"]
        unit            <- map["unit"]
        type            <- map["type"]
        city            <- map["sqft"]
        region          <- map["region"]
        countryCode     <- map["countryCode"]
        postCode        <- map["postCode"]
        thumbnail       <- map["thumbnail"]
        searchText = map.JSON["@search.text"] as? String
    }

}
