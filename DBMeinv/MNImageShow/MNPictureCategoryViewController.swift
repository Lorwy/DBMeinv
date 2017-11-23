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
import MJRefresh


/// 图片分类页面
class MNPictureCategoryViewController: MNBaseController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout ,CHTCollectionViewDelegateWaterfallLayout{
    
    var didSelectType = false
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var lineView: UIView!
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
        self.configureRefresh()
        self .getPictureData(isloadMore: false)
    }
    
    @objc func reloadCollectionview() -> Void {
        if didSelectType {
            self.pictureCollectionView.contentOffset = CGPoint(x:0, y:0)
        }
        DispatchQueue.main.async(execute: {
            self.endRefresh()
            if self.pictureViewModel.populateSuccess {
                HUD.hide(animated: true)
                self.pictureCollectionView.reloadData()
            } else {
                HUD.flash(.error, delay: 1.0)
            }
        })
       
    }
    
    // MARK: Refresh
    
    func endRefresh() -> Void {
        if self.pictureCollectionView.mj_header != nil{
            self.pictureCollectionView?.mj_header.endRefreshing()
        }
        if self.pictureCollectionView.mj_footer != nil{
            self.pictureCollectionView?.mj_footer.endRefreshing()
        }
    }
    
    func setupCollectionView() {
        let layout = pictureCollectionView.collectionViewLayout as! CHTCollectionViewWaterfallLayout
        layout.columnCount = 3;
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        self.pictureCollectionView.scrollsToTop = true
    }
    
    func configureRefresh() {
        self.pictureCollectionView?.mj_header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            print("header")
            self.getPictureData(isloadMore: false)
        })
        self.pictureCollectionView?.mj_footer = MJRefreshAutoFooter(refreshingBlock: { () -> Void in
            print("footer")
            self.getPictureData(isloadMore: true)
        })
    }
    
    func getPictureData(isloadMore: Bool) -> Void {
        HUD.show(.progress)
        pictureViewModel.populatePhotos(loadMore: isloadMore)
    }
    
    //MARK: - UICollectionViewDataSource
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
    
    // MARK: - Action
    @IBAction func titelButtonClicked(_ sender: UIButton) {
        didSelectType = true
        for button : UIView in self.stackView.subviews {
            if button is UIButton {
                (button as! UIButton).setTitleColor(UIColor.black, for: .normal)
            }
        }
        sender.setTitleColor(UIColor(red:0.34, green:0.79, blue:0.99, alpha:1.00), for: .normal)
        UIView.animate(withDuration: 0.5) {
            self.lineView.center = CGPoint.init(x: sender.center.x, y: self.lineView.center.y)
        }
        HUD.show(.progress)
        self.pictureViewModel.selectIndexDidChanged(index: sender.tag)
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
