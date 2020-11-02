//
//  ViewController.swift
//  English Flashcards
//
//  Created by Quang Luong on 11/1/20.
//

import UIKit
import os.log
import SCLAlertView
import ChameleonFramework

class HomeController: UIViewController {
    
    //MARK: Properties
    var boxes: [Box] = []
    var cards: [Card] = []
        
    let defaults = UserDefaults.standard
    
    var taskIsTerminated = false
    var taskIsRunning = false
    
    struct defaultsKeys {
        static let lastText = "lastText"
        static let taskTerminated = "taskTerminated"
        static let isRandomOn = "isRandomOn"
    }
    
    //MARK: Outlets
    @IBOutlet weak var tableOfBoxes: UITableView!
    @IBOutlet weak var wordsField: UITextView!
    @IBOutlet weak var btnCreateOutlet: UIButton!
    
    @IBOutlet weak var btnClearOutlet: UIBarButtonItem!
    @IBOutlet weak var btnSettingsOutlet: UIBarButtonItem!
    
    //MARK: Actions
    @IBAction func clearWordsField(_ sender: UIBarButtonItem) {
        wordsField.text = ""
    }
    
    @IBAction func btnSettingsAction(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller: UINavigationController = storyboard.instantiateViewController(withIdentifier: "SettingsTVC") as! UINavigationController
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func btnCreateAction(_ sender: UIButton) {
        
        if !wordsField.text.replacingOccurrences(of: " ", with: "").isEmpty {
            let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
            let alert = SCLAlertView(appearance: appearance)
            let txt = alert.addTextField("Box Intermediate Word")
            _ = alert.addButton("Create") {
                
                self.cards.removeAll()
                self.saveCards()
                
                self.title = "\(self.wordsField.numberOfLines()) Word(s)"
                
                var words = self.wordsField.text.replacingOccurrences(of: " ", with: "").components(separatedBy: "\n") // ["Hello", "World"]
                
                while words[words.endIndex - 1] == "" {
                    words.remove(at: words.endIndex - 1)
                }
                
                self.create(box: txt.text!, words: words, totalWords: words.count) //Every card is a word
            }
            _ = alert.showEdit("Confirmation", subTitle: "Enter this box name: ", closeButtonTitle: "Cancel")
        }
        else {
            let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
            let alert = SCLAlertView(appearance: appearance)
            
            _ = alert.showError("Wait....", subTitle: "You haven't done anything silly 😬", closeButtonTitle: "Oh right!")
        }
    }
    
    
    //MARK: Default
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wordsField.delegate = self
        
        //Load cached text
        if let history = defaults.string(forKey: defaultsKeys.lastText) {
            wordsField.text = history
        }
        
        updateUI()
        
        //Clear when debugging
        if let savedBoxes = loadBoxes() {
            
            if savedBoxes.count > 0 {
                boxes += savedBoxes
                print("Boxes: \(boxes.count)")
                print("Cards: \(boxes[0].cards.count)")
            }
        }
        else {
            let words = ["Hello", "morning", "monkey", "dragon"]
            create(box: "Box 1", words: words, totalWords: words.count)
        }
    }
    
    //MARK: Private Methods
    func create(box name: String, words: [String], totalWords: Int) {
        if !defaults.bool(forKey: defaultsKeys.taskTerminated) {
            _ = OXFORD().getOxfordDataFor(boxName: name, words: words, totalWords: totalWords)
        }
        else {
            cards.removeAll()
            saveCards()
        }
    }
    
    private func updateProgressStatus(expectedCards: Int) -> Float {
        
        if let savedCards = self.loadCards() {
            self.cards += savedCards
            
            if let savedBoxes = loadBoxes() {
                boxes = savedBoxes
                print("Boxes: \(boxes.count)")
                print("Cards: \(boxes[0].cards.count)")
            }
            
            if boxes.count == tableOfBoxes.numberOfRows(inSection: 0) + 1 {
                print(tableOfBoxes.numberOfRows(inSection: 0))
                print(boxes.count)
                tableOfBoxes.reloadData()
                
                return 1.0 //Completed
            }
            
            if cards.count < expectedCards {
                let progress: Float = ((Float(cards.count) / Float(expectedCards)) * 100).rounded() / 100
                
                return progress
            }
            
            if cards.count == expectedCards {
                tableOfBoxes.reloadData()
                
                return 1.0 //Completed
            }
            
            return 0.0
        }
        else {
            return 0.0
        }
    }
}
