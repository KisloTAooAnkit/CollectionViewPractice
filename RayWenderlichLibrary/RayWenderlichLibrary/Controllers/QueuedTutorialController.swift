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

class QueuedTutorialController: UIViewController {

    static let badgeElementKind = "badge-element-kind"
    
    enum Section {
        case main
    }
    
  lazy var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMM d"
    return formatter
  }()
  
  @IBOutlet var deleteButton: UIBarButtonItem!
  @IBOutlet var updateButton: UIBarButtonItem!
  @IBOutlet var applyUpdatesButton: UIBarButtonItem!
  @IBOutlet weak var collectionView: UICollectionView!
    
    var dataSource : UICollectionViewDiffableDataSource<Section,Tutorial>!

  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureSnapShot()

    }
  
  private func setupView() {
    self.title = "Queue"
    navigationItem.leftBarButtonItem = `editButtonItem`
    navigationItem.rightBarButtonItem = nil
      
      collectionView.register(BadgeSupplementaryView.self, forSupplementaryViewOfKind: QueuedTutorialController.badgeElementKind, withReuseIdentifier: BadgeSupplementaryView.reuseID)
      collectionView.collectionViewLayout = configureCollectionViewLayout()
      configureDataSource()
  }
}

// MARK: - Queue Events -

extension QueuedTutorialController {
  override func setEditing(_ editing: Bool, animated: Bool) {
    super.setEditing(editing, animated: animated)
    
    if isEditing {
      navigationItem.rightBarButtonItems = nil
      navigationItem.rightBarButtonItem = deleteButton
    } else {
      navigationItem.rightBarButtonItem = nil
      navigationItem.rightBarButtonItems = [self.applyUpdatesButton, self.updateButton]
    }

    collectionView.allowsMultipleSelection = true
    collectionView.indexPathsForVisibleItems.forEach { indexPath in
      guard let cell = collectionView.cellForItem(at: indexPath) as? QueueCell else { return }
      cell.isEditing = isEditing
      
      if !isEditing {
        cell.isSelected = false
      }
    }
  }

  @IBAction func deleteSelectedItems() {
      
      guard let selectedIndexPaths = collectionView.indexPathsForSelectedItems else {return}
      
      let tutorials = selectedIndexPaths.compactMap { indexpath in
          return dataSource.itemIdentifier(for:indexpath)
      }
      
      var currentSnapShot = dataSource.snapshot()
      currentSnapShot.deleteItems(tutorials)
      
      dataSource.apply(currentSnapShot,animatingDifferences: true)
      isEditing.toggle()
  }

  @IBAction func triggerUpdates() {
      let indexPaths = collectionView.indexPathsForVisibleItems
      
      let randomIndexPath = indexPaths[Int.random(in: 0..<indexPaths.count)]
      
      let tutorial = dataSource.itemIdentifier(for: randomIndexPath)
      
      tutorial?.updateCount = 3
      
      let badgeView = collectionView.supplementaryView(forElementKind: QueuedTutorialController.badgeElementKind, at: randomIndexPath)
      
      badgeView?.isHidden = false
  }

  @IBAction func applyUpdates() {
  }
}

//MARK: - Collctn.View Layout
extension QueuedTutorialController {
    func configureCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        
        let anchorEdges : NSDirectionalRectEdge = [.top,.trailing]
        let offset = CGPoint(x:0.3,y: -0.3)
        
        let badgeAnchor = NSCollectionLayoutAnchor(edges: anchorEdges, absoluteOffset: offset)
        
        let badgeSize = NSCollectionLayoutSize(widthDimension: .absolute(20), heightDimension: .absolute(20))
        
        let badge = NSCollectionLayoutSupplementaryItem(layoutSize: badgeSize,elementKind: QueuedTutorialController.badgeElementKind,containerAnchor: badgeAnchor)
        
        
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize,supplementaryItems: [badge])
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(149))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}

//MARK: -  Diffable DataSource

extension QueuedTutorialController {
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section,Tutorial>(collectionView: self.collectionView, cellProvider: { collectionView, indexPath, tutorial in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: QueueCell.reuseIdentifier, for: indexPath) as? QueueCell else {fatalError("unable to dequeue Queue cell")}
            
            cell.titleLabel.text = tutorial.title
            cell.thumbnailImageView.image = tutorial.image
            cell.thumbnailImageView.backgroundColor = tutorial.imageBackgroundColor
            cell.publishDateLabel.text = tutorial.formattedDate(using: self.dateFormatter)
            
            return cell
        })
        
        dataSource.supplementaryViewProvider = { [weak self] (collectionView : UICollectionView, kind : String , indexpath : IndexPath) -> UICollectionReusableView? in
            
            guard let self = self else {return nil}
            
            guard let tutorial = self.dataSource.itemIdentifier(for: indexpath) else {return nil}
            
            
            guard let badgeSupplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: QueuedTutorialController.badgeElementKind, withReuseIdentifier: BadgeSupplementaryView.reuseID, for: indexpath) as? BadgeSupplementaryView else {return nil}
            
            if tutorial.updateCount > 0 {
                badgeSupplementaryView.isHidden = false
                
            } else {
                badgeSupplementaryView.isHidden = true
            }
            
            return badgeSupplementaryView
        
        }
    }
    
    func configureSnapShot() {
        
        var snapshot = NSDiffableDataSourceSnapshot<Section,Tutorial>()
        
        snapshot.appendSections([.main])
        
        let queuedTutorials = DataSource.shared.tutorialCollection.flatMap { tutorialCollection in
            return tutorialCollection.selectedTutorials
        }
        snapshot.appendItems(queuedTutorials)
        
        dataSource.apply(snapshot,animatingDifferences: true)
    }
}
