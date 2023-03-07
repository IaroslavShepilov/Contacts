//
//  ContactsViewController.swift
//  ContactsProject
//
//  Created by user on 28.02.2023.
//

import UIKit
import Contacts

class ContactsViewController: UIViewController {

    // MARK: - Properties
    
    private var model = ContactsViewModel()
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Контакты"

        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.register(UINib.init(nibName: "ContactsTableViewCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifier")
                
        requestAccess { [weak self] accessGranted in
            if accessGranted {
                self?.model.filterArray()
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
    }
}


// MARK: - UITableViewDataSource

extension ContactsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ContactsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! ContactsTableViewCell
        
        cell.configure(with: model.dataSource[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ContactsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = model.dataSource[indexPath.row]
        let detailsVC = DetailsViewController(contacts: section.items)
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}

// MARK: - Private methods

private extension ContactsViewController {
    
    func requestAccess(completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized:
            completionHandler(true)
        case .denied:
            showSettingsAlert(completionHandler)
        case .restricted, .notDetermined:
            CNContactStore().requestAccess(for: .contacts) { granted, error in
                if granted {
                    completionHandler(true)
                } else {
                    DispatchQueue.main.async {
                        self.showSettingsAlert(completionHandler)
                    }
                }
            }
        @unknown default:
            fatalError("Unexpected type")
        }
    }

    private func showSettingsAlert(_ completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        let alert = UIAlertController(
            title: nil,
            message: "This app requires access to Contacts to proceed. Go to Settings to grant access.",
            preferredStyle: .alert)
        if  let settings = URL(string: UIApplication.openSettingsURLString),
            UIApplication.shared.canOpenURL(settings) {
            alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { action in
                completionHandler(false)
                UIApplication.shared.open(settings)
            })
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in
            completionHandler(false)
        })
        present(alert, animated: true)
    }
}

