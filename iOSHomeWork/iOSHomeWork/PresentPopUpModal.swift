//
//  PresentPopUpModal.swift
//  iOSHomeWork
//
//  Created by Matt Andrzejczuk on 4/6/17.
//  Copyright © 2017 Harry Tormey. All rights reserved.
//

import UIKit


struct PresentPopUpModal {
    let dialogModal: UIVisualEffectView
    private let dialogModalGlass: UIVisualEffectView
    let delegate: UIView
    var isClosed: Bool = true
    
    init(onView: UIView) {
        let modalOrigin = CGRect(x: 50, y: 0, width: 160, height: 160)
        
        let blurEffect = UIBlurEffect(style: .light)
        dialogModal = UIVisualEffectView(effect: blurEffect)
        dialogModal.layer.cornerRadius = 10.0
        dialogModal.layer.borderWidth = 0.0
        dialogModal.clipsToBounds = true
        dialogModal.frame = modalOrigin
        
        // SECOND FROSTED GLASS LAYER (vibrancy):
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        dialogModalGlass = UIVisualEffectView(effect: vibrancyEffect)
        dialogModalGlass.layer.cornerRadius = 10.0
        dialogModalGlass.layer.borderWidth = 0.0
        dialogModalGlass.clipsToBounds = true
        dialogModalGlass.frame = modalOrigin
        
        onView.addSubview(dialogModal)
        dialogModal.contentView.addSubview(dialogModalGlass)
        
        delegate = onView
    }

}
