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

final class TutorialDetailViewController: UIViewController {
  
  private let tutorial: Tutorial
  static let reuseID = "TutorialDetailViewController"
  @IBOutlet weak var tutorialCoverImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var publishDateLabel: UILabel!
  @IBOutlet weak var queueButton: UIButton!
  @IBOutlet weak var collectionView: UICollectionView!
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  lazy var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMM d"
    return formatter
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()

  }
    
    init?(coder : NSCoder, tutorial : Tutorial){
        self.tutorial = tutorial

        super.init(coder: coder)
   
    }
  
  private func setupView() {
      self.collectionView.dataSource = self
      self.collectionView.collectionViewLayout = configureLayout()
      self.collectionView.register(TitleSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleSupplementaryView.reuseID)
    self.title = tutorial.title
    tutorialCoverImageView.image = tutorial.image
    tutorialCoverImageView.backgroundColor = tutorial.imageBackgroundColor
    titleLabel.text = tutorial.title
    publishDateLabel.text = tutorial.formattedDate(using: dateFormatter)
    
    let buttonTitle = tutorial.isQueued ? "Remove from queue" : "Add to queue"
    queueButton.setTitle(buttonTitle, for: .normal)
  }
  
  @IBAction func toggleQueued() {
      tutorial.isQueued.toggle()
    UIView.performWithoutAnimation {
      if tutorial.isQueued {
        queueButton.setTitle("Remove from queue", for: .normal)
      } else {
        queueButton.setTitle("Add to queue", for: .normal)
      }
      
      self.queueButton.layoutIfNeeded()
    }
  }
}


extension TutorialDetailViewController : UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return tutorial.content.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tutorial.content[section].videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCell.reuseIdentifier, for: indexPath) as? ContentCell else {fatalError("Error in dequeuing cell")}
        
        cell.textLabel.text = tutorial.content[indexPath.section].videos[indexPath.item].title
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleSupplementaryView.reuseID, for: indexPath) as? TitleSupplementaryView else {
            fatalError("Error in creating title for section")
        }
        sectionHeader.textLabel.text = tutorial.content[indexPath.section].title
        return sectionHeader
    }
}

extension TutorialDetailViewController {
    func configureLayout() -> UICollectionViewCompositionalLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(44))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44))
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize , elementKind: UICollectionView.elementKindSectionHeader,alignment: .topLeading)
        
        section.boundarySupplementaryItems = [sectionHeader]
        
        let sectionInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 20, trailing: 10)
        section.contentInsets = sectionInsets
    
        
        return UICollectionViewCompositionalLayout(section: section)
        
    }
}
