

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var deleteBarButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var addBarButtonItem: UIBarButtonItem!
    
    let dataSource = DataSource()
    let delegate = EmojiCollectionViewDelegate(numberOfItemsPerRow: 6, interItemSpacing: 8)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.dataSource = dataSource
        collectionView.delegate = delegate
        navigationItem.leftBarButtonItem = editButtonItem
        deleteBarButtonItem.isEnabled = false
        collectionView.allowsMultipleSelection = true
        
    }
    
    @IBAction func addEmoji(_ sender: Any) {
        let (category,randomEmoji) = Emoji.randomEmoji()
        dataSource.addEmoji(randomEmoji, to: category)
        
        let emojiCount = collectionView.numberOfItems(inSection: 0)
        let insertedIndex = IndexPath(item: emojiCount, section: 0)
        collectionView.insertItems(at: [insertedIndex])
        
        //        collectionView.reloadData()
    }
    
    
    @IBAction func deleteEmoji(_ sender: Any) {
        if !isEditing {return}


        guard let selectedIndexes =  collectionView.indexPathsForSelectedItems else {return}
        
        let sectionsToDelete = Set(selectedIndexes.map({ indexpath in
            indexpath.section
        }))
        
        for section in sectionsToDelete {
            let indexPathForSection = selectedIndexes.filter({$0.section == section})
            let sortedIndexPaths = indexPathForSection.sorted { indexPath1, indexPath2 in
                indexPath1.item > indexPath2.item
            }
            for index in sortedIndexPaths {
                dataSource.removeEmoji(indexPath: index)
            }
            collectionView.deleteItems(at: selectedIndexes)
        }
        

        

        
    }
    
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        addBarButtonItem.isEnabled = false
        deleteBarButtonItem.isEnabled  = true
        collectionView.indexPathsForVisibleItems.forEach { indexPath in
            guard let emojiCell = collectionView.cellForItem(at: indexPath) as? EmojiCell else {return}
            emojiCell.isEditing = editing
            
        }
        
        if !isEditing{
            addBarButtonItem.isEnabled = true
            deleteBarButtonItem.isEnabled = false
            collectionView.indexPathsForSelectedItems?.forEach({ indexPath in
                collectionView.deselectItem(at: indexPath, animated: true)
            })
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if isEditing && identifier == "showEmojiDetail"{
            return false
        }
        
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showEmojiDetail",
        let emojiCell = sender as? EmojiCell ,
        let emojiDetailController = segue.destination as? EmojiDetailController
        else {
            return
        }
        guard let indexPath = collectionView.indexPath(for: emojiCell) else {
            return
        }

        guard let emoji = Emoji.shared.emoji(at: indexPath) else {
            return
        }
        
        emojiDetailController.emoji = emoji
        
    }
}

