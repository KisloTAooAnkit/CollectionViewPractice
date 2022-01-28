//
//  DataSource.swift
//  RayWenderlichLibrary
//
//  Created by Ankit Singh on 27/01/22.
//  Copyright © 2022 Ray Wenderlich. All rights reserved.
//

import Foundation


class DataSource{
    
    static let shared = DataSource()
    
    var tutorialCollection : [TutorialCollection]
    
    private let decoder = PropertyListDecoder()
    
    
    private init(){
        self.tutorialCollection = []
        guard let url = Bundle.main.url(forResource: "Tutorials", withExtension: "plist") else {
            return
        }
        
        guard let data = try? Data(contentsOf: url) else {
            return
        }
        
        guard let tutorialCollection = try? decoder.decode([TutorialCollection].self, from: data) else {
            return
        }
        
        self.tutorialCollection = tutorialCollection
                
    }

}




