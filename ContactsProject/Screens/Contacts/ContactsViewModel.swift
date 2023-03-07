//
//  ContactsViewModel.swift
//  ContactsProject
//
//  Created by user on 28.02.2023.
//

import Foundation
import UIKit
import Contacts

struct Section {
    var title: String
    var icon: UIImage
    var items: [Contact]
}

struct Contact: Codable, Hashable {
    var name: String?
    var phoneNumber: String?
    var secondPhoneNumbers: String?
    var allPhonesCount: Int
    var email: String?
}

final class ContactsViewModel {
    
    // MARK: - Properties
    
    var dataSource = [Section]()
    
    // MARK: - Methods
    
    func getContacts() -> [CNContact] {
        let contactStore = CNContactStore()
        var results: [CNContact] = []
        var allContainers: [CNContainer] = []
        let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                           CNContactGivenNameKey,
                           CNContactFamilyNameKey,
                           CNContactEmailAddressesKey,
                           CNContactPhoneNumbersKey] as [Any]
        do {
            allContainers = try contactStore.containers(matching: nil)
        } catch {
            print("Error fetching containers")
        }
        
        for container in allContainers {
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
            do {
                let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                results.append(contentsOf: containerResults)
            } catch {
                print("Error fetching results for container")
            }
        }
        return results
    }
    
    func filterArray() {
        let remoteContacts = self.getContacts()
        let contacts = remoteContacts.map { remoteContact in
            var firstPhone: String?
            var secondPhone: String?
            let phones = remoteContact.phoneNumbers.map { $0.value.value(forKey: "stringValue") as? String }
            switch phones.count {
            case 1:
                firstPhone = phones.first ?? nil
            case 2:
                firstPhone = phones.first ?? nil
                secondPhone = phones.last ?? nil
            case let x where x > 2:
                firstPhone = phones.first ?? nil
                secondPhone = phones.last ?? nil
            default:
                break
            }
            let emails = remoteContact.emailAddresses.map { $0.value(forKey: "value") as? String }
            return Contact(
                name: "\(remoteContact.givenName) \(remoteContact.familyName)",
                phoneNumber: firstPhone,
                secondPhoneNumbers: secondPhone,
                allPhonesCount: remoteContact.phoneNumbers.count,
                email: emails.first ?? nil
            )
        }
        
        dataSource.append(
            Section(
                title: "Contacts",
                icon: UIImage(systemName: "person.crop.circle")!,
                items: contacts
            )
        )
        dataSource.append(
            Section(
                title: "Duplicate names",
                icon: UIImage(systemName: "person.3")!,
                items: contacts.duplicatesByName()
            )
        )
        dataSource.append(
            Section(
                title: "Duplicate numbers",
                icon: UIImage(systemName: "phone")!,
                items: contacts.duplicatesByNumber()
            )
        )
        dataSource.append(
            Section(
                title: "No name",
                icon: UIImage(systemName: "person.crop.circle.badge.questionmark.fill")!,
                items: contacts.filter { $0.name == nil || ($0.name?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? false) }
            )
        )
        dataSource.append(
            Section(
                title: "No numbers",
                icon: UIImage(systemName: "iphone.gen2.slash")!,
                items: contacts.filter { $0.phoneNumber == nil || ($0.name?.isEmpty ?? false) }
            )
        )
        dataSource.append(
            Section(
                title: "No email",
                icon: UIImage(systemName: "envelope")!,
                items: contacts.filter { $0.email == nil || ($0.email?.isEmpty ?? false) }
            )
        )
    }
}

// MARK: - Array Extension

extension Array where Element == Contact {
    func duplicatesByName() -> Array {
        let duplicates = Dictionary(grouping: self, by: \.name)
        return duplicates.filter { $1.count > 1 }.flatMap { $0.1 }
    }
    
    func duplicatesByNumber() -> Array {
        let duplicates = Dictionary(grouping: self, by: \.phoneNumber)
        return duplicates.filter { $1.count > 1 }.flatMap { $0.1 }
    }
}
