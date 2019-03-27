//
//  HGImageCompleteButton.swift
//  ImagePickerDemo
//
//  Created by allen_zhang on 2019/3/27.
//  Copyright © 2019 com.mljr. All rights reserved.
//

import UIKit

class HGImageCompleteButton: UIView {

    var numLabel:UILabel!
    var titleLabel:UILabel!

    let defaultFrame = CGRect(x: 0, y: 0, width: 70, height: 20)
    let titleColor = UIColor(red: 0x09/255, green: 0xbb/255, blue: 0x07/255, alpha: 1)
    var tapSingle: UITapGestureRecognizer?
    
    var num: Int = 0 {
        didSet {
            if num == 0 {
                numLabel.isHidden = true
            } else {
                numLabel.isHidden = false
                numLabel.text = "\(num)"
                playAnimate()
            }
        }
    }
    var isEnabled: Bool = false {
        didSet {
            if isEnabled {
                titleLabel.textColor = titleColor
                tapSingle?.isEnabled = true
            } else {
                titleLabel.textColor = .gray
                tapSingle?.isEnabled = false
            }
        }
    }
    
    init() {
        super.init(frame: defaultFrame)
        numLabel = UILabel(frame:CGRect(x: 0 , y: 0 , width: 20, height: 20))
        numLabel.backgroundColor = titleColor
        numLabel.layer.cornerRadius = 10
        numLabel.layer.masksToBounds = true
        numLabel.textAlignment = .center
        numLabel.font = UIFont.systemFont(ofSize: 15)
        numLabel.textColor = UIColor.white
        numLabel.isHidden = true
        self.addSubview(numLabel)
        
        titleLabel = UILabel(frame:CGRect(x: 20 , y: 0 ,
                                          width: defaultFrame.width - 20,
                                          height: 20))
        titleLabel.text = "完成"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textColor = titleColor
        self.addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func playAnimate() {
        
        self.numLabel.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIView.AnimationOptions(), animations: {
            self.numLabel.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    func addTarget(target: Any?, action: Selector?) {
        tapSingle = UITapGestureRecognizer(target: target, action: action)
        tapSingle?.numberOfTapsRequired = 1
        tapSingle?.numberOfTouchesRequired = 1
        self.addGestureRecognizer(tapSingle!)
    }
}
