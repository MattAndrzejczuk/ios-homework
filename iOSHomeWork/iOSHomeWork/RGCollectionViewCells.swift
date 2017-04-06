//
// Created by Matt Andrzejczuk on 4/4/17.
// Copyright (c) 2017 Harry Tormey. All rights reserved.
//

import UIKit


class RGCellImage: UICollectionViewCell {
    var imageView : UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        tintColor = GMColor.amber500Color()
        backgroundColor = UIColor(patternImage: (UIImage(named: "bg02")!))
        imageView = UIImageView(frame: CGRect(x:0, y:0, width:100,height:100))


        contentView.addSubview(imageView)
        isOpaque = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: imageView,
                attribute: .top,
                relatedBy: .equal,
                toItem: contentView,
                attribute: .top,
                multiplier: 1.0,
                constant: 30).isActive = true;
        NSLayoutConstraint(item: imageView,
                attribute: .leading,
                relatedBy: .equal,
                toItem: contentView,
                attribute: .leading,
                multiplier: 1.0,
                constant: 3).isActive = true;
        NSLayoutConstraint(item: imageView,
                attribute: .trailing,
                relatedBy: .equal,
                toItem: contentView,
                attribute: .trailing,
                multiplier: 1.0,
                constant: -3).isActive = true;
        NSLayoutConstraint(item: imageView,
                attribute: .bottom,
                relatedBy: .equal,
                toItem: contentView,
                attribute: .bottom,
                multiplier: 1.0,
                constant: -30).isActive = true;


    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}


class RGCellProgress: UICollectionViewCell {
    var progressBar : UIProgressView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        progressBar = UIProgressView(frame: frame)
        backgroundColor = GMColor.green800Color()
        contentView.addSubview(progressBar)
        progressBar.setProgress(0.0, animated: false)
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: progressBar,
                attribute: .top,
                relatedBy: .equal,
                toItem: contentView,
                attribute: .top,
                multiplier: 1.0,
                constant: 30).isActive = true;
        NSLayoutConstraint(item: progressBar,
                attribute: .leading,
                relatedBy: .equal,
                toItem: contentView,
                attribute: .leading,
                multiplier: 1.0,
                constant: 3).isActive = true;
//        NSLayoutConstraint(item: progressBar,
//                attribute: .trailing,
//                relatedBy: .equal,
//                toItem: contentView,
//                attribute: .trailing,
//                multiplier: 1.0,
//                constant: -80).isActive = true;
        NSLayoutConstraint(item: progressBar,
                attribute: .bottom,
                relatedBy: .equal,
                toItem: contentView,
                attribute: .top,
                multiplier: 1.0,
                constant: 35).isActive = true;
        NSLayoutConstraint(item: progressBar,
                attribute: .height,
                relatedBy: .equal,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1.0,
                constant: 16).isActive = true;
        NSLayoutConstraint(item: progressBar,
                attribute: .width,
                relatedBy: .equal,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1.0,
                constant: 100).isActive = true;

        progressBar.progressImage = UIImage(named: "progressCompleted-1")
        progressBar.trackImage = UIImage(named: "progress-1")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
//        progressBar = UIProgressView(frame: frame)
//        backgroundColor = GMColor.indigo50Color()
//        contentView.addSubview(progressBar)
    }
}


class RGCellError: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = GMColor.red800Color()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}