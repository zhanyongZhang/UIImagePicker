//
//  HGImageCollectionViewCell.swift
//  ImagePickerDemo
//
//  Created by allen_zhang on 2019/3/27.
//  Copyright © 2019 com.mljr. All rights reserved.
//

import UIKit

class HGImageCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imageView:UIImageView!
    @IBOutlet weak var selectedIcon:UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
    
   open  override var isSelected: Bool {
        
        didSet {
            if isSelected {
                selectedIcon.image = UIImage(named: "hg_image_selected")
            } else {
                selectedIcon.image = UIImage(named: "hg_image_not_selected")
            }
        }
    }
    
    func playAnimate() {
        UIView.animateKeyframes(withDuration: 0.4, delay: 0, options: .allowUserInteraction, animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2, animations: {
                self.selectedIcon.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.4, animations: {
                self.selectedIcon.transform = CGAffineTransform.identity
            })
        }, completion: nil)
        
    }
}
