//
// Created by Matt Andrzejczuk on 4/4/17.
// Copyright (c) 2017 Harry Tormey. All rights reserved.
//


import UIKit
import Alamofire
import SwiftyJSON

// UIFont(name: "AvenirNext-UltraLight", size: 17)

class RGCollectionViewController: UIView, UICollectionViewDataSource, UICollectionViewDelegate {

    var rgCollectionView: UICollectionView!
    var delegate: MainViewController?

    var imageSetModel = RGGifImageSetModel()

    var rememberedImageInstance: [Int: UIImage] = [:]
    var rememberedImageData: [Int: Data?] = [:]
    var downloadProgress: [Int: Double] = [:]

    var dialogModal: UIVisualEffectView?
    var dialogModalGlass: UIVisualEffectView?
    var dialogModalShadow: UIView?
    var loadingSpinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)

    var modalOrigin: CGRect?
    var viewLayer2: UIView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        initConfiguration()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageSetModel.images.count
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if rememberedImageData[indexPath.row] != nil {
            let cell: RGCellImage = collectionView.dequeueReusableCell(withReuseIdentifier: "image", for: indexPath) as! RGCellImage;
            let img = UIImage.gif(data: rememberedImageData[indexPath.row]!!)!
            (cell).imageView.image = img
            return cell
        } else if imageSetModel.images[indexPath.row]!.data != nil {
            let cell: RGCellImage = collectionView.dequeueReusableCell(withReuseIdentifier: "image", for: indexPath) as! RGCellImage;
            let img = UIImage.gif(data: rememberedImageData[indexPath.row]!!)!
            (cell).imageView.image = img
            return cell
        } else {
            let cell: RGCellProgress = collectionView.dequeueReusableCell(withReuseIdentifier: "progress", for: indexPath) as! RGCellProgress;
            cell.progressBar.progress = Float(imageSetModel.images[indexPath.row]!.progress)
            return cell
        }
    }


    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 400, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        return false
    }
    

    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let _cell = cell as? RGCellProgress {
            if downloadProgress[indexPath.row] == nil {

                let cellModel = imageSetModel.images[indexPath.row]!

                if cellModel.data == nil {
                    downloadImageForPreviewCell(cellModel.gifUrl, at: indexPath, cellModel, _cell)
                } else {
                    return
                }
            } else {
                return
            }
        } else {
            return
        }
    }


//    func collectionView(_ collectionView: UICollectionView)

    func downloadImageForPreviewCell(_ gifUrl: URL, at: IndexPath, _ model: RGGifImageModel, _ _cell: RGCellProgress) {
        Alamofire.request(gifUrl,
                        method: .get,
                        parameters: nil,
                        encoding: JSONEncoding.default)
                .downloadProgress(queue: DispatchQueue.global(qos: .utility))
                { progress in

                    if progress.fractionCompleted >= 1 {
                        DispatchQueue.main.async {
                            _cell.progressBar.setProgress(1.0, animated: true)
//                            _cell.progressBar.isHidden = true
                            self.downloadProgress[at.row] = 1.0
                        }
                        return
                    } else {
                        DispatchQueue.main.async {
                            _cell.progressBar.setProgress(Float(progress.fractionCompleted), animated: true)
//                            _cell.progressBar.isHidden = false
                            self.downloadProgress[at.row] = progress.fractionCompleted
                        }
                        return
                    }
                }
                .validate { request, response, data in
                    return .success
                }
                .responseJSON { response in
                    if let data = response.data {
                        self.imageDidFinishDownloading(imgData: data,
                                withId: model.id,
                                url: model.gifUrl,
                                index_path: at,
                                index: model.index,
                                instance: self.imageSetModel.images[at.row]!.rgJson)
                    } else {
                        print("FAILED TO GET DOWNLOADED IMAGE DATA!!!")
                    }
                }
    }

    func imageDidFinishDownloading(imgData: Data, withId: String, url: URL, index_path: IndexPath, index: Int, instance: RGDataObject) {
        let imageModel = RGGifImageModel(id: withId,
                imgType: "gif",
                gifUrl: url,
                data: imgData,
                progress: 1.0,
                index: index,
                rgJson: instance)

        if imageSetModel.images[index] == nil {
            print("this image set is nil.")
        } else {
            let oldSetModel = imageSetModel
            imageSetModel = RGGifImageSetModel(addImage: imageModel,
                    toSet: oldSetModel)

            rememberedImageInstance[index_path.row] = UIImage.gif(data: imgData)!
            rememberedImageData[index_path.row] = imgData
            rgCollectionView.reloadItems(at: [index_path])
        }
    }
}
