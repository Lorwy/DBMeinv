//
//  MNPictureCategoryViewController.swift
//  DBMeinv
//
//  Created by Lorwy on 2017/11/21.
//  Copyright © 2017年 Lorwy. All rights reserved.
//

import UIKit



/// 图片分类页面
class MNPictureCategoryViewController: MNBaseController, UICollectionViewDataSource {
    
    @IBOutlet weak var pictureCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "MNPictureCollectionViewCellIdentifier", for: indexPath)
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
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
