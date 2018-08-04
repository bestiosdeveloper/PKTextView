//
//  PKTextView.swift
//  PKTextView
//
//  Created by Pramod Kumar on 11/05/16.
//  Copyright © 2016 Pramod Kumar. All rights reserved.
//

import UIKit

class PKOptionsListCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height / 2.0
        self.profileImageView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
