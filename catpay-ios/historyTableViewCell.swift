//
//  historyTableViewCell.swift
//  catpay-ios
//
//  Created by Mobile Dev 01 on 6/22/17.
//  Copyright © 2017 Technifiser. All rights reserved.
//

import UIKit

class historyTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var concept: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var mount: UILabel!
    @IBOutlet weak var state: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
