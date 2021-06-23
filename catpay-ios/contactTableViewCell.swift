//
//  contactTableViewCell.swift
//  catpay-ios
//
//  Created by Juan Felipe Torres on 5/01/21.
//  Copyright © 2021 Technifiser. All rights reserved.
//

import UIKit

class contactTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nombreContactoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
