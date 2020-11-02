//
//  BoxCell.swift
//  English Flashcards
//
//  Created by Quang Luong on 11/1/20.
//

import UIKit

class BoxCell: UITableViewCell {
    
    //MARK: Outlets
    @IBOutlet weak var placeholderView: UIView!
    @IBOutlet weak var boxName: UILabel!

    //MARK: Defaults
    override func awakeFromNib() {
        super.awakeFromNib()
        updateUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    //Private Methods
    func updateUI() {
        placeholderView.layer.cornerRadius = 10.0
        placeholderView.layer.shadowColor = UIColor.blue.withAlphaComponent(0.2).cgColor
        placeholderView.layer.shadowOffset = CGSize.zero
        placeholderView.layer.shadowOpacity = 0.8
        placeholderView.layer.shadowPath = UIBezierPath(rect: placeholderView.bounds).cgPath
    }
}
