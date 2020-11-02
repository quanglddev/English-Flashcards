//
//  HomeControllerTextViewHelper.swift
//  English Flashcards
//
//  Created by QUANG on 3/1/17.
//  Copyright © 2017 QUANG INDUSTRIES. All rights reserved.
//

import UIKit

extension HomeController: UITextViewDelegate {
    func setupInputView() {
        wordsField.textContainer.maximumNumberOfLines = 60
        wordsField.textContainer.lineBreakMode = .byWordWrapping
        
        wordsField.delegate = self
    }
    
    //MARK: UITextFieldDelegate
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.title = "\(wordsField.numberOfLines()) Word(s)"
        
        if !wordsField.text.isEmpty {
            defaults.set(wordsField.text, forKey: defaultsKeys.lastText)
        }
    }

}
