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
    
    func search(keyword: String) {
        let url: String = GiphySearchGenerator(withKeyword: keyword).absoluteUrl
        searchGiphyApiWithAlamo(url: url)
    }
    
    func searchGiphyApiWithAlamo(url: String) {
        Alamofire.request(url,
                          method: .get,
                          parameters: nil,
                          encoding: JSONEncoding.default)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility))
            { progress in
                print("Progress: \(progress.fractionCompleted)")
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
    
    func downloadImageWithAlamo(url: String) {
        Alamofire.request(url,
                          method: .get,
                          parameters: nil,
                          encoding: JSONEncoding.default)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility))
            { progress in
                print("Progress: \(progress.fractionCompleted)")
            }
            .validate { request, response, data in
                return .success
            }
            .responseJSON { response in
                if let data = response.data {
                    self.didGetImageData(data: data)
                } else {
                    print("FAILED TO GET DOWNLOADED IMAGE DATA!!!")
                }
        }
    }
    
    func didGetImageData(data: Data) {
        let imgView = UIImageView(frame: CGRect(x: 0,
                                                y: 0,
                                                width: 200,
                                                height: 200))
        let img = UIImage.gif(data: data)
        imgView.image = img
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


