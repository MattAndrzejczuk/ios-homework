//
//  RGBaseImage.swift
//  iOSHomeWork
//
//  Created by Matt Andrzejczuk on 4/2/17.
//  Copyright © 2017 Harry Tormey. All rights reserved.
//

import Foundation
import EVReflection


class RGBaseImage : EVObject {
    
    var variationName: String
    
    var url: String
    var width: String
    var height: String
    var size : String
    var frames : String
    var mp4 : String
    var mp4_size : String
    var webp : String
    var webp_size : String
    
    required init() {
        size = "nan"
        frames = "nan"
        mp4 = "nan"
        mp4_size = "nan"
        webp = "nan"
        webp_size = "nan"
        url = "nan"
        width = "nan"
        height = "nan"
        
        variationName = "nan"
    }
    
    init(variation: GiphyVariationREST) {
        size = "nan"
        frames = "nan"
        mp4 = "nan"
        mp4_size = "nan"
        webp = "nan"
        webp_size = "nan"
        url = "nan"
        width = "nan"
        height = "nan"
        variationName = variation.getKeyName
    }
    
    func deserializeRGBaseImage(strJson: String) -> RGBaseImage {
        let convertedToDictionary : NSDictionary = EVReflection.dictionaryFromJson(strJson)
        let convertedToInstance : RGBaseImage!
        convertedToInstance = EVReflection.fromDictionary(convertedToDictionary,
                                                          anyobjectTypeString: "RGBaseImage") as! RGBaseImage
        return convertedToInstance
    }
}
