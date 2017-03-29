//
//  MainViewController.swift
//  iOSHomeWork
//
//  Created by Matt Andrzejczuk on 3/29/17.
//  Copyright © 2017 Harry Tormey. All rights reserved.
//

import UIKit
import SwiftGifOrigin
import Alamofire



class MainViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = .black;
    }
    
    override func viewDidLayoutSubviews() {
        let button1 = UIButton(frame: CGRect(x: 0, y: 400, width: 200, height: 80))
        button1.setTitle("Begin", for: .normal)
        button1.addTarget(self, action: #selector(MainViewController.didPressBtn1), for: .touchUpInside)
        view.addSubview(button1)
    }
    
    func didPressBtn1(sender: UIButton) {
        downloadImageWithAlamo(url: "http://i.giphy.com/Z1kpfgtHmpWHS.gif")
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
