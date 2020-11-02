//
//  HCTableViewHelper.swift
//  English Flashcards
//
//  Created by QUANG on 3/1/17.
//  Copyright © 2017 QUANG INDUSTRIES. All rights reserved.
//

import UIKit
import ChameleonFramework

extension HomeController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return boxes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableOfBoxes.dequeueReusableCell(withIdentifier: "BoxCell", for: indexPath) as! BoxCell
        
        cell.contentView.backgroundColor = self.tableOfBoxes.backgroundColor
        cell.boxName.text = boxes[indexPath.row].name
        cell.placeholderView.backgroundColor = RandomFlatColor()
        cell.boxName.textColor = ContrastColorOf(cell.placeholderView.backgroundColor!, returnFlat: true)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let savedBoxes = loadBoxes() {
            boxes = savedBoxes
            print("Boxes: \(boxes.count)")
            print("Cards: \(boxes[0].cards.count)")
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "History"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            boxes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            self.saveBoxes()
        }
        else if editingStyle == .insert {
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
