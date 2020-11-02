//
//  AppStateHelper.swift
//  English Flashcards
//
//  Created by QUANG on 3/1/17.
//  Copyright © 2017 QUANG INDUSTRIES. All rights reserved.
//

import UIKit

extension HomeController {
    func setupAppStateObserver() {
        
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appWillTerminate), name: UIApplication.willTerminateNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func appMovedToBackground() {
        print("App moved to background!")
        if !wordsField.text.isEmpty {
            defaults.set(wordsField.text, forKey: defaultsKeys.lastText)
        }
        
        if taskIsRunning {
            defaults.set(true, forKey: defaultsKeys.taskTerminated)
            taskIsTerminated = true
        }
    }
    
    @objc func appWillEnterForeground() {
        if taskIsRunning {
            taskIsTerminated = false
            self.defaults.set(false, forKey: defaultsKeys.taskTerminated)
        }
    }
    
    @objc func appWillTerminate() {
        print("App will be terminated soon!")
        if !wordsField.text.isEmpty {
            defaults.set(wordsField.text, forKey: defaultsKeys.lastText)
        }
    }
}
