//
//  CloudKitManager.swift
//  GamesAndThings
//
//  Created by Adam Jolicoeur on 3/28/25.
//  Copyright © 2025 AdamJolicoeur. All rights reserved.
//


import CloudKit

class CloudKitManager {
    
    static let shared = CloudKitManager()
    
    let container = CKContainer.default()
    let publicDatabase: CKDatabase
    let privateDatabase: CKDatabase
    
    private init() {
        publicDatabase = container.publicCloudDatabase
        privateDatabase = container.privateCloudDatabase
    }
    
    // MARK: - Account Availability
    
    func checkAccountStatus(completion: @escaping (CKAccountStatus, Error?) -> Void) {
        container.accountStatus { accountStatus, error in
            DispatchQueue.main.async {
                completion(accountStatus, error)
            }
        }
    }
    
    func handleAccountStatus(accountStatus: CKAccountStatus, viewController: UIViewController) {
        if accountStatus == .noAccount {
            DispatchQueue.main.async {
                let message =
                """
                Sign in to your iCloud account to write records.
                On the Home screen, launch Settings, tap Sign in to your
                iPhone/iPad, and enter your Apple ID. Turn iCloud Drive on.
                """
                let alert = UIAlertController(
                    title: "Sign in to iCloud",
                    message: message,
                    preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                viewController.present(alert, animated: true)
            }
        }
    }
    
    // MARK: - Saving Records
    
    func save(record: CKRecord, database: CKDatabase, completion: @escaping (Result<CKRecord, Error>) -> Void) {
        database.save(record) { savedRecord, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    print("CloudKit save error: \(error.localizedDescription)")
                } else if let savedRecord = savedRecord {
                    completion(.success(savedRecord))
                    print("CloudKit record saved: \(savedRecord.recordID)")
                }
            }
        }
    }
    
    // MARK: - Fetching Records
    
    func fetch(recordID: CKRecord.ID, database: CKDatabase, completion: @escaping (Result<CKRecord, Error>) -> Void) {
        database.fetch(withRecordID: recordID) { fetchedRecord, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    print("CloudKit fetch error: \(error.localizedDescription)")
                } else if let fetchedRecord = fetchedRecord {
                    completion(.success(fetchedRecord))
                }
            }
        }
    }
    
    func fetchAll(recordType: String, database: CKDatabase, completion: @escaping (Result<[CKRecord], Error>) -> Void) {
        let query = CKQuery(recordType: recordType, predicate: NSPredicate(value: true))
        database.perform(query, inZoneWith: nil) { records, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    print("CloudKit fetchAll error: \(error.localizedDescription)")
                } else if let records = records {
                    completion(.success(records))
                } else {
                    completion(.success([])) // No records found
                }
            }
        }
    }
    
    // MARK: - Subscriptions (for real-time updates)
    
    func subscribeToChanges(recordType: String, database: CKDatabase, subscriptionID: String, completion: @escaping (Result<CKSubscription, Error>) -> Void) {
        let predicate = NSPredicate(value: true)
        let subscription = CKQuerySubscription(recordType: recordType, predicate: predicate, subscriptionID: subscriptionID, options: .firesOnRecordCreation)
        
        let notificationInfo = CKSubscription.NotificationInfo()
        notificationInfo.shouldSendContentAvailable = true // Wake up the app in the background
        
        subscription.notificationInfo = notificationInfo
        
        database.save(subscription) { savedSubscription, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    print("CloudKit subscription error: \(error.localizedDescription)")
                } else if let savedSubscription = savedSubscription {
                    completion(.success(savedSubscription))
                    print("Subscribed to \(recordType) changes.")
                }
            }
        }
    }
    
    func unsubscribe(subscriptionID: String, database: CKDatabase, completion: @escaping (Result<Void, Error>) -> Void) {
        database.delete(withSubscriptionID: subscriptionID) { _, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    print("CloudKit unsubscribe error: \(error.localizedDescription)")
                } else {
                    completion(.success(()))
                    print("Unsubscribed from \(subscriptionID).")
                }
            }
        }
    }
    
    func fetchAllSubscriptions(database: CKDatabase, completion: @escaping (Result<[CKSubscription], Error>) -> Void) {
        database.fetchAllSubscriptions { subscriptions, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    print("CloudKit fetchAllSubscriptions error: \(error.localizedDescription)")
                } else if let subscriptions = subscriptions {
                    completion(.success(subscriptions))
                } else {
                    completion(.success([]))
                }
            }
        }
    }
}
