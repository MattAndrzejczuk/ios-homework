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
    var footerView: UIView?

    let documentController: UIDocumentInteractionController = UIDocumentInteractionController(
            url: URL(fileURLWithPath: (NSTemporaryDirectory() as NSString).appendingPathComponent("instagram.igo"))
    )

    var api: GiphyApi! = GiphyApi()

    let buttonReloadConstraints = UIButton(frame: CGRect(x: 110, y: 400, width: 185, height: 180))
    let ltv: RGCollectionViewController! = RGCollectionViewController(frame: CGRect(x: 50, y: 50, width: 100, height: 100))

    let txtSearchBox: UITextField = UITextField(frame: CGRect(x: 0, y: 0, width: 250, height: 80))
    let buttonSearch = UIButton(frame: CGRect(x: 75, y: 200, width: 150, height: 50))
    let buttonClearResults = UIButton(frame: CGRect(x: 0, y: 280, width: 100, height: 80))
    let btnShowMore = UIButton(frame: CGRect(x: 0, y: 280, width: 100, height: 80))

    var paginationOffset = 0

    func getRandomColorFromPalette() -> UIColor {
        let palettes = GMPalette.all()
        let colors = palettes[Int(arc4random_uniform(UInt32(palettes.count)))]
        return colors[Int(arc4random_uniform(UInt32(colors.count)))]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        view.backgroundColor = UIColor(patternImage: UIImage(named: "01-Stiff-Paper")!)

        view.backgroundColor = UIColor(patternImage: UIImage(named: "bg02")!)

        api.delegate = self
        txtSearchBox.delegate = self
        documentController.delegate = self
        ltv.delegate = self

        let genericFrame = CGRect(x: 0, y: 0, width: 300, height: 50)
        headerView = UILabel(frame: genericFrame)
        dataView = UIView(frame: genericFrame)
        footerView = UIView(frame: genericFrame)
        footerView?.isHidden = true

        autolayoutUsingConstraint()
    }

    func initUI() {
        footerView?.backgroundColor = .gray

        headerView?.translatesAutoresizingMaskIntoConstraints = false
        dataView?.translatesAutoresizingMaskIntoConstraints = false
        footerView?.translatesAutoresizingMaskIntoConstraints = false
        buttonSearch.translatesAutoresizingMaskIntoConstraints = false
        txtSearchBox.translatesAutoresizingMaskIntoConstraints = false
        buttonClearResults.translatesAutoresizingMaskIntoConstraints = false
        btnShowMore.translatesAutoresizingMaskIntoConstraints = false

        if let header = headerView {
            view.addSubview(header)
        }

        if let footer = footerView {
            view.addSubview(footer)
        }

        view.addSubview(ltv)
        view.addSubview(buttonSearch)
        view.addSubview(txtSearchBox)
        view.addSubview(buttonClearResults)
        view.addSubview(btnShowMore)

        buttonSearch.setTitle("Search", for: .normal)
        buttonSearch.addTarget(self,
                action: #selector(MainViewController.didPressSearch),
                for: .touchUpInside)
        buttonSearch.setTitleColor(.blue, for: .normal)


        buttonClearResults.setTitle("Clear Results", for: .normal)
        buttonClearResults.addTarget(self,
                action: #selector(MainViewController.clearTableViewData),
                for: .touchUpInside)
        buttonClearResults.setTitleColor(.blue, for: .normal)


        btnShowMore.setTitle("Load More", for: .normal)
        btnShowMore.addTarget(self,
                action: #selector(MainViewController.loadMoreResults),
                for: .touchUpInside)
        btnShowMore.setTitleColor(.blue, for: .normal)


        txtSearchBox.placeholder = "Search Keywords"
    }

    func didPressSearch() {
        txtSearchBox.resignFirstResponder()
        clearTableViewData()
        if let text = txtSearchBox.text {
            currentSearchText = text
            api.search(keyword: text, pagination: paginationOffset)
            paginationOffset += 1
        }
    }

    func initSearchButton() {
        NSLayoutConstraint(item: buttonSearch,
                attribute: .top,
                relatedBy: .equal,
                toItem: view,
                attribute: .top,
                multiplier: 1.0,
                constant: 20).isActive = true

        NSLayoutConstraint(item: buttonSearch,
                attribute: .trailing,
                relatedBy: .equal,
                toItem: view,
                attribute: .trailing,
                multiplier: 1.0,
                constant: -40).isActive = true

        NSLayoutConstraint(item: buttonSearch,
                attribute: .centerY,
                relatedBy: .equal,
                toItem: headerView,
                attribute: .centerY,
                multiplier: 1.0,
                constant: 0).isActive = true


        NSLayoutConstraint(item: txtSearchBox,
                attribute: .top,
                relatedBy: .equal,
                toItem: view,
                attribute: .top,
                multiplier: 1.0,
                constant: 30).isActive = true

        NSLayoutConstraint(item: txtSearchBox,
                attribute: .leading,
                relatedBy: .equal,
                toItem: view,
                attribute: .leading,
                multiplier: 1.0,
                constant: 30).isActive = true

        NSLayoutConstraint(item: txtSearchBox,
                attribute: .trailing,
                relatedBy: .equal,
                toItem: buttonSearch,
                attribute: .leading,
                multiplier: 1.0,
                constant: 0).isActive = true

        NSLayoutConstraint(item: txtSearchBox,
                attribute: .centerY,
                relatedBy: .equal,
                toItem: headerView,
                attribute: .centerY,
                multiplier: 1.0,
                constant: 0).isActive = true

        //
        NSLayoutConstraint(item: buttonClearResults,
                attribute: .top,
                relatedBy: .equal,
                toItem: footerView,
                attribute: .top,
                multiplier: 1.0,
                constant: 0).isActive = true

        NSLayoutConstraint(item: buttonClearResults,
                attribute: .trailing,
                relatedBy: .equal,
                toItem: footerView,
                attribute: .trailing,
                multiplier: 1.0,
                constant: -40).isActive = true

        NSLayoutConstraint(item: buttonClearResults,
                attribute: .centerY,
                relatedBy: .equal,
                toItem: footerView,
                attribute: .centerY,
                multiplier: 1.0,
                constant: 0).isActive = true

        //
//        NSLayoutConstraint(item: btnShowMore,
//                           attribute: .top,
//                           relatedBy: .equal,
//                           toItem: footerView,
//                           attribute: .top,
//                           multiplier: 1.0,
//                           constant: -40).isActive = true
        NSLayoutConstraint(item: btnShowMore,
                attribute: .leading,
                relatedBy: .equal,
                toItem: footerView,
                attribute: .leading,
                multiplier: 1.0,
                constant: 40).isActive = true
        NSLayoutConstraint(item: btnShowMore,
                attribute: .centerY,
                relatedBy: .equal,
                toItem: footerView,
                attribute: .centerY,
                multiplier: 1.0,
                constant: 0).isActive = true
    }


    func autolayoutUsingConstraint() {
        initUI()

        //HeaderView
        //Header = 20 from left edge of screen
        let cn1 = NSLayoutConstraint(item: headerView,
                attribute: .leading,
                relatedBy: .equal,
                toItem: view,
                attribute: .leading,
                multiplier: 1.0,
                constant: 20);
        //Header view trailing end is 20 px from right edge of the screen
        let cn2 = NSLayoutConstraint(item: headerView,
                attribute: .trailing,
                relatedBy: .equal,
                toItem: view,
                attribute: .trailing,
                multiplier: 1.0,
                constant: -20);
        //Header view height = constant 60
        let cn3 = NSLayoutConstraint(item: headerView,
                attribute: .height,
                relatedBy: .equal,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1.0,
                constant: 60);

        let cn5 = NSLayoutConstraint(item: headerView,
                attribute: .top,
                relatedBy: .equal,
                toItem: view,
                attribute: .top,
                multiplier: 1.0,
                constant: 20);


        //Footer Section
        let cn16 = NSLayoutConstraint(item: footerView,
                attribute: .leading,
                relatedBy: .equal,
                toItem: view,
                attribute: .leading,
                multiplier: 1.0,
                constant: 20);
        let cn17 = NSLayoutConstraint(item: footerView,
                attribute: .trailing,
                relatedBy: .equal,
                toItem: view,
                attribute: .trailing,
                multiplier: 1.0,
                constant: -20);
        let cn18 = NSLayoutConstraint(item: footerView,
                attribute: .height,
                relatedBy: .equal,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1.0,
                constant: 50);
        let cn21 = NSLayoutConstraint(item: footerView,
                attribute: .bottom,
                relatedBy: .equal,
                toItem: view,
                attribute: .bottom,
                multiplier: 1.0,
                constant: -10);


        view.addConstraint(cn1)
        view.addConstraint(cn2)
        view.addConstraint(cn3)
        view.addConstraint(cn5)
        view.addConstraint(cn16)
        view.addConstraint(cn17)
        view.addConstraint(cn18)
        view.addConstraint(cn21)
        initSearchButton()



        ltv.translatesAutoresizingMaskIntoConstraints = false

        //Table View Controller Contraints
        NSLayoutConstraint(item: ltv,
                attribute: .top,
                relatedBy: .equal,
                toItem: headerView,
                attribute: .bottom,
                multiplier: 1.0,
                constant: 15).isActive = true;
        NSLayoutConstraint(item: ltv,
                attribute: .leading,
                relatedBy: .equal,
                toItem: view,
                attribute: .leading,
                multiplier: 1.0,
                constant: 20).isActive = true;
        NSLayoutConstraint(item: ltv,
                attribute: .trailing,
                relatedBy: .equal,
                toItem: view,
                attribute: .trailing,
                multiplier: 1.0,
                constant: -20).isActive = true;
        NSLayoutConstraint(item: ltv,
                attribute: .bottom,
                relatedBy: .equal,
                toItem: footerView,
                attribute: .top,
                multiplier: 1.0,
                constant: -5).isActive = true;
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
        self.ltv!.rememberedImageData = [:]
        self.ltv!.rememberedImageInstance = [:]
        self.ltv!.downloadProgress = [:]
        ltv!.imageSetModel = GifImageSetModel()
        self.ltv!.rgCollectionView.reloadData();
    }

    var currentSearchText = ""

    func loadMoreResults() {
        paginationOffset += 25
        api.search(keyword: currentSearchText, pagination: paginationOffset)
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


    // 1. FIRE GET REQUEST
//    func apiSearch() {
//        print("apiSearch called.")
//        if let text = txtSearchBox.text {
//            currentSearchText = text
//            api.search(keyword: text, pagination: paginationOffset)
//            paginationOffset += 1
//        }
//    }

    // 2. RECEIVE GET RESPONSE
    func apiDidGetResponse(data: Data) {
        let json = JSON(data: data)
        if let dta = json.rawString() {
            let instance = RGDataObject().deserializeRGDataObject(strJson: dta)
        }


        if let jdata = json["data"].array {
            let arrayLength = jdata.count
            guard arrayLength > 0 else {
                return
            }
            for i in 0...(arrayLength - 1) {
                let giphyId = jdata[i]["id"].string!
                let giphyType = jdata[i]["type"].string!

                if let giphyGifUrl = jdata[i]["images"]["fixed_height_small"].string {
                    let generatedUrl = "http://media1.giphy.com/media/\(giphyId)/giphy.gif"

//                    print(" ╔═════════════════Array[\(i)]═════════════════ ")
//                    print(" ║ giphy - Id : \(giphyId)  ")
//                    print(" ║ giphy - Type : \(giphyType)  ")
//                    print(" ║ giphy - GifUrl : \(giphyGifUrl)  ")
//                    print(" ║ ")
//                    print(" ║ giphy - GeneratedUrl : \(generatedUrl)  ")
//                    print(" ║ giphy - GetImageUrl : http://api.giphy.com/v1/gifs/\(giphyId)&api_key=dc6zaTOxFJmzC")
//                    print(" ╚═════════════════════════════════════════════ \n")

                    let imageStruct = GifImageModel(id: giphyId,
                            imgType: giphyType,
                            gifUrl: URL(string: generatedUrl)!,
                            data: nil,
                            progress: 0,
                            index: ltv!.imageSetModel.images.count);
                    ltv?.imageSetModel = GifImageSetModel(addImage: imageStruct, toSet: ltv!.imageSetModel);
                    if i == (arrayLength - 1) {
                        self.ltv?.downloadProgress = [:]
                        self.ltv?.rgCollectionView.reloadData();
                    }

                } else {
                    let giphyGifUrl = jdata[i]["bitly_gif_url"].string!
                    let generatedUrl = "http://media1.giphy.com/media/\(giphyId)/giphy.gif"

//                    print(" ╔═══════════════  Array[\(i)]  ═══════════════ ")
//                    print(" ║ giphy - Id : \(giphyId)  ")
//                    print(" ║ giphy - Type : \(giphyType)  ")
//                    print(" ║ giphy - GifUrl : \(giphyGifUrl)  ")
//                    print(" ║ ")
//                    print(" ║ giphy - GeneratedUrl : \(generatedUrl)  ")
//                    print(" ║ giphy - GetImageUrl : http://api.giphy.com/v1/gifs/\(giphyId)?api_key=dc6zaTOxFJmzC")
//                    print(" ╚═════════════════════════════════════════════ \n")

                    let imageStruct = GifImageModel(id: giphyId,
                            imgType: giphyType,
                            gifUrl: URL(string: generatedUrl)!,
                            data: nil,
                            progress: 0,
                            index: ltv!.imageSetModel.images.count);
                    ltv?.imageSetModel = GifImageSetModel(addImage: imageStruct, toSet: ltv!.imageSetModel);
                    if i == (arrayLength - 1) {
                        self.ltv?.downloadProgress = [:]
                        self.ltv?.rgCollectionView.reloadData();
                    }
                }


            }
        }

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
//        if let liteView = ltv {
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
