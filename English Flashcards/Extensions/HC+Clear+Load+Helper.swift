//
//  HC+Clear+Load+Helper.swift
//  English Flashcards
//
//  Created by QUANG on 3/1/17.
//  Copyright © 2017 QUANG INDUSTRIES. All rights reserved.
//

import UIKit
import os.log

extension HomeController {
    func loadBoxes() -> [Box]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Box.ArchiveURL.path) as? [Box]
    }
    
    func saveBoxes() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(boxes, toFile: Box.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Boxes successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save boxes...", log: OSLog.default, type: .error)
        }
    }
    
    func loadCards() -> [Card]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Card.ArchiveURL.path) as? [Card]
    }
    
    func saveCards() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(cards, toFile: Card.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Cards successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save cards...", log: OSLog.default, type: .error)
        }
    }
}


