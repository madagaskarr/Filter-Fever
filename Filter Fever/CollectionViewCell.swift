//
//  CollectionViewCell.swift
//  CustomTabBar
//
//  Created by Tigran Ghazinyan on 6/29/18.
//  Copyright © 2018 Tigran Ghazinyan. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    
    let showCaseImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.white
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let myLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(showCaseImageView)
        showCaseImageView.layer.cornerRadius = 10
        showCaseImageView.clipsToBounds = true
        showCaseImageView.translatesAutoresizingMaskIntoConstraints = false
        showCaseImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        showCaseImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        showCaseImageView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        showCaseImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -25).isActive = true
        
        
        addSubview(myLabel)
        myLabel.textColor = .lightGray
        myLabel.font = UIFont(name: "Avenir", size: 11)
        myLabel.translatesAutoresizingMaskIntoConstraints = false
        myLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        myLabel.topAnchor.constraint(equalTo: topAnchor, constant: 75).isActive = true
        myLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}
