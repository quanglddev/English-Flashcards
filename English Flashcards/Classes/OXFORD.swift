//
//  OXFORD.swift
//  English Flashcards
//
//  Created by Quang Luong on 11/1/20.
//

import UIKit
import SwiftyJSON
import os.log

class OXFORD {
    var boxes = [Box]()
    var cards = [Card]()
    
    let defaults = UserDefaults.standard
    
    struct defaultsKeys {
        static let taskTerminated = "taskTerminated"
    }
    
    // Please sign up here to get your own credentials: https://developer.oxforddictionaries.com/
    let appId = "YOUR_APP_ID"
    let appKey = "YOUR_APP_KEY"
    let language = "en"
    
    func getOxfordDataFor(boxName: String, words: [String], totalWords: Int) {
        
        var definition: String = ""
        var example: String = ""
        var lexicalCategory: String = ""
        var phoneticSpelling: String = ""
        var audioFile: String = ""
        var audioURL: URL?
        
        if words.count > 0 {
            for word in words {
                let word_id = word.lowercased() //word id is case sensitive and lowercase is required
                let url = URL(string: "https://od-api.oxforddictionaries.com/api/v2/entries/\(language)/\(word_id)")!
                var request = URLRequest(url: url)
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                request.addValue(appId, forHTTPHeaderField: "app_id")
                request.addValue(appKey, forHTTPHeaderField: "app_key")
                
                let session = URLSession.shared
                session.dataTask(with: request, completionHandler: { data, response, error in
                    if let _ = response, let data = data {
                        
                        let json = try! JSON(data: data)
                        
                        if let gotDefinition = json["results"][0]["lexicalEntries"][0]["entries"][0]["senses"][0]["definitions"][0].string {
                            print(gotDefinition)
                            definition = gotDefinition
                        }
                        else {
                            if let gotDefinition = json["results"][0]["lexicalEntries"][1]["entries"][0]["senses"][0]["definitions"][0].string {
                                definition = gotDefinition
                            }
                            else {
                                definition = "No definition found. 😬"
                            }
                        }
                        
                        if let gotExample = json["results"][0]["lexicalEntries"][0]["entries"][0]["senses"][0]["examples"][0]["text"].string {
                            print(gotExample)
                            example = gotExample
                        }
                        else {
                            if let gotExample = json["results"][0]["lexicalEntries"][1]["entries"][0]["senses"][0]["examples"][0]["text"].string {
                                print(gotExample)
                                example = gotExample
                            }
                            else {
                                example = "No example found. 😬"
                            }
                        }
                        
                        if let gotLexicalCategory = json["results"][0]["lexicalEntries"][0]["lexicalCategory"]["text"].string {
                            print(gotLexicalCategory)
                            lexicalCategory = gotLexicalCategory
                        }
                        else {
                            lexicalCategory = "No lexical category found. 😬"
                        }
                        
                        if let gotPhoneticSpelling = json["results"][0]["lexicalEntries"][0]["entries"][0]["pronunciations"][0]["phoneticSpelling"].string {
                            print(gotPhoneticSpelling)
                            phoneticSpelling = gotPhoneticSpelling
                        }
                        else {
                            phoneticSpelling = "No phonetic spelling found. 😬"
                        }
                        
                        if let gotAudioFile = json["results"][0]["lexicalEntries"][0]["entries"][0]["pronunciations"][0]["audioFile"].string {
                            print(gotAudioFile)
                            audioFile = gotAudioFile
                            
                        }
                        else {
                            if let gotAudioFile = json["results"][0]["lexicalEntries"][0]["pronunciations"][0]["audioFile"].string {
                                print(gotAudioFile)
                                audioFile = gotAudioFile
                            }
                            else {
                                audioFile = "No audio file found. 😬"
                            }
                        }
                        
                        if self.defaults.bool(forKey: defaultsKeys.taskTerminated) {
                            self.cards.removeAll()
                            self.saveCards()
                        }
                        //else {
                        //    self.loadCards()
                        //}
                        
                        if self.cards.count > totalWords {
                            self.cards.removeAll()
                            self.saveCards()
                        }
                        
                        self.cards.append(Card(word: word,
                                               definition: definition,
                                               example: example,
                                               lexicalCategory: lexicalCategory,
                                               phoneticSpelling: phoneticSpelling,
                                               audioFile: audioFile,
                                               audioURL: audioURL)!)
                        self.saveCards()
                        
                        print("\(self.cards.count) - \(totalWords)")
                        if self.cards.count == totalWords {
                            
                            //Load data before adding
                            if let savedBoxes = self.loadBoxes() {
                                self.boxes = savedBoxes
                            }
                            
                            self.cards.reverse()
                            
                            self.boxes.insert(Box(name: boxName, cards: self.cards)!, at: 0) //Insert at the beginning or array (to make it history - like)
                            self.saveBoxes()
                            
                            self.cards.removeAll()
                            self.saveCards()
                        }
                        
                    } else {
                        print(error ?? "No error (Should never happen)")
                        print(NSString.init(data: data!, encoding: String.Encoding.utf8.rawValue) ?? "(Should never happen)")
                    }
                }).resume()
            }
        }
    }
    
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
