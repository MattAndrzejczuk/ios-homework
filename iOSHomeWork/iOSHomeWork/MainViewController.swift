//
//  MainViewController.swift
//  iOSHomeWork
//
//  Created by Matt Andrzejczuk on 3/29/17.
//  Copyright © 2017 Harry Tormey. All rights reserved.
//

import UIKit
import SwiftGifOrigin
import SwiftyJSON
import Alamofire


protocol GiphyDelegate {
    func apiDidGetResponse(data: Data);
}

class MainViewController: UIViewController, GiphyDelegate, UITextFieldDelegate, UIDocumentInteractionControllerDelegate {

    var headerView: UIView?
    var dataView: UIView?
//    var rgCollectionViewShadow : UIView?
    var footerView: UIView?

    let documentController: UIDocumentInteractionController = UIDocumentInteractionController(
            url: URL(fileURLWithPath: (NSTemporaryDirectory() as NSString).appendingPathComponent("instagram.igo"))
    )

    var api: GiphyApi! = GiphyApi()

    let buttonReloadConstraints = UIButton(frame: CGRect(x: 110, y: 400, width: 185, height: 180))
    var rgCollectionView: RGCollectionViewController! = RGCollectionViewController(frame: CGRect(x: 50, y: 50, width: 100, height: 100))

    let txtSearchBox: UITextField = UITextField(frame: CGRect(x: 0, y: 0, width: 250, height: 80))
    let buttonSearch = UIButton(frame: CGRect(x: 75, y: 200, width: 150, height: 50))
//    let buttonClearResults = UIButton(frame: CGRect(x: 0, y: 280, width: 100, height: 80))
    let btnShowMore = UIButton(frame: CGRect(x: 0, y: 280, width: 100, height: 80))

    var paginationOffset = 0
    var currentSearchText = ""
    
    

    func getRandomColorFromPalette() -> UIColor {
        let palettes = GMPalette.all()
        let colors = palettes[Int(arc4random_uniform(UInt32(palettes.count)))]
        return colors[Int(arc4random_uniform(UInt32(colors.count)))]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        runDefaultConfiguration()
    }




    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text {
            if text.characters.count > 0 {
                textField.resignFirstResponder()
                clearTableViewData()
                didPressSearch()
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }


    func clearTableViewData() {
        paginationOffset = 0
        self.rgCollectionView!.rememberedImageData = [:]
        self.rgCollectionView!.rememberedImageInstance = [:]
        self.rgCollectionView!.downloadProgress = [:]
        rgCollectionView!.imageSetModel = RGGifImageSetModel()
        self.rgCollectionView!.rgCollectionView.reloadData();
    }

    




    func shareToInstagram(image: UIImage) {
        //        if (UIApplication.shared.canOpenURL(instagramURL)) {
        let imageData = UIImageJPEGRepresentation(image, 100)

        let captionString = "caption"

        self.documentController.uti = "com.instagram.exlusivegram"

        self.documentController.annotation = NSDictionary(object: captionString, forKey: "InstagramCaption" as NSCopying)
        //            self.documentController.presentOpenInMenuFromRect(self.frame, inView: self, animated: true)
        self.documentController.presentOpenInMenu(from: (self.view.frame), in: self.view, animated: true)

        do {
            try imageData?.write(to: URL(fileURLWithPath: (NSTemporaryDirectory() as NSString).appendingPathComponent("instagram.igo")))
        } catch _ {
            print("fileURL is bad")
        }


        //        } else {
        //            print(" Instagram isn't installed ")
        //        }
    }



    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            print("Landscape")

        } else {
            print("Portrait")

        }
    }

    override func viewDidLayoutSubviews() {
        print("did layout subviews!")
//        if let liteView = rgCollectionView {
//            if UIDevice.current.orientation == .portrait || UIDevice.current.orientation == .portraitUpsideDown {
//            } else {
//            }
//        }
        super.viewDidLayoutSubviews()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
