//
//  SettingsTVC.swift
//  English Flashcards
//
//  Created by Quang Luong on 11/1/20.
//

import UIKit
import MessageUI
import SCLAlertView

class SettingsTVC: UITableViewController, MFMailComposeViewControllerDelegate {
    
    //MARK: Properties
    let defaults = UserDefaults.standard
    
    struct defaultsKeys {
        static let isRandomOn = "isRandomOn"
    }
    
    //MARK: Outlets
    @IBOutlet weak var swtRandomColorOutlet: UISwitch!
    @IBOutlet weak var lblVersion: UILabel!
    
    //MARK: Actions
    @IBAction func swtRandomColorAction(_ sender: UISwitch) {
        defaults.setValue(swtRandomColorOutlet.isOn, forKey: defaultsKeys.isRandomOn)
    }
    
    @IBAction func navigationSave(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnClearAction(_ sender: UIButton) {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        
        let alertView = SCLAlertView(appearance: appearance)
        alertView.addButton("I Understand") {
            self.clearAll()
        }
        alertView.addButton("Cancel") {
            print("Abort Clear Data.")
            let timeoutAction: SCLAlertView.SCLTimeoutConfiguration.ActionType = {
                // action here
            }
            SCLAlertView().showTitle(
                "👍", // Title of view
                subTitle: "You are safe now.", timeout: SCLAlertView.SCLTimeoutConfiguration(timeoutValue: 3.0, timeoutAction: timeoutAction), // String of view
                completeText: "Thanks", // Optional button value, default: ""
                style: .notice, // Styles - see below.
                colorStyle: 0xA429FF,
                colorTextButton: 0xFFFFFF
            )
        }
        alertView.showNotice("WARNING!!!", subTitle: "All data won't be able to recover.")
    }
    
    @IBAction func btnReviewAction(_ sender: UIButton) {
        if let url = URL(string: "https://www.facebook.com/crzQag") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    @IBAction func btnReportAction(_ sender: UIButton) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    //MARK: Defaults
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Update build version
        updateBuild()
        
        //Update save data switch
        loadSavedData()
    }
    
    //MARK: Private Methods
    func loadSavedData() {
        swtRandomColorOutlet.isOn = defaults.bool(forKey: defaultsKeys.isRandomOn)
    }
    
    func updateBuild() {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            self.lblVersion.text = "\(version)."
        }
        else {
            self.lblVersion.text = "Unknown 😬."
        }
    }
    
    func clearAll() {
        var boxes = [Box]()
        boxes.removeAll()
        
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(boxes, toFile: Box.ArchiveURL.path)
        let timeoutAction: SCLAlertView.SCLTimeoutConfiguration.ActionType = {
            // action here
        }
        
        if isSuccessfulSave {
                SCLAlertView().showTitle(
                "Done! 👍", // Title of view
                    subTitle: "All your data are cleared.", timeout: SCLAlertView.SCLTimeoutConfiguration(timeoutValue: 10.0, timeoutAction: timeoutAction), // String of view
                completeText: "Thanks", // Optional button value, default: ""
                style: .success, // Styles - see below.
                colorStyle: 0xA429FF,
                colorTextButton: 0xFFFFFF
            )
            print("Data successfully cleared.")
            
        } else {
            SCLAlertView().showTitle(
                "Hmmm... 😱", // Title of view
                subTitle: "I somehow failed, plese try reopening the app. 😭", timeout: SCLAlertView.SCLTimeoutConfiguration(timeoutValue: 10.0, timeoutAction: timeoutAction), // String of view
                completeText: "OK", // Optional button value, default: ""
                style: .error, // Styles - see below.
                colorStyle: 0xA429FF,
                colorTextButton: 0xFFFFFF
            )
            print("Failed to clear data...")
        }
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(title: "Mail couldn't be sent.", message: "Your device could not send e-mail. Please check e-mail configuration and try again.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        sendMailErrorAlert.addAction(action)
        present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["quangscorpio@gmail.com"])
        mailComposerVC.setSubject("[BUG] ENGLISH FLASHCARDS")
        mailComposerVC.setMessageBody("Please type the bug down below, please be specific and clear...", isHTML: false)
        
        return mailComposerVC
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
