//
//  BadgeSupplementaryView.swift
//  RayWenderlichLibrary
//
//  Created by Ankit Singh on 28/01/22.
//  Copyright © 2022 Ray Wenderlich. All rights reserved.
//

import UIKit

class BadgeSupplementaryView : UICollectionReusableView {
    
    static let reuseID = "BadgeSupplementaryView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        backgroundColor = UIColor(named: "rw-green")
        let radius = bounds.width/2
        layer.cornerRadius = radius
    }
}
