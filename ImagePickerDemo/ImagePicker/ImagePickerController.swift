//
//  HGImagePickerController.swift
//  ImagePickerDemo
//
//  Created by allen_zhang on 2019/3/27.
//  Copyright © 2019 com.mljr. All rights reserved.
//

import UIKit
import Photos

struct ImageAlbumItem {
    var title: String?
    var fetchResult: PHFetchResult<PHAsset>
}

class ImagePickerController: UIViewController {

    @IBOutlet weak var tableView:UITableView!
    var items: [ImageAlbumItem] = []
    var maxSelected: Int = Int.max
    var completeHandler: ((_ assets: [PHAsset]) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        PHPhotoLibrary.requestAuthorization { status  in
            
            if status != .authorized {
                return
            }
            
            let smartOptions = PHFetchOptions()
            let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: smartOptions)
            self.convertCollection(collection: smartAlbums)
            
            let userCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)
            self.convertCollection(collection: userCollections as! PHFetchResult<PHAssetCollection>)
            self.items.sort(by: { (item1, item2) -> Bool in
                return item1.fetchResult.count > item2.fetchResult.count
            })
            
            DispatchQueue.main.sync {
                self.tableView.reloadData()
                
                if let imageCollectionVC = self.storyboard?.instantiateViewController(withIdentifier: "hgImageCollectionVC") as? ImageCollectionViewController {
                    
                    imageCollectionVC.title = self.items.first?.title
                    imageCollectionVC.assetsFetchResults = self.items.first?.fetchResult
                    imageCollectionVC.completeHandler = self.completeHandler
                    imageCollectionVC.maxSelected = self.maxSelected
                    self.navigationController?.pushViewController(imageCollectionVC, animated: false)
                }
            }
        }
    }
    private func convertCollection(collection: PHFetchResult<PHAssetCollection>) {
        
        for i in 0..<collection.count {
            
            let resultsOptions = PHFetchOptions()
            resultsOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            resultsOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
            let c = collection[i]
            let assetsFetchResult = PHAsset.fetchAssets(in: c, options: resultsOptions)
            if assetsFetchResult.count > 0 {
                
                let title = titleOfAlbumForChinse(title: c.localizedTitle)
                items.append(ImageAlbumItem(title: title, fetchResult: assetsFetchResult))
            }
        }
    }
    
    private func  titleOfAlbumForChinse(title: String?) -> String? {
        if title == "Slo-mo" {
            return "慢动作"
        } else if title == "Recently Added" {
            return "最近添加"
        } else if title == "Favorites" {
            return "个人收藏"
        } else if title == "Recently Deleted" {
            return "最近删除"
        } else if title == "Videos" {
            return "视频"
        } else if title == "All Photos" {
            return "所有照片"
        } else if title == "Selfies" {
            return "自拍"
        } else if title == "Screenshots" {
            return "屏幕快照"
        } else if title == "Camera Roll" {
            return "相机胶卷"
        }
        return title
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "相册"
        self.tableView.rowHeight = 55
        let rightBarItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancel))
        self.navigationItem.rightBarButtonItem = rightBarItem
    }

    @objc func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showImages" {
            
            guard let imageCollectionVC = segue.destination as? ImageCollectionViewController, let cell = sender as? ImagePickerCell else {
                return
            }
            
            imageCollectionVC.completeHandler = completeHandler
            imageCollectionVC.title = cell.textLabel?.text
            imageCollectionVC.maxSelected = maxSelected
            
            guard let indexPath = self.tableView.indexPath(for: cell) else {
                return
            }
            imageCollectionVC.assetsFetchResults = self.items[indexPath.row].fetchResult
        }
    }
}

extension ImagePickerController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ImagePickerCell
        cell.titleLable.text = "\(String(describing: self.items[indexPath.row].title!))"
        cell.countLabel.text = "\(self.items[indexPath.row].fetchResult.count)"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension UIViewController {
    
    func presentHGImagePicker(maxSelected: Int = Int.max, completeHandler: @escaping ((_ asset: [PHAsset]) -> ())) -> ImagePickerController? {
        
        guard let vc = UIStoryboard(name: "Image", bundle: Bundle.main).instantiateViewController(withIdentifier: "imagePickerVC") as? ImagePickerController  else {
            return nil
        }
        vc.maxSelected = maxSelected
        vc.completeHandler = completeHandler
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
        return vc
    }
}
