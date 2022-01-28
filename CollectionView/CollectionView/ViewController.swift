//
//  ViewController.swift
//  CollectionView
//
//  Created by Ankit Singh on 26/01/22.
//

import UIKit

class ViewController: UIViewController {

    enum Section{
        case main
    }
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataSource : UICollectionViewDiffableDataSource<Section,Int>!
    let colors : [UIColor] = [.red,.blue,.brown,.systemTeal,.green,.yellow,.orange]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.collectionViewLayout = configureLayout()
        configureDataSource()
    }

    
    
    func configureLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/5), heightDimension: .fractionalHeight(1))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1/5))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func configureDataSource(){
        dataSource = UICollectionViewDiffableDataSource<Section,Int>(collectionView: self.collectionView, cellProvider: { (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell? in
            
           guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NumberCell.reuseID, for: indexPath) as? NumberCell else {
                fatalError("Cannot create a cell")
            }
            cell.backgroundColor = self.colors.randomElement()
            cell.label.text = itemIdentifier.description
            return cell
        })
        
        var initialSnapshot = NSDiffableDataSourceSnapshot<Section,Int>()
        
        initialSnapshot.appendSections([.main])
        initialSnapshot.appendItems(Array(1...100), toSection: .main)
        
        dataSource.apply(initialSnapshot,animatingDifferences: true)
        
    }

}

