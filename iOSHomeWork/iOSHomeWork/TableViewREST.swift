//
//  TableViewREST.swift
//  iOSHomeWork
//
//  Created by Matt Andrzejczuk on 4/2/17.
//  Copyright © 2017 Harry Tormey. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON




extension LightTableViewController {

    // DOWNLOAD IMAGE FOR PREVIEW ON TABLE VIEW:
    func downloadImageForPreviewCell(_ gifUrl: URL, at: IndexPath, _ model: GifImageModel, _ _cell: RGCellProgress) {
        Alamofire.request(gifUrl,
                          method: .get,
                          parameters: nil,
                          encoding: JSONEncoding.default)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility))
            { progress in
                
                if progress.fractionCompleted >= 1 {
                    DispatchQueue.main.async {
                        _cell.progressBar.setProgress(0.0, animated: false)
                        self.downloadProgress[at.row] = progress.fractionCompleted
                    }                            } else {
                    DispatchQueue.main.async {
                        _cell.progressBar.setProgress(Float(progress.fractionCompleted), animated: false)
                        self.downloadProgress[at.row] = progress.fractionCompleted
                    }
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
                                                   index_path: at, index: model.index)
                } else {
                    print("FAILED TO GET DOWNLOADED IMAGE DATA!!!")
                }
        }
    }
    
    
    func getImageInfoByIdREST(_ id: String) {
        print("\n getting data...")
        
        Alamofire.request("http://api.giphy.com/v1/gifs/\(id)?api_key=dc6zaTOxFJmzC",
                          method: .get,
                          parameters: nil,
                          encoding: JSONEncoding.default)
            .validate { request, response, data in
                return .success
            }
            .responseJSON { response in
                print("got response, processing json... \n")
                if let data = response.data {
                    let json = JSON(data: data)
                    if let dta = json["data"].rawString(.utf8, options: .prettyPrinted) {
                        print("\n\n----------------------------------")
                        let instance = RGDataObject().deserializeRGDataObject(strJson: dta)
                        print("      converted to instance:\n\n\(instance)")
                        self.dialogModalDidFinishLoadingContent(instance)
                    }
                } else {
                    print("REQUEST FAILED!!!")
                }
        }
    }
    
    
    func initMADialog(_ originFrame: CGRect) {
        modalOrigin = originFrame
        
        let blurEffect = UIBlurEffect(style: .extraLight)
        dialogModal = UIVisualEffectView(effect: blurEffect)
        dialogModal?.layer.cornerRadius = 10.0
        dialogModal?.layer.borderWidth = 0.0
        dialogModal?.clipsToBounds = true
        dialogModal?.frame = originFrame
        
        // SECOND FROSTED GLASS LAYER (vibrancy):
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        dialogModalGlass = UIVisualEffectView(effect: vibrancyEffect)
        dialogModalGlass?.layer.cornerRadius = 10.0
        dialogModalGlass?.layer.borderWidth = 0.0
        dialogModalGlass?.clipsToBounds = true
        dialogModalGlass?.frame = originFrame
        
        
        
        dialogModalShadow = UIView(frame: originFrame)
        dialogModalShadow?.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.25)
        dialogModalShadow?.layer.shadowColor = UIColor.black.cgColor
        dialogModalShadow?.layer.shadowOffset = CGSize.zero
        dialogModalShadow?.layer.shadowOpacity = 1
        dialogModalShadow?.layer.shadowRadius = 5
        dialogModalShadow?.layer.cornerRadius = 10.0
        
        
        loadingSpinner = UIActivityIndicatorView(frame:  CGRect(x: 0, y: 0, width: 100, height: 100))
        loadingSpinner.startAnimating()
        if let dm = dialogModal {
            loadingSpinner.center = dm.center
        }
        
        
        print("loadingSpinner \(loadingSpinner) \n\n has been appended")
        addSubview(dialogModalShadow!)
        addSubview(dialogModal!)
        if let dmg = dialogModalGlass {
            dialogModal?.contentView.addSubview(dmg)
        }
        
        dialogModalGlass?.contentView.addSubview(loadingSpinner)
        dialogModalShadow?.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        dialogModal?.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.3, animations: {
            self.dialogModal?.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.dialogModalShadow?.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.dialogModal?.center.x = self.frame.size.width / 2
            self.dialogModal?.center.y = self.frame.size.height / 2 - 50
            self.dialogModalShadow?.center.x = self.frame.size.width / 2
            self.dialogModalShadow?.center.y = self.frame.size.height / 2 - 50
        })
    }
    
    func dialogModalDidFinishLoadingContent(_ instance: RGDataObject) {
        UIView.animate(withDuration: 0.4, animations: {
            self.loadingSpinner.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }, completion: { _ in
            self.loadingSpinner.removeFromSuperview()
            
            let lblTitle = UILabel(frame: CGRect(x: 25, y: 25, width: 100, height: 50))
            lblTitle.textColor = .black
            lblTitle.text = instance.slug
            self.dialogModalGlass?.contentView.addSubview(lblTitle)
            lblTitle.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            
            UIView.animate(withDuration: 0.1, animations: {
                lblTitle.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        });
    }
    
    func closeDialogModal() {
        UIView.animate(withDuration: 0.4, animations: {
            if let mdl = self.modalOrigin {
                self.dialogModal?.frame.origin = mdl.origin
                self.dialogModalShadow?.frame.origin = mdl.origin
                self.dialogModalShadow?.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                self.dialogModal?.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                return
            }
        }, completion: { _ in
            self.dialogModal?.removeFromSuperview()
            self.dialogModalShadow?.removeFromSuperview()
            self.loadingSpinner.removeFromSuperview()
        });
    }
    
    
    func injectDataIntoModal(instance: RGDataObject) {
        let txtView = UITextView()
        txtView.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    
    func testModal() {
        
        let blurEffect = UIBlurEffect(style: .extraLight)
        dialogModal = UIVisualEffectView(effect: blurEffect)
        dialogModal?.layer.cornerRadius = 10.0
        dialogModal?.layer.borderWidth = 0.0
        dialogModal?.clipsToBounds = true
        dialogModal?.frame = MODAL_FRAME
        
        
        // SECOND FROSTED GLASS LAYER (vibrancy):
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        dialogModalGlass = UIVisualEffectView(effect: vibrancyEffect)
        dialogModalGlass?.layer.cornerRadius = 10.0
        dialogModalGlass?.layer.borderWidth = 0.0
        dialogModalGlass?.clipsToBounds = true
        dialogModalGlass?.frame = MODAL_FRAME
        
        
        dialogModalShadow = UIView(frame: MODAL_FRAME)
        dialogModalShadow?.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.15)
        dialogModalShadow?.layer.shadowColor = UIColor.black.cgColor
        dialogModalShadow?.layer.shadowOffset = CGSize.zero
        dialogModalShadow?.layer.shadowOpacity = 0.85
        dialogModalShadow?.layer.shadowRadius = 15
        dialogModalShadow?.layer.cornerRadius = 10.0
        
        
        addSubview(dialogModalShadow!)
        addSubview(dialogModal!)
        dialogModal?.contentView.addSubview(dialogModalGlass!)
        
        
        dialogModalShadow?.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        dialogModal?.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        UIView.animate(withDuration: 1.0, animations: {
            self.dialogModal?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.dialogModalShadow?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })

        
//        let maview = MAView(frame: MODAL_FRAME)
//        maview.backgroundColor = .white
//        maview.layer.cornerRadius = 10.0
//        maview.layer.borderColor = UIColor.gray.cgColor
//        maview.layer.borderWidth = 0.5
//        maview.clipsToBounds = true
        
        let shadowView = UIView(frame: MODAL_FRAME)
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize.zero
        shadowView.layer.shadowOpacity = 0.5
        shadowView.layer.shadowRadius = 5
        
        
//        shadowView.addSubview(maview)
        self.addSubview(shadowView)
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

class MAView : UIView {
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        self.backgroundColor = .clear
        let c = UIGraphicsGetCurrentContext()
        //        c!.addRect(CGRect(x:10, y:10, width:80, height:80))
        //        c!.setStrokeColor(UIColor.red.cgColor)
        //        c!.strokePath()
        var w = rect.width, _ = rect.height, r = rect
        r.size.width = 300
        r.size.height = 300
        r.origin = CGPoint(x: 10, y: 10)
        c!.strokeEllipse(in: r)
        c!.setStrokeColor(UIColor.red.cgColor)
        c!.strokePath()
    }
}

