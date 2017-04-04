//
//  CustomTableViewCell.swift
//  ProgrammaticTableViewCell
//
//  Created by Matt Andrzejczuk on 3/8/17.
//  Copyright © 2017 Matt Andrzejczuk. All rights reserved.
//
import UIKit



class CustomTableViewCell: UITableViewCell {
    
    var imgView: UIImageView!
    var lblId: UILabel?
    var delegate: LightTableViewController!
    var progressBar : UIProgressView = UIProgressView(frame: CGRect(x: 190, y: 100, width: 200, height: 20))
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        let f1 = CGRect(x: 10, y: 5, width: 300, height: 300)
        let f4 = CGRect(x: SCREEN.width * 0.35, y: 50, width: SCREEN.width * 0.45, height: 100)
        
        imgView = UIImageView(frame: f1)
        lblId = UILabel(frame: f4)
        lblId?.textColor = DESIGN_PRIMARY_COLOR_1
        
        imgView.image = UIImage(named: "home")
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initializeLabels()
        
        
//        self.translatesAutoresizingMaskIntoConstraints = false;
        progressBar.translatesAutoresizingMaskIntoConstraints = false;
        imgView.translatesAutoresizingMaskIntoConstraints = false;
        
        NSLayoutConstraint(item: progressBar,
                           attribute: .top,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .top,
                           multiplier: 1.0,
                           constant: 100).isActive = true
        NSLayoutConstraint(item: progressBar,
                           attribute: .leading,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .leading,
                           multiplier: 1.0,
                           constant: 30).isActive = true
        NSLayoutConstraint(item: progressBar,
                           attribute: .width,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .notAnAttribute,
                           multiplier: 1.0,
                           constant: 200).isActive = true
        
        NSLayoutConstraint(item: imgView,
                           attribute: .top,
                           relatedBy: .equal,
                           toItem: contentView,
                           attribute: .top,
                           multiplier: 1.0,
                           constant: 10).isActive = true
        NSLayoutConstraint(item: imgView,
                           attribute: .width,
                           relatedBy: .equal,
                           toItem: contentView,
                           attribute: .width,
                           multiplier: 0.5,
                           constant: 0).isActive = true
        
        imgView.contentMode = .scaleAspectFit
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
    }
    
    func initializeLabels() {
        let allItems : [UIView] = [lblId!, imgView, progressBar]
        
        for item in allItems {
            self.contentView.addSubview(item)
        }
        
        // OPTIONAL CUSTOM FONT:
        for item in allItems {
            if item is UILabel {
                (item as! UILabel).font = UIFont(name: "AvenirNext-UltraLight", size: 13)
                (item as! UILabel).numberOfLines = 0
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}


func junk() {
    DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.low).async {
        DispatchQueue.main.async {
        }
    }
}
