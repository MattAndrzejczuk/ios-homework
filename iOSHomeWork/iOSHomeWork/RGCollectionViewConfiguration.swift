//
// Created by Matt Andrzejczuk on 4/4/17.
// Copyright (c) 2017 Harry Tormey. All rights reserved.
//

import UIKit



extension RGCollectionViewController {


    func initConfiguration() {

        backgroundColor = UIColor(patternImage: UIImage(named: "notebook-dark")!)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 150, height: 150)
        rgCollectionView = UICollectionView(frame: SCREEN, collectionViewLayout: layout)

        rgCollectionView.backgroundColor = .clear
        rgCollectionView.register(RGCellProgress.self, forCellWithReuseIdentifier: "progress")
        rgCollectionView.register(RGCellImage.self, forCellWithReuseIdentifier: "image")
        rgCollectionView.register(RGCellError.self, forCellWithReuseIdentifier: "error")
        rgCollectionView.delegate = self
        rgCollectionView.dataSource = self


        self.addSubview(rgCollectionView);
        rgCollectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint(item: rgCollectionView,
                attribute: .top,
                relatedBy: .equal,
                toItem: self,
                attribute: .top,
                multiplier: 1.0,
                constant: 30).isActive = true;
        NSLayoutConstraint(item: rgCollectionView,
                attribute: .leading,
                relatedBy: .equal,
                toItem: self,
                attribute: .leading,
                multiplier: 1.0,
                constant: 1).isActive = true;
        NSLayoutConstraint(item: rgCollectionView,
                attribute: .trailing,
                relatedBy: .equal,
                toItem: self,
                attribute: .trailing,
                multiplier: 1.0,
                constant: 30).isActive = true;
        NSLayoutConstraint(item: rgCollectionView,
                attribute: .bottom,
                relatedBy: .equal,
                toItem: self,
                attribute: .bottom,
                multiplier: 1.0,
                constant: -30).isActive = true;

//        NSLayoutConstraint(item: rgCollectionView,
//                attribute: .width,
//                relatedBy: .equal,
//                toItem: nil,
//                attribute: .width,
//                multiplier: 1.0,
//                constant: 400).isActive = true;
//        NSLayoutConstraint(item: rgCollectionView,
//                attribute: .height,
//                relatedBy: .equal,
//                toItem: nil,
//                attribute: .height,
//                multiplier: 1.0,
//                constant: 500).isActive = true;


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
}
