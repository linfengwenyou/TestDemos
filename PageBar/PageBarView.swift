//
//  PageBarView.swift
//  DemoTest
//
//  Created by fumi on 2018/12/28.
//  Copyright © 2018 rayor. All rights reserved.
//

import UIKit

// 需要添加控制器切换就更好了

class PageBarView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    lazy var layout:UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout.init()
        return layout
    }()
    lazy var mainView: UICollectionView = {
        let view = UICollectionView(frame: self.bounds, collectionViewLayout: self.layout)
        view.backgroundColor = UIColor.groupTableViewBackground
        view.isScrollEnabled = false
        return view
    }()
    
    private var currentSelect:Int = 0
    
    /** 选中事件 */
    var didSelectAction:((Int)->())?
    
    var data:[String] = ["测试1","测试2"] {
        didSet {
            self.updateUIAttribute()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.mainView)
        self.mainView.delegate = self
        self.mainView.dataSource = self
        self.updateUIAttribute()
        self.registerCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func updateUIAttribute(){
        let screenW = UIScreen.main.bounds.size.width
        let width = (screenW - CGFloat((data.count + 1) * 10)) / CGFloat(data.count)
        layout.itemSize = CGSize(width: width, height: self.bounds.size.height)
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 10)
        self.currentSelect = 0
    }
}


extension PageBarView {
    func registerCell() {
        self.mainView.register(UINib.init(nibName: "PageBarCell", bundle: nil), forCellWithReuseIdentifier: "PageBarCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PageBarCell", for: indexPath) as! PageBarCell
        cell.title = self.data[indexPath.row]
        cell.cellSelected = indexPath.row == self.currentSelect;
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 更新到外部访问
        if let action = self.didSelectAction, indexPath.row != self.currentSelect {
            self.currentSelect = indexPath.row
            action(indexPath.row)
            self.mainView.reloadData()
        }
    }
    
}
/*
 使用说明：
 let view = PageBarView.init(frame: CGRect(x: 0, y: 50, width: UIScreen.main.bounds.size.width, height: 40))
 view.data = ["附近的人","更多条件查找"]
 view.didSelectAction = {(index) in
 print("当前选中：\(index)")
 }
 */
