//
//  ViewController.swift
//  ImagePickerDemo
//
//  Created by allen_zhang on 2019/3/27.
//  Copyright © 2019 com.mljr. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
    }

    @IBAction func tap(_ sender: Any) {

      _ =  self.presentHGImagePicker(maxSelected: 4) { asset  in
            
            print(asset.description)
        }
    }
    
}

