//
//  CardCell.swift
//  English Flashcards
//
//  Created by Quang Luong on 11/1/20.
//

import UIKit
import ChameleonFramework
import AVFoundation
import os.log

class CardCell: UITableViewCell, AVAudioPlayerDelegate, AVSpeechSynthesizerDelegate {
    
    //MARK: Properties
    let fileManager = FileManager.default
    
    let speechSynthesizer = AVSpeechSynthesizer()
    
    var playingURL: URL?
    
    var previousSelectedRange: NSRange!
    
    var spokenTextLengths: Int = 0
    var totalUtterances: Int! = 0
    var currentUtterance: Int! = 0
    
    var isLblDefinitionTapped = false
    
    //MARK: Outlets
    @IBOutlet weak var placeholderView: UIView!
    @IBOutlet weak var lblDefinition: UITextView!
    @IBOutlet weak var lblExample: UITextView!
    @IBOutlet weak var btnListenOutlet: UIButton!
    @IBOutlet weak var lblCategory: UITextField!
    @IBOutlet weak var lblSpelling: UITextField!
    @IBOutlet weak var lblWord: UITextField!
    @IBOutlet weak var lblAudioPath: UILabel!
    
    //MARK: Default
    override func awakeFromNib() {
        super.awakeFromNib()
        
        updateUI()
        
        let wordTap = UITapGestureRecognizer(target: self, action: #selector(self.wordTapped))
        self.lblWord.addGestureRecognizer(wordTap)
        
        let definitionTap = UITapGestureRecognizer(target: self, action: #selector(self.definitionTapped))
        self.lblDefinition.addGestureRecognizer(definitionTap)
        
        let exampleTap = UITapGestureRecognizer(target: self, action: #selector(self.exampleTapped))
        self.lblExample.addGestureRecognizer(exampleTap)
        
        setInitialFontAttribute()
        
        speechSynthesizer.delegate = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //MARK: Actions
    @IBAction func btnListenAction(_ sender: UIButton) {
        isLblDefinitionTapped = false
        if let url = URL(string: btnListenOutlet.title(for: .normal)!) {
            downloadFileFromURL(url: url)
        }
    }
    
    //Private Methods
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        spokenTextLengths = spokenTextLengths + utterance.speechString.count + 1
        
        if currentUtterance == totalUtterances {
            unselectLastWord()
            previousSelectedRange = nil
        }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        
        if isLblDefinitionTapped == true {
            
            
            // Determine the current range in the whole text (all utterances), not just the current one.
            let rangeInTotalText = NSMakeRange(spokenTextLengths + characterRange.location, characterRange.length)
            
            // Select the specified range in the textfield.
            lblDefinition.selectedRange = rangeInTotalText
            
            // Store temporarily the current font attribute of the selected text.
            let currentAttributes = lblDefinition.attributedText.attributes(at: rangeInTotalText.location, effectiveRange: nil)
            let fontAttribute: AnyObject? = currentAttributes[NSAttributedString.Key.font] as AnyObject?
            
            // Assign the selected text to a mutable attributed string.
            let attributedString = NSMutableAttributedString(string: lblDefinition.attributedText.attributedSubstring(from: rangeInTotalText).string)
            
            // Make the text of the selected area orange by specifying a new attribute.
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: RandomFlatColor(), range: NSMakeRange(0, attributedString.length))
            
            // Make sure that the text will keep the original font by setting it as an attribute.
            attributedString.addAttribute(NSAttributedString.Key.font, value: fontAttribute!, range: NSMakeRange(0, attributedString.string.count))
            
            // In case the selected word is not visible scroll a bit to fix this.
            lblDefinition.scrollRangeToVisible(rangeInTotalText)
            
            // Begin editing the text storage.
            lblDefinition.textStorage.beginEditing()
            
            // Replace the selected text with the new one having the orange color attribute.
            lblDefinition.textStorage.replaceCharacters(in: rangeInTotalText, with: attributedString)
            
            // If there was another highlighted word previously (orange text color), then do exactly the same things as above and change the foreground color to black.
            if let previousRange = previousSelectedRange {
                let previousAttributedText = NSMutableAttributedString(string: lblDefinition.attributedText.attributedSubstring(from: previousRange).string)
                previousAttributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: ContrastColorOf(lblDefinition.backgroundColor!, returnFlat: true) , range: NSMakeRange(0, previousAttributedText.length))
                previousAttributedText.addAttribute(NSAttributedString.Key.font, value: fontAttribute!, range: NSMakeRange(0, previousAttributedText.length))
                
                lblDefinition.textStorage.replaceCharacters(in: previousRange, with: previousAttributedText)
            }
            
            // End editing the text storage.
            lblDefinition.textStorage.endEditing()
            
            // Keep the currently selected range so as to remove the orange text color next.
            previousSelectedRange = rangeInTotalText
        }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        currentUtterance = currentUtterance + 1
    }
    
    func unselectLastWord() {
        if let selectedRange = previousSelectedRange {
            // Get the attributes of the last selected attributed word.
            let currentAttributes = lblDefinition.attributedText.attributes(at: selectedRange.location, effectiveRange: nil)
            // Keep the font attribute.
            let fontAttribute: AnyObject? = currentAttributes[NSAttributedString.Key.font] as AnyObject?
            
            // Create a new mutable attributed string using the last selected word.
            let attributedWord = NSMutableAttributedString(string: lblDefinition.attributedText.attributedSubstring(from: selectedRange).string)
            
            // Set the previous font attribute, and make the foreground color black.
            attributedWord.addAttribute(NSAttributedString.Key.foregroundColor, value: ContrastColorOf(lblDefinition.backgroundColor!, returnFlat: true), range: NSMakeRange(0, attributedWord.length))
            attributedWord.addAttribute(NSAttributedString.Key.font, value: fontAttribute!, range: NSMakeRange(0, attributedWord.length))
            
            // Update the text storage property and replace the last selected word with the new attributed string.
            lblDefinition.textStorage.beginEditing()
            lblDefinition.textStorage.replaceCharacters(in: selectedRange, with: attributedWord)
            lblDefinition.textStorage.endEditing()
        }
    }
    
    func setInitialFontAttribute() {
        let rangeOfWholeText = NSMakeRange(0, (lblDefinition.text?.count)!)
        let attributedText = NSMutableAttributedString(string: lblDefinition.text!)
        attributedText.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Helvetica", size: 16.0)!, range: rangeOfWholeText)
        lblDefinition.textStorage.beginEditing()
        lblDefinition.textStorage.replaceCharacters(in: rangeOfWholeText, with: attributedText)
        lblDefinition.textStorage.endEditing()
    }
    
    @objc func wordTapped() {
        if !speechSynthesizer.isSpeaking {
            isLblDefinitionTapped = false
            speak(word: lblWord.text!)
        }
        else {
            stopSpeaking()
        }
    }
    
    @objc func definitionTapped() {
        if !speechSynthesizer.isSpeaking {
            isLblDefinitionTapped = true
            speak(word: lblDefinition.text!)
        }
        else {
            stopSpeaking()
        }
    }
    
    @objc func exampleTapped() {
        if !speechSynthesizer.isSpeaking {
            isLblDefinitionTapped = false
            speak(word: lblExample.text!)
        }
        else {
            stopSpeaking()
        }
    }
    
    func speak(word: String) {
        let textParagraphs = lblDefinition.text.components(separatedBy: "\n")
        totalUtterances = textParagraphs.count
        
        currentUtterance = 0
        
        spokenTextLengths = 0
        
        let speechUtterance = AVSpeechUtterance(string: word)
        
        speechSynthesizer.speak(speechUtterance)
    }
    
    func stopSpeaking() {
        speechSynthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
    }
    
    private func downloadFileFromURL(url: URL) {
        var downloadTask = URLSessionDownloadTask()
        downloadTask = URLSession.shared.downloadTask(with: url, completionHandler: { (URL, response, error) -> Void in
            if error == nil {
                self.play(url: URL!)
            }
            else {
                self.speak(word: self.lblWord.text!)
            }
        })
        downloadTask.resume()
    }
    
    
    var player = AVAudioPlayer()
    func play(url: URL) {
        print("playing \(url)")
        playingURL = url
        
        do {
            self.player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            player.volume = 1.0
            player.play()
        } catch let error as NSError {
            //self.player = nil
            print(error.localizedDescription)
        } catch {
            print("AVAudioPlayer init failed")
        }
        
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        btnListenOutlet.setTitle(String(describing: playingURL), for: .normal)
        if flag == true {
            do {
                try (fileManager.removeItem(at: playingURL!))
            }
            catch {
                
            }
            os_log("Remove success", log: OSLog.default, type: .debug)
        }
    }
    
    func updateUI() {
        /*
         placeholderView.layer.cornerRadius = 10.0
         placeholderView.layer.shadowColor = UIColor.blue.withAlphaComponent(0.2).cgColor
         placeholderView.layer.shadowOffset = CGSize.zero
         placeholderView.layer.shadowOpacity = 0.8
         placeholderView.layer.shadowPath = UIBezierPath(rect: placeholderView.bounds).cgPath*/
        
        for view in self.contentView.subviews {
            view.layer.cornerRadius = 10.0
            view.layer.shadowColor = UIColor.blue.withAlphaComponent(0.2).cgColor
            view.layer.shadowOffset = CGSize.zero
            view.layer.shadowOpacity = 0.8
            view.layer.shadowPath = UIBezierPath(rect: view.bounds).cgPath
        }
        
        for case let textField as UITextField in self.placeholderView.subviews {
            textField.layer.cornerRadius = 10.0
            textField.layer.shadowColor = UIColor.blue.withAlphaComponent(0.2).cgColor
            textField.layer.shadowOffset = CGSize.zero
            textField.layer.shadowOpacity = 0.8
            textField.layer.shadowPath = UIBezierPath(rect: textField.bounds).cgPath
            textField.backgroundColor = RandomFlatColor()
            textField.textColor = ContrastColorOf(textField.backgroundColor!, returnFlat: true)
        }
        
        for case let textView as UITextView in self.placeholderView.subviews {
            textView.layer.cornerRadius = 10.0
            textView.layer.shadowColor = UIColor.blue.withAlphaComponent(0.2).cgColor
            textView.layer.shadowOffset = CGSize.zero
            textView.layer.shadowOpacity = 0.8
            textView.layer.shadowPath = UIBezierPath(rect: textView.bounds).cgPath
            textView.backgroundColor = RandomFlatColor()
            textView.textColor = ContrastColorOf(textView.backgroundColor!, returnFlat: true)
        }
        
        for case let button as UIButton in self.placeholderView.subviews {
            button.layer.cornerRadius = 10.0
            button.layer.shadowColor = UIColor.blue.withAlphaComponent(0.2).cgColor
            button.layer.shadowOffset = CGSize.zero
            button.layer.shadowOpacity = 0.8
            button.layer.shadowPath = UIBezierPath(rect: button.bounds).cgPath
            button.backgroundColor = RandomFlatColor()
            button.tintColor = ContrastColorOf(button.backgroundColor!, returnFlat: true)
        }
    }
}
