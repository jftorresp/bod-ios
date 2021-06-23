//
//  contactPhonesTableViewCell.swift
//  catpay-ios
//
//  Created by Juan Felipe Torres on 6/01/21.
//  Copyright © 2021 Technifiser. All rights reserved.
//

import UIKit

class contactPhonesTableViewCell: UITableViewCell {

    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var deletePhoneBtn: UIButton!
    @IBOutlet weak var editPhoneBtn: UIButton!
    var editPhone = { }
    var deletePhone = { }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func editPhonePressed(_ sender: Any) {
        editPhone()
    }
    
    @IBAction func deletePhonePressed(_ sender: Any) {
        deletePhone()
    }

    func edit() {
        editPhone()
    }
    
    func delete() {
        deletePhone()
    }
}
