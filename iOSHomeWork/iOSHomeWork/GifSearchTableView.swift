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
import SwiftyJSON



class LightTableViewController: UIView, UITableViewDelegate, UITableViewDataSource {
    
    var mainTableView: UITableView! = UITableView()
    var cellsArray: [String] = ["One", "Two", "Three"]
    
    var delegate : MainViewController?
    
    var api: GiphyApi! = GiphyApi()
    var imageSetModel = GifImageSetModel()
    
    var rememberedImageData : [Int:Data?] = [:]
    var downloadProgress : [Int:Double] = [:]
    
    
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
        
        // Table View Content:
        NSLayoutConstraint(item: self.mainTableView,
                                      attribute: .top,
                                      relatedBy: .equal,
                                      toItem: self,
                                      attribute: .top,
                                      multiplier: 1.0,
                                      constant: 15).isActive = true;
        NSLayoutConstraint(item: self.mainTableView,
                                      attribute: .leading,
                                      relatedBy: .equal,
                                      toItem: self,
                                      attribute: .leading,
                                      multiplier: 1.0,
                                      constant: 20).isActive = true;
        NSLayoutConstraint(item: self.mainTableView,
                                      attribute: .trailing,
                                      relatedBy: .equal,
                                      toItem: self,
                                      attribute: .trailing,
                                      multiplier: 1.0,
                                      constant: -20).isActive = true;
        NSLayoutConstraint(item: self.mainTableView,
                                      attribute: .bottom,
                                      relatedBy: .equal,
                                      toItem: self,
                                      attribute: .bottom,
                                      multiplier: 1.0,
                                      constant: -5).isActive = true;
        
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
            let img = UIImage.gif(data: rememberedImageData[indexPath.row]!!)!
            (cell).imgView.image = img
            cell.lblId?.text = "\(imageSetModel.images[index!]!.gifUrl.absoluteString)"
            cell.progressBar.isHidden = true
            return cell
        }
        else if imageSetModel.images[index!]!.data != nil {
            let img = UIImage.gif(data: imageSetModel.images[index!]!.data!)
            (cell).imgView.image = img
            cell.lblId?.text = "\(imageSetModel.images[index!]!.gifUrl.absoluteString)"
            cell.progressBar.isHidden = true
//            mainTableView.beginUpdates()
//            mainTableView.reloadRows(at: [indexPath], with: .fade)
//            mainTableView.endUpdates()
            return cell
        }
        else {
            cell.lblId?.text = "\(imageSetModel.images[index!]!.gifUrl.absoluteString)"
            cell.progressBar.isHidden = false
            return cell
        }
        

    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let _cell = cell as? CustomTableViewCell {
            if downloadProgress[indexPath.row] == nil {
                var imgIndexes : [Int:String] = [:];
                var i = 0;
                for img in imageSetModel.images {
                    imgIndexes[i] = img.key
                    i += 1
                }
                
                let cellModelIndex = imgIndexes[indexPath.row]
                let cellModel = imageSetModel.images[cellModelIndex!]!
                
                
                if cellModel.data == nil {
                    Alamofire.request(cellModel.gifUrl,
                                      method: .get,
                                      parameters: nil,
                                      encoding: JSONEncoding.default)
                        .downloadProgress(queue: DispatchQueue.global(qos: .utility))
                        { progress in

                            
                            
                            if progress.fractionCompleted >= 1 {
                                DispatchQueue.main.async {
                                    _cell.progressBar.setProgress(0.0, animated: false)
                                    _cell.progressBar.isHidden = true
                                    self.downloadProgress[indexPath.row] = progress.fractionCompleted
                                }                            } else {
                                print(progress.fractionCompleted)
                                DispatchQueue.main.async {
                                    _cell.progressBar.setProgress(Float(progress.fractionCompleted), animated: false)
                                    _cell.progressBar.isHidden = false
                                    self.downloadProgress[indexPath.row] = progress.fractionCompleted
                                }
                            }
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
                
                
            }
        }
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
        
        
        Alamofire.request("http://api.giphy.com/v1/gifs/\(cellModel.id)?api_key=dc6zaTOxFJmzC",
                          method: .get,
                          parameters: nil,
                          encoding: JSONEncoding.default)
//            .downloadProgress(queue: DispatchQueue.global(qos: .utility))
//            { progress in
//            }
            .validate { request, response, data in
                return .success
            }
            .responseJSON { response in
                if let data = response.data {
                    let json = JSON(data: data)
                    print(json)
                } else {
                    print("FAILED TO GET DOWNLOADED IMAGE DATA!!!")
                }
        }
    }
    
    
    func imageDidFinishDownloading(imgData: Data, withId: String, url: URL, index_path: IndexPath) {
        let imageModel = GifImageModel(id: withId,
                                       imgType: "gif",
                                       gifUrl: url,
                                       data: imgData,
                                       progress: 1.0)
        
        if imageSetModel.images[withId] == nil {
            print("this image set is nil.")
        } else {
            print("this image set has a value.")
            let oldSetModel = imageSetModel
            imageSetModel = GifImageSetModel(addImage: imageModel,
                                             toSet: oldSetModel)
            
            rememberedImageData[index_path.row] = imgData
            mainTableView.beginUpdates()
            mainTableView.reloadRows(at: [index_path], with: .fade)
            mainTableView.endUpdates()
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



