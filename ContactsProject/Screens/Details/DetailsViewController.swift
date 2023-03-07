//
//  DetailsViewController.swift
//  ContactsProject
//
//  Created by user on 28.02.2023.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var details: [Contact]
    
    init(contacts: [Contact]) {
        self.details = contacts
        super.init(nibName: "DetailsViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib.init(nibName: "DetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "detailsIdentifier")
    }
}

// MARK: - UITableViewDataSource

extension DetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return details.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DetailsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "detailsIdentifier", for: indexPath) as! DetailsTableViewCell
        let contact = details[indexPath.row]
        cell.configure(with: contact)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension DetailsViewController: UITableViewDelegate {

}
