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


let MODAL_FRAME = CGRect(x: 25, y: 50, width: 200, height: 150)

class LightTableViewController: UIView, UITableViewDelegate, UITableViewDataSource {
    
    var mainTableView: UITableView! = UITableView()
    var delegate : MainViewController?
    
    var api: GiphyApi! = GiphyApi()
    var imageSetModel = GifImageSetModel()
    
    var rememberedImageInstance : [Int:UIImage] = [:]
    var rememberedImageData : [Int:Data?] = [:]
    var downloadProgress : [Int:Double] = [:]
    
    var dialogModal: UIVisualEffectView?
    var dialogModalGlass: UIVisualEffectView?
    var dialogModalShadow : UIView?
    var loadingSpinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    

    var modalOrigin: CGRect?
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("hey!!!")
        closeDialogModal()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        mainTableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "gif_cell")
        translatesAutoresizingMaskIntoConstraints = false
        mainTableView.translatesAutoresizingMaskIntoConstraints = false

        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.backgroundColor = .white
        mainTableView.frame = self.frame
        
        loadingSpinner.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        loadingSpinner.startAnimating()
        
        mainTableView.backgroundColor = .clear
        self.addSubview(mainTableView)
        self.backgroundColor = .clear
        
        
        // Table View Content:
        NSLayoutConstraint(item: self.mainTableView,
                           attribute: .width,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .width,
                           multiplier: 1.0,
                           constant: -40).isActive = true;
        
        NSLayoutConstraint(item: self.mainTableView,
                           attribute: .height,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .height,
                           multiplier: 1.0,
                           constant: -20).isActive = true;
        
        
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
        

        if let dialog = dialogModal {
            dialog.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint(item: dialog,
                               attribute: .width,
                               relatedBy: .equal,
                               toItem: nil,
                               attribute: .notAnAttribute,
                               multiplier: 1,
                               constant: SCREEN.width * 0.618034).isActive = true;
            NSLayoutConstraint(item: dialog,
                               attribute: .height,
                               relatedBy: .equal,
                               toItem: nil,
                               attribute: .notAnAttribute,
                               multiplier: 1,
                               constant: SCREEN.height * 0.381966).isActive = true;
            NSLayoutConstraint(item: dialog,
                               attribute: .centerX,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .centerX,
                               multiplier: 1,
                               constant: 0).isActive = true;
            NSLayoutConstraint(item: dialog,
                               attribute: .centerY,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .centerY,
                               multiplier: 1,
                               constant: 0).isActive = true;
        }
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var imgIndexes : [Int:String] = [:];
        var i = 0;
        for img in imageSetModel.images {
            imgIndexes[i] = img.key;
            i += 1;
        }
        
        let cell : CustomTableViewCell = tableView.dequeueReusableCell(withIdentifier: "gif_cell") as! CustomTableViewCell;
        let index = imgIndexes[indexPath.row];
        cell.frame.size.width = mainTableView.frame.size.width

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
                    downloadImageForPreviewCell(cellModel.gifUrl, at: indexPath, cellModel, _cell)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {

    }
    
    var selectedImage : UIImage!
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var imgIndexes : [Int:String] = [:];
        var i = 0;
        for img in imageSetModel.images {
            imgIndexes[i] = img.key
            i += 1
        }
        
        let cellModelIndex = imgIndexes[indexPath.row]
        let cellModel = imageSetModel.images[cellModelIndex!]!
        
        if let cell = tableView.cellForRow(at: indexPath) {
            self.initMADialog(cell.frame)
        }
        
        if rememberedImageData[indexPath.row] != nil {
            print(cellModelIndex!)
            getImageInfoByIdREST(cellModel.id)
        } else {
            return
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
            
            rememberedImageInstance[index_path.row] = UIImage.gif(data: imgData)!
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
        return 200;
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200;
    }
}



