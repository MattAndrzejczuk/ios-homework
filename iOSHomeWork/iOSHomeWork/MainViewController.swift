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

class MainViewController: UIViewController, GiphyDelegate {
    
    var headerLabel: UILabel!
    var searchView: UITextView!
    var dataView: UIView!
    var footerView: UIView!
    
    
    var api: GiphyApi! = GiphyApi()
    
    let button2 = UIButton(frame: CGRect(x: 0, y: 280, width: 200, height: 80))
    
    let buttonReloadConstraints = UIButton(frame: CGRect(x: 110, y: 400, width: 185, height: 180))
    let ltv: LightTableViewController? = LightTableViewController(frame: CGRect(x: 50, y: 50, width: 100, height: 100))
    
    let txtSearchBox : UITextField = UITextField(frame: CGRect(x: 0, y: 0, width: 250, height: 80))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = .black;
        api.delegate = self
    
        // INIT BUTTONS:
        buttonReloadConstraints.setTitle("API Search", for: .normal)
        buttonReloadConstraints.setTitleColor(DESIGN_PRIMARY_COLOR_1, for: .normal)
        buttonReloadConstraints.setTitleColor(DESIGN_PRIMARY_COLOR, for: .highlighted)
        buttonReloadConstraints.addTarget(self, action: #selector(MainViewController.apiSearch), for: .touchUpInside)
        view.addSubview(buttonReloadConstraints)
        
        initConstraints()
    }
    
    func setLiteTVC() {

    }
    
    
    // 1. FIRE GET REQUEST
    func apiSearch() {
        print("testLayout called.")
        api.search(keyword: "cat")
    }
    
