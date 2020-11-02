//
//  DetailCardTVCTableViewController.swift
//  English Flashcards
//
//  Created by Quang Luong on 11/1/20.
//

import UIKit
import os.log
import AVFoundation

class DetailCardTVC: UITableViewController {
    
    //MARK: Properties
    
    var box: Box?
    var cards = [Card]()
    
    var boxes = [Box]()
    
    //Search Bar
    let searchController = UISearchController(searchResultsController: nil)
    var filteredCards = [Card]()

    //MARK: Default
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up views if editing an existing Box.
        if let box = box {
            navigationItem.title = box.name
            
            cards = box.cards.reversed()
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredCards.count
        }
        return cards.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CardCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CardCell  else {
            fatalError("The dequeued cell is not an instance of CardCell.")
        }
        
        var card = cards[indexPath.row]
        
        if searchController.isActive && searchController.searchBar.text != "" {
            card = filteredCards[indexPath.row]
        } else {
            //OK
        }
        
        cell.lblWord.text = card.word.capitalizingFirstLetter() // beautyText(for: card.word)
        cell.lblDefinition.text = card.definition.capitalizingFirstLetter() // beautyText(for: card.definition)
        cell.lblExample.text = card.example.capitalizingFirstLetter() // beautyText(for: card.example)
        cell.lblCategory.text = card.lexicalCategory.capitalizingFirstLetter() // beautyText(for: card.lexicalCategory)
        cell.lblSpelling.text = card.phoneticSpelling.capitalizingFirstLetter() // beautyText(for: card.phoneticSpelling)
        cell.btnListenOutlet.setTitle(card.audioFile, for: .normal)
        cell.lblAudioPath.text = "\(String(describing: card.audioURL))"
        
        print(card.audioURL ?? "None")
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            cards.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            resaveBox(at: indexPath.row)
        }
        else if editingStyle == .insert {
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //MARK: Actions
    @IBAction func done(_ sender: UIBarButtonItem) {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The DetailCardVC is not inside a navigation controller.")
        }
    }
    
    //MARK; Private Methods
    private func resaveBox(at index: Int) {
        if let savedBoxes = loadBoxes() {
            boxes = savedBoxes
            for i in 0..<savedBoxes.count {
                if savedBoxes[i] == box {
                    boxes[i].cards.remove(at: index)
                    saveBoxes()
                }
            }
        }
    }
    
//    func beautyText(for text: String) -> String {
//        var result = ""
//        text.uppercased().enumerateSubstrings(in: text.startIndex..<text.endIndex, options: .bySentences) { (_, range, _, _) in
//            var substring = text[range] // retrieve substring from original string
//
//            let first = substring.remove(at: substring.startIndex)
//            result += String(first).uppercased() + substring
//        }
//        return result
//    }

    
    private func saveBoxes() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(boxes, toFile: Box.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Boxes successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save boxes...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadBoxes() -> [Box]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Box.ArchiveURL.path) as? [Box]
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
