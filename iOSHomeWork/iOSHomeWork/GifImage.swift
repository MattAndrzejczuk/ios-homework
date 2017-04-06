//
//  GifImage.swift
//  iOSHomeWork
//
//  Created by Matt Andrzejczuk on 3/31/17.
//  Copyright © 2017 Harry Tormey. All rights reserved.
//

import UIKit


struct RGGifImageSetModel {
    let images: [Int:RGGifImageModel]
    
    init() {
        images = [:]
    }
    
    init(addImage: RGGifImageModel, toSet: RGGifImageSetModel) {
        var oldSetImages = toSet.images
        oldSetImages[addImage.index] = addImage
        images = oldSetImages
    }
    
    init(updateImage: RGGifImageModel, withId: String, inSet: RGGifImageSetModel) {
        var oldSetImages = inSet.images
        oldSetImages[updateImage.index] = updateImage
        images = oldSetImages
    }
}


struct RGGifImageModel {
    let id : String
    let imgType : String
    let gifUrl : URL
    let data : Data?
    let progress : Double
    let index : Int
    let rgJson : RGDataObject
}
