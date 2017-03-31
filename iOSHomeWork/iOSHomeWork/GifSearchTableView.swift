//
//  GifSearchTableView.swift
//  iOSHomeWork
//
//  Created by Matt Andrzejczuk on 3/29/17.
//  Copyright © 2017 Harry Tormey. All rights reserved.
//

import Foundation
import UIKit
import Alamofire


class LightTableViewController: UIView, UITableViewDelegate, UITableViewDataSource {
    
    var mainTableView: UITableView! = UITableView()
    var cellsArray: [String] = ["One", "Two", "Three"]
    
    var delegate : MainViewController?
    
    var api: GiphyApi! = GiphyApi()
    var imageSetModel = GifImageSetModel()
    
    var rememberedImageData : [Int:Data?] = [:]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        mainTableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "gif_cell")
        self.translatesAutoresizingMaskIntoConstraints = false
        mainTableView.translatesAutoresizingMaskIntoConstraints = false
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.backgroundColor = .white
        mainTableView.frame = self.frame
        
        self.addSubview(mainTableView)
        self.backgroundColor = DESIGN_PRIMARY_COLOR
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var imgIndexes : [Int:String] = [:];
        var i = 0;
        for img in imageSetModel.images {
            imgIndexes[i] = img.key
            i += 1
        }
        
        let cell : CustomTableViewCell = tableView.dequeueReusableCell(withIdentifier: "gif_cell") as! CustomTableViewCell
        let index = imgIndexes[indexPath.row]
        
        if rememberedImageData[indexPath.row] != nil {
            let img = UIImage.gif(data: rememberedImageData[indexPath.row] as! Data)!
            (cell).imgView.image = img
            cell.lblId.text = imageSetModel.images[index!]!.gifUrl.absoluteString
            return cell
        }
        else if imageSetModel.images[index!]!.data != nil {
            let img = UIImage.gif(data: imageSetModel.images[index!]!.data!)
            (cell).imgView.image = img
            cell.lblId.text = imageSetModel.images[index!]!.gifUrl.absoluteString
            mainTableView.beginUpdates()
            mainTableView.reloadRows(at: [indexPath], with: .fade)
            mainTableView.endUpdates()
            return cell
        }
        else {
            cell.lblId.text = imageSetModel.images[index!]!.gifUrl.absoluteString
            return cell
        }
        

    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var imgIndexes : [Int:String] = [:];
        var i = 0;
        for img in imageSetModel.images {
            imgIndexes[i] = img.key
            i += 1
        }
        
        let cellModelIndex = imgIndexes[indexPath.row]
        let cellModel = imageSetModel.images[cellModelIndex!]!
        
        
        Alamofire.request(cellModel.gifUrl,
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
                    self.imageDidFinishDownloading(imgData: data,
                                                   withId: cellModel.id,
                                                   url: cellModel.gifUrl,
                                                   index_path: indexPath)
                } else {
                    print("FAILED TO GET DOWNLOADED IMAGE DATA!!!")
                }
        }
    }
    
    
    func imageDidFinishDownloading(imgData: Data, withId: String, url: URL, index_path: IndexPath) {
        let imageModel = GifImageModel(id: withId, imgType: "gif", gifUrl: url, data: imgData)
        
        if imageSetModel.images[withId] == nil {
            print("this image set is nil.")
        } else {
            print("this image set has a value.")
            let oldSetModel = imageSetModel
            imageSetModel = GifImageSetModel(addImage: imageModel,
                                             toSet: oldSetModel)
            
            rememberedImageData[index_path.row] = imgData
            
            mainTableView.beginUpdates()
            mainTableView.reloadRows(at: [index_path], with: .left)
            mainTableView.endUpdates()
            
            /*
            let fileManager = FileManager.default
            let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appending("\(withId)")
            print(paths)
            let imageData =
            fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
            */
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageSetModel.images.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300;
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300;
    }
}



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
}
