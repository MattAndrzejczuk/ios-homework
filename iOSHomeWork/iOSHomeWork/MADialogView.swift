//
//  MADialogView.swift
//  iOSHomeWork
//
//  Created by Matt Andrzejczuk on 4/2/17.
//  Copyright © 2017 Harry Tormey. All rights reserved.
//

import UIKit





class MADialogView : UIView {
    override func draw(_ rect: CGRect) {
        let c = UIGraphicsGetCurrentContext()
        c!.addRect(CGRect(x:10, y:10, width:80, height:80))
        c!.setStrokeColor(UIColor.red.cgColor)
        c!.strokePath()
    }
}


class MADialogGlassBorder : UIVisualEffectView {
    override func draw(_ rect: CGRect) {
        let c = UIGraphicsGetCurrentContext()
        c!.strokeEllipse(in: rect)
        c!.setStrokeColor(UIColor.red.cgColor)
        c!.strokePath()
    }
}
