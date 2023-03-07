//
//  ContactsTableViewCell.swift
//  ContactsProject
//
//  Created by user on 28.02.2023.
//

import UIKit

class ContactsTableViewCell: UITableViewCell {

    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var contactsTypeLabel: UILabel!
    @IBOutlet weak var contactsTypeImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configure(with model: Section) {
        contactsTypeImageView.image = model.icon
        contactsTypeLabel.text = model.title
        countLabel.text = "\(model.items.count)"
    }
}
