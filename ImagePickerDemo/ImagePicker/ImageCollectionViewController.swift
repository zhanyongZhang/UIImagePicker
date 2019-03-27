//
//  HGImageCollectionViewController.swift
//  ImagePickerDemo
//
//  Created by allen_zhang on 2019/3/27.
//  Copyright © 2019 com.mljr. All rights reserved.
//



import UIKit
import Photos


class ImageCollectionViewController: UIViewController {
    
    @IBOutlet weak var collectionView:UICollectionView!
    @IBOutlet weak var toolBar:UIToolbar!
    var completeButton: ImageCompleteButton!

    var maxSelected: Int = Int.max
    var assetsFetchResults:PHFetchResult<PHAsset>?
    var completeHandler:((_ assets:[PHAsset])->())?
    var imageManager: PHCachingImageManager!
    var assetGridThumbnailSize:  CGSize!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let scale = UIScreen.main.scale
        let cellSize = (self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize
        assetGridThumbnailSize = CGSize(width: cellSize.width * scale, height: cellSize.height * scale)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.backgroundColor = .white
        self.imageManager = PHCachingImageManager()
        resetCachedAssets()
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: UIScreen.main.bounds.size.width/4-1, height: UIScreen.main.bounds.size.width/4-1)
        self.collectionView.allowsMultipleSelection = true
        
        let rightBarItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancel))
        self.navigationItem.rightBarButtonItem = rightBarItem
        
        completeButton = ImageCompleteButton()
        completeButton.addTarget(target: self, action: #selector(finishSelect))
        completeButton.center = CGPoint(x: UIScreen.main.bounds.width - 50, y: 22)
        completeButton.isEnabled = false
        toolBar.addSubview(completeButton)
    }
    
    @objc func cancel() {
       self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func finishSelect() {
        
        var assets: [PHAsset] = []
        if let indexPaths = collectionView.indexPathsForSelectedItems {
            
            for indexPath  in indexPaths {
                assets.append(assetsFetchResults![indexPath.row])
            }
        }
        self.navigationController?.dismiss(animated: true, completion: {
            self.completeHandler?(assets)
        })
    }
    
    func selectedCount() -> Int {
        return self.collectionView.indexPathsForSelectedItems?.count ?? 0
    }
    
    func resetCachedAssets() {
        self.imageManager.stopCachingImagesForAllAssets()
    }
}


extension ImageCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.assetsFetchResults?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCollectionViewCell
        let asset = self.assetsFetchResults![indexPath.row]
        
        self.imageManager.requestImage(for: asset, targetSize: assetGridThumbnailSize, contentMode: .aspectFill, options: nil, resultHandler: { (image, info) in
            cell.imageView.image = image
        })
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let cell = collectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell {
            
            let count = self.selectedCount()
            if count > maxSelected {
                
                collectionView.deselectItem(at: indexPath, animated: false)
                //弹出提示
                let title = "你最多只能选择\(self.maxSelected)张照片"
                let alertController = UIAlertController(title: title, message: nil,
                                                        preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title:"我知道了", style: .cancel,
                                                 handler:nil)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            } else {
                
                completeButton.num = count
                if completeButton.num > 0 && !completeButton.isEnabled {
                    completeButton.isEnabled = true
                }
                cell.playAnimate()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        if let cell = collectionView.cellForItem(at: indexPath)
            as? ImageCollectionViewCell {
            
            let count = self.selectedCount()
            completeButton.num = count
            if count == 0 {
                completeButton.isEnabled = false
            }
            cell.playAnimate()
        }
    }
}
