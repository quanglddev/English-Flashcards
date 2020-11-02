//
//  HCSegueHelper.swift
//  English Flashcards
//
//  Created by QUANG on 3/1/17.
//  Copyright © 2017 QUANG INDUSTRIES. All rights reserved.
//

import UIKit

extension HomeController: UINavigationControllerDelegate {
    
    //MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            case "ShowDetail":
                guard let detailCardTVC = segue.destination as? DetailCardTVC else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
                
                guard let selectedBoxCell = sender as? BoxCell else {
                    fatalError("Unexpected sender: \(String(describing: sender))")
                }
                
                guard let indexPath = tableOfBoxes.indexPath(for: selectedBoxCell) else {
                    fatalError("The selected cell is not being displayed by the table")
                }
                
                let selectedBox = boxes[indexPath.row]
                detailCardTVC.box = selectedBox
            default:
                fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
}
