//
//  MNVideoShowViewController.swift
//  DBMeinv
//
//  Created by Lorwy on 2017/11/24.
//  Copyright © 2017年 Lorwy. All rights reserved.
//

import UIKit
import Kingfisher
import PKHUD

class MNVideoShowViewController: MNBaseController,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var vedioCollectionView: UICollectionView!
    var viewModel = MNVideoShowViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCollectionview), name: NSNotification.Name("populateVideoshttp"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playVideo(notifier:)), name: NSNotification.Name("populateVideosPlayUrlHttp"), object: nil)
        HUD.show(.progress)
        viewModel.populateVieos(loadMore: false)
    }
    
    @objc func reloadCollectionview() -> Void {
        DispatchQueue.main.async(execute: {
//            self.endRefresh()
            if self.viewModel.populateSuccess {
                HUD.hide(animated: true)
                self.vedioCollectionView.reloadData()
            } else {
                HUD.flash(.error, delay: 1.0)
            }
        })
        
    }
    
    @objc func playVideo(notifier:Notification) {
        DispatchQueue.main.async(execute: {
            if self.viewModel.populateSuccess {
                HUD.hide(animated: true)
                // 播放视频
                print(notifier.object ?? "")
            } else {
                HUD.flash(.error, delay: 1.0)
            }
        })
    }
    
    //MARK: - UICollectionViewDataSource
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.videos.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MNVideoCollectionViewCellIdentifier", for: indexPath) as! MNVideoCollectionViewCell
        let model: MNVideo = viewModel.videos.object(at: indexPath.row) as! MNVideo;
        cell.titleLabel.text = model.title
        let imageUrl = URL(string: model.thumbnailUrl)
//        let userUrl = URL(string: model.userPhotoUrl)
        cell.bigImageView.kf.setImage(with: imageUrl)
//        cell.userPhotoImageView.kf.setImage(with: userUrl)
        return cell
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model: MNVideo = viewModel.videos.object(at: indexPath.row) as! MNVideo;
        HUD.show(.progress)
        viewModel.populateVieosUrl(targetUrl: model.videoUrl)
    }
    
    //MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
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