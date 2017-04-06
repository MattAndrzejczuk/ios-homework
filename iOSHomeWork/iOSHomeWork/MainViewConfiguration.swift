//
//  MainViewConfiguration.swift
//  iOSHomeWork
//
//  Created by Matt Andrzejczuk on 4/6/17.
//  Copyright © 2017 Harry Tormey. All rights reserved.
//

import UIKit
import SwiftGifOrigin
import SwiftyJSON
import Alamofire




extension MainViewController {
    
    func runDefaultConfiguration() {
        api.delegate = self
        txtSearchBox.delegate = self
        documentController.delegate = self
        ltv.delegate = self
        
        let genericFrame = CGRect(x: 0, y: 0, width: 300, height: 50)
        headerView = UILabel(frame: genericFrame)
        ltv = RGCollectionViewController(frame: genericFrame)
        footerView = UIView(frame: genericFrame)
        footerView?.isHidden = true
        
        ltv!.layer.shadowColor = UIColor.black.cgColor
        ltv!.layer.shadowOffset = CGSize.zero
        ltv!.layer.shadowOpacity = 0.5
        ltv!.layer.shadowRadius = 5
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [GMColor.tealA700Color().cgColor, GMColor.tealA100Color().cgColor]
        ltv.layer.insertSublayer(gradient, at: 0)
        ltv!.rgCollectionView.backgroundColor = UIColor(patternImage: UIImage(named: "rubber-grip")!)
        
        autolayoutUsingConstraint()
    }
    
    func initUI() {
        footerView?.backgroundColor = .gray
        
        headerView?.translatesAutoresizingMaskIntoConstraints = false
        ltv?.translatesAutoresizingMaskIntoConstraints = false
        //        ltv?.clipsToBounds = true
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
        
        view.addSubview(ltv!)
        //        ltv?.addSubview(ltv)
        ltv.bringSubview(toFront: view)
        view.addSubview(buttonSearch)
        view.addSubview(txtSearchBox)
        view.addSubview(buttonClearResults)
        view.addSubview(btnShowMore)
        
        buttonSearch.setTitle("Search", for: .normal)
        buttonSearch.addTarget(self,
                               action: #selector(MainViewController.didPressSearch),
                               for: .touchUpInside)
        buttonSearch.setTitleColor(GMColor.deepOrange900Color(), for: .normal)
        
        
        buttonClearResults.setTitle("Clear Results", for: .normal)
        buttonClearResults.addTarget(self,
                                     action: #selector(MainViewController.clearTableViewData),
                                     for: .touchUpInside)
        buttonClearResults.setTitleColor(GMColor.deepOrange900Color(), for: .normal)
        
        
        btnShowMore.setTitle("Load More", for: .normal)
        btnShowMore.addTarget(self,
                              action: #selector(MainViewController.loadMoreResults),
                              for: .touchUpInside)
        btnShowMore.setTitleColor(GMColor.deepOrange900Color(), for: .normal)
        
        
        txtSearchBox.placeholder = "Search Keywords"
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
        let cn1 = NSLayoutConstraint(item: headerView as! UIView,
                                     attribute: .leading,
                                     relatedBy: .equal,
                                     toItem: view,
                                     attribute: .leading,
                                     multiplier: 1.0,
                                     constant: 20);
        //Header view trailing end is 20 px from right edge of the screen
        let cn2 = NSLayoutConstraint(item: headerView as! UIView,
                                     attribute: .trailing,
                                     relatedBy: .equal,
                                     toItem: view,
                                     attribute: .trailing,
                                     multiplier: 1.0,
                                     constant: -20);
        //Header view height = constant 60
        let cn3 = NSLayoutConstraint(item: headerView as! UIView,
                                     attribute: .height,
                                     relatedBy: .equal,
                                     toItem: nil,
                                     attribute: .notAnAttribute,
                                     multiplier: 1.0,
                                     constant: 60);
        
        let cn5 = NSLayoutConstraint(item: headerView as! UIView,
                                     attribute: .top,
                                     relatedBy: .equal,
                                     toItem: view,
                                     attribute: .top,
                                     multiplier: 1.0,
                                     constant: 20);
        
        
        //Footer Section
        let cn16 = NSLayoutConstraint(item: footerView as! UIView,
                                      attribute: .leading,
                                      relatedBy: .equal,
                                      toItem: view,
                                      attribute: .leading,
                                      multiplier: 1.0,
                                      constant: 20);
        let cn17 = NSLayoutConstraint(item: footerView as! UIView,
                                      attribute: .trailing,
                                      relatedBy: .equal,
                                      toItem: view,
                                      attribute: .trailing,
                                      multiplier: 1.0,
                                      constant: -20);
        let cn18 = NSLayoutConstraint(item: footerView as! UIView,
                                      attribute: .height,
                                      relatedBy: .equal,
                                      toItem: nil,
                                      attribute: .notAnAttribute,
                                      multiplier: 1.0,
                                      constant: 50);
        let cn21 = NSLayoutConstraint(item: footerView as! UIView,
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
                           toItem: view,
                           attribute: .top,
                           multiplier: 1.0,
                           constant: 0).isActive = true;
        NSLayoutConstraint(item: ltv,
                           attribute: .leading,
                           relatedBy: .equal,
                           toItem: view,
                           attribute: .leading,
                           multiplier: 1.0,
                           constant: 0).isActive = true;
        NSLayoutConstraint(item: ltv,
                           attribute: .trailing,
                           relatedBy: .equal,
                           toItem: view,
                           attribute: .trailing,
                           multiplier: 1.0,
                           constant: 0).isActive = true;
        NSLayoutConstraint(item: ltv,
                           attribute: .bottom,
                           relatedBy: .equal,
                           toItem: view,
                           attribute: .bottom,
                           multiplier: 1.0,
                           constant: 0).isActive = true;
    }
}
