//
//  RGAPISearch.swift
//  iOSHomeWork
//
//  Created by Matt Andrzejczuk on 4/5/17.
//  Copyright © 2017 Harry Tormey. All rights reserved.
//

import Foundation
import SwiftyJSON





extension MainViewController {

    
    func didPressSearch() {
        txtSearchBox.resignFirstResponder()
        clearTableViewData()
        if let text = txtSearchBox.text {
            currentSearchText = text.replacingOccurrences(of: " ", with: "+")
            api.search(keyword: text, pagination: paginationOffset)
            paginationOffset += 1
        }
    }
    
    
    
    // 2. RECEIVE GET RESPONSE
    func apiDidGetResponse(data: Data) {
        let json = JSON(data: data)
//        if let dta = json.rawString() {
        
            
            if let jdata = json["data"].array {
                let arrayLength = jdata.count
                guard arrayLength > 0 else {
                    return
                }
                for i in 0...(arrayLength - 1) {
                    let thisData = jdata[i].rawString()!
                    
                    let instance = RGDataObject().deserializeRGDataObject(strJson: thisData)
                    var generatedUrl = instance.images.previewGif.url
                    if generatedUrl == "nan" {
                        generatedUrl = instance.images.fixedHeightSmall.url
                        if generatedUrl == "nan" {
                            generatedUrl = instance.images.original.url
                        }
                    }
                    let giphyId = instance.id
                    let giphyType = instance.type
                    
                    let imageStruct = RGGifImageModel(id: giphyId,
                                                      imgType: giphyType,
                                                      gifUrl: URL(string: generatedUrl)!,
                                                      data: nil,
                                                      progress: 0,
                                                      index: rgCollectionView!.imageSetModel.images.count,
                                                      rgJson: instance);
                    rgCollectionView?.imageSetModel = RGGifImageSetModel(addImage: imageStruct, toSet: rgCollectionView!.imageSetModel);
                    
                    if i == (arrayLength - 1) {
                        self.rgCollectionView?.downloadProgress = [:]
                        self.rgCollectionView?.rgCollectionView.reloadData();
                    }
                }
            }
            
            


//        }
        
        
        /*

         */
        
    }
}
