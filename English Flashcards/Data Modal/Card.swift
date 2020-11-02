//
//  Card.swift
//  English Flashcards
//
//  Created by Quang Luong on 11/1/20.
//

import UIKit
import os.log

class Card: NSObject, NSCoding {
    
    //MARK: Types
    struct PropertyKey {
        static let word = "word"
        static let definition = "definition"
        static let example = "example"
        static let lexicalCategory = "lexicalCategory"
        static let phoneticSpelling = "phoneticSpelling"
        static let audioFile = "audioFile"
        static let image = "image"
        static let audioURL = "audioURL"
    }
    
    //MARK: Properties
    var word: String
    var definition: String
    var example: String
    var lexicalCategory: String
    var phoneticSpelling: String
    var audioFile: String
    var audioURL: URL?
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("Card")
    
    //MARK: Initialization
    init?(word: String, definition: String, example: String, lexicalCategory: String, phoneticSpelling: String, audioFile: String, audioURL: URL?) {
        
        // Initialization should fail if there is no name or if the rating is negative.
        guard !word.isEmpty && !definition.isEmpty && !example.isEmpty && !lexicalCategory.isEmpty && !phoneticSpelling.isEmpty && !audioFile.isEmpty else {
            return nil
        }
        
        self.word = word
        self.definition = definition
        self.example = example
        self.lexicalCategory = lexicalCategory
        self.phoneticSpelling = phoneticSpelling
        self.audioFile = audioFile
        self.audioURL = audioURL
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(word, forKey: PropertyKey.word)
        aCoder.encode(definition, forKey: PropertyKey.definition)
        aCoder.encode(example, forKey: PropertyKey.example)
        aCoder.encode(lexicalCategory, forKey: PropertyKey.lexicalCategory)
        aCoder.encode(phoneticSpelling, forKey: PropertyKey.phoneticSpelling)
        aCoder.encode(audioFile, forKey: PropertyKey.audioFile)
        aCoder.encode(audioURL, forKey: PropertyKey.audioURL)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // The word is required. If we cannot decode a name string, the initializer should fail.
        guard let word = aDecoder.decodeObject(forKey: PropertyKey.word) as? String else {
            os_log("Unable to decode the word.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let definition = aDecoder.decodeObject(forKey: PropertyKey.definition) as? String else {
            os_log("Unable to decode the definition.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let example = aDecoder.decodeObject(forKey: PropertyKey.example) as? String else {
            os_log("Unable to decode the example.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let lexicalCategory = aDecoder.decodeObject(forKey: PropertyKey.lexicalCategory) as? String else {
            os_log("Unable to decode the lexicalCategory.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let phoneticSpelling = aDecoder.decodeObject(forKey: PropertyKey.phoneticSpelling) as? String else {
            os_log("Unable to decode the phoneticSpelling.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let audioFile = aDecoder.decodeObject(forKey: PropertyKey.audioFile) as? String else {
            os_log("Unable to decode the audioFile.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Because audioURL is an optional property of Task, just use conditional cast.
        let audioURL = aDecoder.decodeObject(forKey: PropertyKey.audioURL) as? URL
        
        // Must call designated initializer.
        self.init(word: word, definition: definition, example: example, lexicalCategory: lexicalCategory, phoneticSpelling: phoneticSpelling, audioFile: audioFile, audioURL: audioURL)
    }
}
