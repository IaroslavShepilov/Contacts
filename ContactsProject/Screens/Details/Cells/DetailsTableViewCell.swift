//
//  DetailsTableViewCell.swift
//  ContactsProject
//
//  Created by user on 28.02.2023.
//

import UIKit

class DetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var secondPhoneNumbers: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.isHidden = false
        emailLabel.isHidden = false
        phoneNumberLabel.isHidden = false
        secondPhoneNumbers.isHidden = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Methods
    
    func configure(with model: Contact) {

        if let email = model.email {
            emailLabel.text = email
        } else {
            emailLabel.isHidden = true
        }
        
        if let phone = model.phoneNumber {
            phoneNumberLabel.text = phone
        } else {
            phoneNumberLabel.isHidden = true
        }
        
        if let phone = model.secondPhoneNumbers {
            secondPhoneNumbers.text = phone
        } else {
            secondPhoneNumbers.isHidden = true
        }
        
        if let name = model.name {
            nameLabel.text = name
        } else {
            nameLabel.isHidden = true
        }
    }
}
