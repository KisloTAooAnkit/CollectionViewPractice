/// These materials have been reviewed and are updated as of September, 2020
///
/// Copyright (c) 2020 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.
///


import UIKit

final class LibraryController: UIViewController {
  
  @IBOutlet weak var collectionView: UICollectionView!
    var dataSource : UICollectionViewDiffableDataSource<TutorialCollection,Tutorial>!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
      
  }
  
  private func setupView() {
    self.title = "Library"
      collectionView.delegate = self
      collectionView.collectionViewLayout = configureCollectionViewLayout()
      collectionView.register(TitleSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleSupplementaryView.reuseID)
      configureDataSource()
  }
}

//MARK: - CollectionView Layout

extension LibraryController {
    func configureCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let sectionProvider = { (sectionIndex : Int , layoutEnvironment : NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.6), heightDimension: .fractionalHeight(0.3))
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            
            section.orthogonalScrollingBehavior = .continuous
            
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            
            section.interGroupSpacing = 10
            
            
            //Header
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44))
            
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize , elementKind: UICollectionView.elementKindSectionHeader,alignment: .topLeading)
            
            section.boundarySupplementaryItems = [sectionHeader]
            
            
            return section
        }
        
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }
}

//MARK: - CollectionView Diff DataSource
extension LibraryController {
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<TutorialCollection,Tutorial>(collectionView: self.collectionView, cellProvider: { (collectionView, indexPath, tutorial) -> UICollectionViewCell? in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TutorialCell.reuseIdentifier, for: indexPath) as? TutorialCell else {
                fatalError("Error in dequeing cell")
            }
            
            
            cell.titleLabel.text = tutorial.title
            cell.thumbnailImageView.image = tutorial.image
            cell.thumbnailImageView.backgroundColor = tutorial.imageBackgroundColor
            return cell
        })
        
        dataSource.supplementaryViewProvider = { [weak self] (collectionView : UICollectionView , kind : String , indexPath : IndexPath) -> UICollectionReusableView? in
             
            guard let self = self else { fatalError("retain cycle issue")}
            
            if let titleSupplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleSupplementaryView.reuseID, for: indexPath) as? TitleSupplementaryView {
                
                let tutorialCollection = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
                
                titleSupplementaryView.textLabel.text = tutorialCollection.title
                
                
                    return titleSupplementaryView
            } else {
                return nil
            }
            
            
        }
        
        var initialSnapshot = NSDiffableDataSourceSnapshot<TutorialCollection,Tutorial>()
        
        initialSnapshot.appendSections(DataSource.shared.tutorialCollection)
        
        for tutorialCollection in DataSource.shared.tutorialCollection {
            initialSnapshot.appendItems(tutorialCollection.tutorials, toSection: tutorialCollection)
        }
        
        dataSource.apply(initialSnapshot,animatingDifferences: false)
    }
}

//MARK: - UserInteraction UIcollectionViewDelegate

extension LibraryController : UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let tutorial = dataSource.itemIdentifier(for: indexPath) ,
           let tutorialDetailController = storyboard?.instantiateViewController(identifier: TutorialDetailViewController.reuseID,creator: { coder in
               return TutorialDetailViewController(coder: coder, tutorial: tutorial)
           })
        {
            show(tutorialDetailController, sender: nil)
            
        }
    }
}

