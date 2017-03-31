//
//  GifImage.swift
//  iOSHomeWork
//
//  Created by Matt Andrzejczuk on 3/31/17.
//  Copyright © 2017 Harry Tormey. All rights reserved.
//

import Foundation



struct GifImageSetModel {
    let images: [String:GifImageModel]
    
    init() {
        images = [:]
    }
    
    init(addImage: GifImageModel, toSet: GifImageSetModel) {
        var oldSetImages = toSet.images
        oldSetImages[addImage.id] = addImage
        images = oldSetImages
    }
    
    init(updateImage: GifImageModel, withId: String, inSet: GifImageSetModel) {
        var oldSetImages = inSet.images
        oldSetImages[withId] = updateImage
        images = oldSetImages
    }
}


struct GifImageModel {
    let id : String
    let imgType : String
    let gifUrl : URL
    let data : Data?
    let progress : Double
}
