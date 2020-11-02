

//
//  ViewControllerHelper.swift
//  English Flashcards
//
//  Created by QUANG on 2/27/17.
//  Copyright © 2017 QUANG INDUSTRIES. All rights reserved.
//

import UIKit
import ChameleonFramework

extension HomeController {
    //Setup rounded boarder of multiple views
    func updateUI() {
        //wordsField.backgroundColor = UIColor.init(red: 55/255.0, green: 139/255.0, blue: 128/255.0, alpha: 1.0)
        //Input View
        wordsField.layer.cornerRadius = 10.0
        wordsField.layer.shadowColor = UIColor.blue.withAlphaComponent(0.2).cgColor
        wordsField.layer.shadowOffset = CGSize(width: 0, height: 0)
        wordsField.layer.shadowOpacity = 0.8
        
        //Button
        btnCreateOutlet.layer.cornerRadius = 10.0
        btnCreateOutlet.layer.shadowColor = UIColor.blue.withAlphaComponent(0.2).cgColor
        btnCreateOutlet.layer.shadowOffset = CGSize(width: 0, height: 0)
        btnCreateOutlet.layer.shadowOpacity = 0.8
        
        //Table View
        tableOfBoxes.layer.cornerRadius = 10.0
        tableOfBoxes.layer.shadowColor = UIColor.blue.withAlphaComponent(0.2).cgColor
        tableOfBoxes.layer.shadowOffset = CGSize(width: 0, height: 0)
        tableOfBoxes.layer.shadowOpacity = 0.8
        
        let isRandomOn = defaults.bool(forKey: defaultsKeys.isRandomOn)
        
        if isRandomOn {
            DispatchQueue.main.async {
                self.wordsField.backgroundColor = RandomFlatColor()
                self.wordsField.textColor = ContrastColorOf(self.wordsField.backgroundColor!, returnFlat: true)
                
                self.btnCreateOutlet.backgroundColor = RandomFlatColor()
                self.btnCreateOutlet.tintColor = ContrastColorOf(self.btnCreateOutlet.backgroundColor!, returnFlat: true)
                
                self.navigationController?.navigationBar.barTintColor = RandomFlatColor()
                self.btnSettingsOutlet.tintColor = ContrastColorOf((self.navigationController?.navigationBar.barTintColor)!, returnFlat: true)
                self.btnClearOutlet.tintColor = self.btnSettingsOutlet.tintColor
                self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: self.btnClearOutlet.tintColor!]
                
                self.tableOfBoxes.backgroundColor = RandomFlatColor()
                
                self.view.backgroundColor = self.wordsField.textColor
            }
        }
    }
}
