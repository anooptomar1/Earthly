//
//  EarthlyImagePager.swift
//  Earthly
//
//  Created by Max Rogers on 1/9/18.
//  Copyright © 2018 Max Rogers. All rights reserved.
//

import Foundation
import FSPagerView


class EarthlyImagePager: FSPagerView, FSPagerViewDataSource, FSPagerViewDelegate {
    
    // MARK: - Properties
    
    var images: [UIImage] = [] {
        didSet {
            setupImages(images)
        }
    }
    var pageControl: FSPageControl!
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self
        dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        delegate = self
        dataSource = self
        register(FSPagerViewCell.self, forCellWithReuseIdentifier: "imageCell")
    }
    
    func setupImages(_ images: [UIImage]) {
        pageControl.numberOfPages = images.count
        pageControl.setFillColor(#colorLiteral(red: 0.2901960784, green: 0.5647058824, blue: 0.8862745098, alpha: 1), for: .selected)
        pageControl.setFillColor(UIColor.white, for: .normal)
        bringSubview(toFront: pageControl)
        
        if let sampleImage = images.first {
            itemSize = sampleImage.size
        }
        
        isInfinite = true
        backgroundColor = UIColor.clear
        transformer = FSPagerViewTransformer(type: .cubic)
        
        reloadData()
    }
    
    
    // MARK: - Datasource
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return images.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "imageCell", at: index)
        cell.imageView?.image = images[index]
        cell.imageView?.contentMode = .scaleAspectFill
        return cell
    }
    
    // MARK: - Delegate
    
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        guard pageControl.currentPage != pagerView.currentIndex else { return }
        pageControl.currentPage = pagerView.currentIndex
    }
    
}

