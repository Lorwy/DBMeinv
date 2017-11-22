//
//  MNPictureCategoryViewController.swift
//  DBMeinv
//
//  Created by Lorwy on 2017/11/21.
//  Copyright © 2017年 Lorwy. All rights reserved.
//

import UIKit
import CHTCollectionViewWaterfallLayout
import Kingfisher
import PKHUD


/// 图片分类页面
class MNPictureCategoryViewController: MNBaseController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout ,CHTCollectionViewDelegateWaterfallLayout{
    
    @IBOutlet weak var pictureCollectionView: UICollectionView!
    var pictureViewModel = MNPictureCategoryViewModel()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCollectionview), name: NSNotification.Name("populatePhotoshttp"), object: nil)
        self.setupCollectionView()
        HUD.show(.progress)
        pictureViewModel.populatePhotos()
    }
    
    @objc func reloadCollectionview() -> Void {
//        let lastItem = pictureViewModel.photos.count
//        let indexpaths = (lastItem..<pictureViewModel.photos.count).map({
//            NSIndexPath(item: $0, section: 0)
//        })
        DispatchQueue.main.async(execute: {
            if self.pictureViewModel.populateSuccess {
                HUD.flash(.success, delay: 1.0)
                self.pictureCollectionView.reloadData()
            } else {
                HUD.flash(.error, delay: 1.0)
            }
        })
       
    }
    
    func setupCollectionView() {
        let layout = pictureCollectionView.collectionViewLayout as! CHTCollectionViewWaterfallLayout
        layout.columnCount = 3;
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictureViewModel.photos.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MNPictureCollectionViewCellIdentifier", for: indexPath) as! MNPictureCollectionViewCell
        let model: PhotoInfo = pictureViewModel.photos.object(at: indexPath.row) as! PhotoInfo;
        let imageUrl = URL(string: model.imageUrl)
        cell.pictureImageView.image = nil
        
        cell.pictureImageView.kf.setImage(with: imageUrl,
                                          placeholder: nil,
                                          options: [.transition(ImageTransition.fade(1))],
                                          progressBlock: { receivedSize, totalSize in
            print("\(indexPath.row + 1): \(receivedSize)/\(totalSize)")
        },
                                          completionHandler: { image, error, cacheType, imageURL in
                                            if image != nil {
                                                if !model.imageSize.equalTo(image!.size) {
                                                    model.imageSize = image!.size
                                                    collectionView.reloadItems(at: [indexPath])
                                                }
                                            }
        })
        cell.titleLabel.text = model.title
        return cell
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: (self.view.frame.width * 2 / 15) + 20)
    }
    
    // MARK: - CHTCollectionViewDelegateWaterfallLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let model: PhotoInfo = pictureViewModel.photos.object(at: indexPath.row) as! PhotoInfo;
        if !model.imageSize.equalTo(CGSize.zero) {
            return model.imageSize
        }
        return CGSize(width: 150, height: 150)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
