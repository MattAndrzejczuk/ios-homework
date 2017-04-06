//
//  GiphyApi.swift
//  iOSHomeWork
//
//  Created by Matt Andrzejczuk on 3/29/17.
//  Copyright © 2017 Harry Tormey. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire


// search?q=funny+cat




class GiphyApi {
    var delegate: MainViewController!
    
    func search(keyword: String, pagination: Int) {
        let url: String = "\(GiphySearchGenerator(withKeyword: keyword).absoluteUrl)&offset=\(pagination)"
        searchGiphyApiWithAlamo(url: url)
    }
    
    func searchGiphyApiWithAlamo(url: String) {
        Alamofire.request(url,
                          method: .get,
                          parameters: nil,
                          encoding: JSONEncoding.default)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility))
            { progress in
            }
            .validate { request, response, data in
                return .success
            }
            .responseJSON { response in
                if let data = response.data {
                    self.delegate.apiDidGetResponse(data: data)
                } else {
                    print("FAILED TO SEARCH API!!!")
                }
        }
    }
}

struct GiphySearchGenerator {
    let stringQuery : String
    let absoluteUrl : String
    
    init(withKeyword: String) {
        stringQuery = "search?q=\(withKeyword)"
        absoluteUrl = "\(API_BASE_URL)\(stringQuery)\(API_KEY)"
    }
    
    init(withKeywords: [String]) {
        var str = "search?q="
        
        for keyword in withKeywords {
            str.append("\(keyword)+")
        }
        stringQuery = str
        absoluteUrl = "\(API_BASE_URL)\(stringQuery)\(API_KEY)"
    }
}


