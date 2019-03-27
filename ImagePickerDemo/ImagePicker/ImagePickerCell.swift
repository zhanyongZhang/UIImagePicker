//
//  HGImagePickerCell.swift
//  ImagePickerDemo
//
//  Created by allen_zhang on 2019/3/27.
//  Copyright © 2019 com.mljr. All rights reserved.
//

import UIKit

class ImagePickerCell: UITableViewCell {

    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutMargins = UIEdgeInsets.zero
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
