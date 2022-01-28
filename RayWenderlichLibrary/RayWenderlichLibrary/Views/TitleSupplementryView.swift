//
//  TitleSupplementryView.swift
//  RayWenderlichLibrary
//
//  Created by Ankit Singh on 27/01/22.
//  Copyright © 2022 Ray Wenderlich. All rights reserved.
//

import UIKit

class TitleSupplementaryView : UICollectionReusableView {
    
    static let reuseID = "TitleSupplementaryView"
    
    let textLabel = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        addSubview(textLabel)
        
        textLabel.font = .preferredFont(forTextStyle: .title2)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        let inset : CGFloat = 10
        NSLayoutConstraint.activate([
            
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant: inset),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -inset),
            textLabel.topAnchor.constraint(equalTo: topAnchor,constant: inset),
            textLabel.bottomAnchor.constraint(equalTo: bottomAnchor , constant: -inset)
        
        ])
    }
    
}