    // 2. RECEIVE GET RESPONSE
    func apiDidGetResponse(data: Data) {
        let json = JSON(data: data)
        
        if let jdata = json["data"].array {
            let arrayLength = jdata.count
            for i in 0...(arrayLength - 1) {
                let giphyId = jdata[i]["id"].string!
                let giphyType = jdata[i]["type"].string!
                
                if let giphyGifUrl = jdata[i]["images"]["fixed_height_small"].string {
                    let generatedUrl = "http://media1.giphy.com/media/\(giphyId)/giphy.gif"
                    
                    print(" ╔═════════════════Array[\(i)]═════════════════ ")
                    print(" ║ giphy - Id : \(giphyId)  ")
                    print(" ║ giphy - Type : \(giphyType)  ")
                    print(" ║ giphy - GifUrl : \(giphyGifUrl)  ")
                    print(" ║ ")
                    print(" ║ giphy - GeneratedUrl : \(generatedUrl)  ")
                    print(" ║ giphy - GetImageUrl : http://api.giphy.com/v1/gifs/\(giphyId)&api_key=dc6zaTOxFJmzC")
                    print(" ╚═════════════════════════════════════════════ \n")
                    
                    let imageStruct = GifImageModel(id: giphyId,
                                                    imgType: giphyType,
                                                    gifUrl: URL(string: generatedUrl)!,
                                                    data: nil);
                    ltv?.imageSetModel = GifImageSetModel(addImage: imageStruct, toSet: ltv!.imageSetModel);
                    self.ltv?.mainTableView.reloadData();
                } else {
                    let giphyGifUrl = jdata[i]["bitly_gif_url"].string!
                    let generatedUrl = "http://media1.giphy.com/media/\(giphyId)/giphy.gif"
                    
                    print(" ╔═══════════════  Array[\(i)]  ═══════════════ ")
                    print(" ║ giphy - Id : \(giphyId)  ")
                    print(" ║ giphy - Type : \(giphyType)  ")
                    print(" ║ giphy - GifUrl : \(giphyGifUrl)  ")
                    print(" ║ ")
                    print(" ║ giphy - GeneratedUrl : \(generatedUrl)  ")
                    print(" ║ giphy - GetImageUrl : http://api.giphy.com/v1/gifs/\(giphyId)?api_key=dc6zaTOxFJmzC")
                    print(" ╚═════════════════════════════════════════════ \n")
                    
                    let imageStruct = GifImageModel(id: giphyId,
                                                    imgType: giphyType,
                                                    gifUrl: URL(string: generatedUrl)!,
                                                    data: nil);
                    ltv?.imageSetModel = GifImageSetModel(addImage: imageStruct, toSet: ltv!.imageSetModel);
                    self.ltv?.mainTableView.reloadData();
                }
                
                
            }
        }

    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            print("Landscape")
            ltv!.frame.size.height = (SCREEN_CONTENT_VIEW.width) + 115
            ltv!.frame.size.width = (SCREEN_CONTENT_VIEW.width * 1.6) + 115
            ltv!.mainTableView.frame.size.height = SCREEN_CONTENT_VIEW.width
            ltv!.mainTableView.frame.size.width = SCREEN_CONTENT_VIEW.width * 1.6
        } else {
            print("Portrait")
            ltv!.frame.size.height = (SCREEN_CONTENT_VIEW.width) + 115
            ltv!.frame.size.width = (SCREEN_CONTENT_VIEW.width * 1.6) + 115
            ltv!.mainTableView.frame.size.height = SCREEN_CONTENT_VIEW.height
            ltv!.mainTableView.frame.size.width = SCREEN_CONTENT_VIEW.width
        }
    }

    
    var cp1 : NSLayoutConstraint?
    var cp2 : NSLayoutConstraint?
    var cl1 : NSLayoutConstraint?
    var cl2 : NSLayoutConstraint?
    
    override func viewDidLayoutSubviews() {
        print("did layout subviews!")

        if let liteView = ltv {
            if UIDevice.current.orientation == .portrait || UIDevice.current.orientation == .portraitUpsideDown {
//                NSLayoutConstraint.activate([cp1!, cp2!])
            } else {

//                NSLayoutConstraint.activate([cl1!, cl2!])
            }
        }
        super.viewDidLayoutSubviews()
    }
    

    
    func didPressBtn1(sender: UIButton) {
        downloadImageWithAlamo(url: "http://media2.giphy.com/media/jTnGaiuxvvDNK/giphy.gif")
    }
    
    func initConstraints() {
        api.search(keyword: "funny+cat+meme")
        
        
        ltv!.frame.size.height = (SCREEN_CONTENT_VIEW.width) + 115
        ltv!.frame.size.width = (SCREEN_CONTENT_VIEW.width * 1.6) + 115
        
        
        ltv!.delegate = self
        view.addSubview(ltv!)
        ltv!.translatesAutoresizingMaskIntoConstraints = false
        ltv!.mainTableView.translatesAutoresizingMaskIntoConstraints = false
        
        // main view
        NSLayoutConstraint(item: ltv!,
                           attribute: .top,
                           relatedBy: .equal,
                           toItem: view,
                           attribute: .top,
                           multiplier: 1.0,
                           constant: 5.0
            ).isActive = true
        
        NSLayoutConstraint(item: ltv!,
                           attribute: .leading,
                           relatedBy: .equal,
                           toItem: view,
                           attribute: .leading,
                           multiplier: 1.0,
                           constant: 5.0
            ).isActive = true

        
        // mainTableView
        NSLayoutConstraint(item: ltv!.mainTableView,
                           attribute: .top,
                           relatedBy: .equal,
                           toItem: ltv!,
                           attribute: .top,
                           multiplier: 2.0,
                           constant: 100.0
            ).isActive = true
        
        NSLayoutConstraint(item: ltv!.mainTableView,
                           attribute: .leading,
                           relatedBy: .equal,
                           toItem: ltv!,
                           attribute: .leading,
                           multiplier: 1.0,
                           constant: 50.0
            ).isActive = true

        
        buttonReloadConstraints.translatesAutoresizingMaskIntoConstraints = false
        
        let topLeftViewLeadingConstraint = NSLayoutConstraint(item: buttonReloadConstraints,
                                                              attribute: .leading,
                                                              relatedBy: .equal,
                                                              toItem: view,
                                                              attribute: .leading,
                                                              multiplier: 1,
                                                              constant: 5)
        
        let topLeftViewTopConstraint = NSLayoutConstraint(item: buttonReloadConstraints,
                                                          attribute: .bottom,
                                                          relatedBy: .equal,
                                                          toItem: view,
                                                          attribute: .bottom,
                                                          multiplier: 1,
                                                          constant: -15)
        
        NSLayoutConstraint.activate([topLeftViewLeadingConstraint,
                                     topLeftViewTopConstraint])
        
        NSLayoutConstraint(item: buttonReloadConstraints,
                           attribute: .height,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .notAnAttribute,
                           multiplier: 1.0,
                           constant: 150).isActive = true
        
        NSLayoutConstraint(item: ltv!,
                                 attribute: .width,
                                 relatedBy: .equal,
                                 toItem: nil,
                                 attribute: .notAnAttribute,
                                 multiplier: 1.0,
                                 constant: (SCREEN.width * 0.95)).isActive = true
        
        NSLayoutConstraint(item: ltv!,
                                 attribute: .height,
                                 relatedBy: .equal,
                                 toItem: nil,
                                 attribute: .notAnAttribute,
                                 multiplier: 1.0,
                                 constant: (SCREEN.height * 0.75)).isActive = true
        
        NSLayoutConstraint(item: ltv!.mainTableView,
                                 attribute: .width,
                                 relatedBy: .equal,
                                 toItem: nil,
                                 attribute: .notAnAttribute,
                                 multiplier: 1.0,
                                 constant: (SCREEN.width * 0.80)).isActive = true
        
        NSLayoutConstraint(item: ltv!.mainTableView,
                                 attribute: .height,
                                 relatedBy: .equal,
                                 toItem: nil,
                                 attribute: .notAnAttribute,
                                 multiplier: 1.0,
                                 constant: (SCREEN.height * 0.60)).isActive = true
    }

    
    

    
    func downloadImageWithAlamo(url: String) {
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                print("Progress: \(progress.fractionCompleted)")
            }
            .validate { request, response, data in
                return .success
            }
            .responseJSON { response in
            if let data = response.data {
                self.didGetImageData(data: data)
            } else {
                print("FAILED TO GET DOWNLOADED IMAGE DATA!!!")
            }
        }
    }
    
    func didGetImageData(data: Data) {
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        let img = UIImage.gif(data: data)
        imgView.image = img
        view.addSubview(imgView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
