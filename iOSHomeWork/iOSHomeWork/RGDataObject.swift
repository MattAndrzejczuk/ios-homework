//
//  RGDataObject.swift
//  iOSHomeWork
//
//  Created by Matt Andrzejczuk on 4/2/17.
//  Copyright © 2017 Harry Tormey. All rights reserved.
//

import Foundation
import EVReflection


class RGDataObject : EVObject {
    
    var id: String
    var type: String
    var slug: String
    var url: String
    var bitly_gif_url: String
    var bitly_url: String
    var embed_url: String
    var username: String
    var source: String
    var rating: String
    var content_url: String
    var source_tld: String
    var source_post_url: String
    var is_indexable: String
    var import_datetime: String
    var trending_datetime: String
    
    var images: RGImageVariants
    
    required init() {
        id = "nan"
        type = "nan"
        slug = "nan"
        url = "nan"
        bitly_gif_url = "nan"
        bitly_url = "nan"
        embed_url = "nan"
        username = "nan"
        source = "nan"
        rating = "nan"
        content_url = "nan"
        source_tld = "nan"
        source_post_url = "nan"
        is_indexable = "nan"
        import_datetime = "nan"
        trending_datetime = "nan"
        images = RGImageVariants()
    }
    
    func deserializeRGDataObject(strJson: String) -> RGDataObject {
        let convertedToDictionary : NSDictionary = EVReflection.dictionaryFromJson(strJson)
        let convertedToInstance : RGDataObject!
        convertedToInstance = EVReflection.fromDictionary(convertedToDictionary, anyobjectTypeString: "RGDataObject") as! RGDataObject
        return convertedToInstance
    }
}
