//
//  DataSource.swift
//  EmojiLibrary
//
//  Created by Ankit Singh on 26/01/22.
//

import UIKit



class DataSource : NSObject , UICollectionViewDataSource {
    
    
    let emoji = Emoji.shared
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return emoji.sections.count
    }
     
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let category = emoji.sections[section]
        
        return emoji.data[category]?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCell.reuseIdentifier, for: indexPath) as? EmojiCell else {
            fatalError("Error in resuing cell")
        }
        
        let section_category = emoji.sections[indexPath.section]
        let emojiSticker = self.emoji.data[section_category]?[indexPath.item]
        
        cell.emojiLabel.text = emojiSticker ?? ""
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        
        guard let emojiHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: EmojiHeaderView.reuseID, for: indexPath) as? EmojiHeaderView else {
            fatalError("Error in creating section header")
        }
        let category = emoji.sections[indexPath.section]
        emojiHeaderView.label.text = category.rawValue
        return emojiHeaderView
    }
    

}


extension DataSource {
    func addEmoji(_ emoji : String , to category : Emoji.Category){
        guard var emojiData = self.emoji.data[category] else {return}
        emojiData.append(emoji)
        self.emoji.data.updateValue(emojiData, forKey: category)
    }
    
    func removeEmoji(indexPath : IndexPath){
        let category = self.emoji.sections[indexPath.section]
        guard var emojiData = self.emoji.data[category] else {return}
        emojiData.remove(at: indexPath.item)
        self.emoji.data.updateValue(emojiData, forKey: category)
    }
}
