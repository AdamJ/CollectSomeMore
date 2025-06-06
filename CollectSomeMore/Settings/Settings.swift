import SwiftUI
import SwiftData
import CloudKit

extension String {
    static var settingsUserNameKey : String { "settings.userName" }
//    static var settingsUserAddressKey : String { "settings.userAddress" }
//    static var settingsUserAdsEnabledKey : String { "settings.isAdsEnabled" }
//    static var adPrivacyTypeKey : String { "settings.adPrivacyType" }
    static var iCloudSyncEnabledKey : String { "settings.iCloudSyncEnabled" }
}

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @AppStorage(wrappedValue: "", .settingsUserNameKey)
    private var userName: String
//    @AppStorage(.settingsUserAddressKey)
//    private var userAddress: String = ""

//    @AppStorage(.settingsUserAdsEnabledKey)
//    private var isAdsEnabled: Bool = false
//
//    @AppStorage(.adPrivacyTypeKey)
//    private var adPrivacyType: AdPrivacyType = .noTracking

    @AppStorage(.iCloudSyncEnabledKey)
    private var iCloudSyncEnabled: Bool = true {
        didSet {
            handleiCloudSyncChange()
        }
    }

    @State private var showingAlert = false

    func getVersionNumber() -> String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        }
        return "Unknown"
    }
    func getBuildNumber() -> String {
        if let version = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            return version
        }
        return "Unknown"
    }
    func getCopyright() -> String {
        "© 2025 Adam Jolicoeur, All Rights Reserved"
    }
    func getPlatform() -> String {
        #if os(iOS)
        return "iOS"
        #elseif os(macOS)
        return "macOS"
        #else
        return "Unknown"
        #endif
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $userName)
//                    TextField("Address", text: $userAddress)
                } header: {
                    VStack(alignment: .center, spacing: Sizing.SpacerSmall) {
                        Text("Personalization")
                            .padding(.vertical, Sizing.SpacerXSmall)
                            .padding(.horizontal, Sizing.SpacerMedium)
                            .background(Colors.primaryMaterial)
                            .foregroundColor(Colors.inverseOnSurface)
                            .bodyBoldStyle()
                    }
                    .cornerRadius(Sizing.SpacerXSmall)
                }

//                Section {
//                    Toggle("Enable Ads", isOn: $isAdsEnabled)
//                } header: {
//                    Text("Advertising Policy")
//                }
//                .disabled(userName.isEmpty || userAddress.isEmpty)
//
//                if isAdsEnabled {
//                    Section {
//                        Picker("Select Your Policy", selection: $adPrivacyType) {
//                            ForEach(AdPrivacyType.allCases) { trackingPolicy in
//                                Text(trackingPolicy.rawValue)
//                            }
//                        }
//                    } header: {
//                        Text("Tracking Policy")
//                    }
//                }

                Section {
                    Toggle("Enable iCloud Sync", isOn: $iCloudSyncEnabled)
                        .alert(isPresented: $showingAlert) {
                            Alert(
                                title: Text("Disable iCloud Sync?"),
                                message: Text("Turning off iCloud Sync will remove all data from iCloud. Your local data will be kept. If you delete the app from your device without iCloud Sync enabled, all data will be removed."),
                                primaryButton: .destructive(Text("Disable")) {
                                    iCloudSyncEnabled = false
                                    deleteAllCloudKitData()
                                },
                                secondaryButton: .cancel(Text("Cancel")) {
                                    iCloudSyncEnabled = true
                                }
                            )
                        }
                } header: {
                    VStack(alignment: .center, spacing: Sizing.SpacerSmall) {
                        Text("iCloud Sync")
                            .padding(.vertical, Sizing.SpacerXSmall)
                            .padding(.horizontal, Sizing.SpacerMedium)
                            .background(Colors.primaryMaterial)
                            .foregroundColor(Colors.inverseOnSurface)
                            .bodyBoldStyle()
                    }
                    .cornerRadius(Sizing.SpacerXSmall)
                }

                Section {
                    VStack {
                        Text("Copyright \(Text("\(getCopyright())"))")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom, Sizing.SpacerSmall)
                        Text("Version: \(Text("\(getVersionNumber())"))")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom, Sizing.SpacerSmall)
                        Text("Build: \(Text("\(getBuildNumber())"))")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom, Sizing.SpacerSmall)
                        Text("Platform: \(Text("\(getPlatform())"))")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                } header: {
                    VStack(alignment: .center, spacing: Sizing.SpacerSmall) {
                        Text("About")
                            .padding(.vertical, Sizing.SpacerXSmall)
                            .padding(.horizontal, Sizing.SpacerMedium)
                            .background(Colors.primaryMaterial)
                            .foregroundColor(Colors.inverseOnSurface)
                            .bodyBoldStyle()
                    }
                    .cornerRadius(Sizing.SpacerXSmall)
                }

            }
            .bodyStyle()
            .navigationBarTitle("Settings")
        }
    }

    private func handleiCloudSyncChange() {
        if iCloudSyncEnabled {
            print("iCloud Sync is enabled")
            uploadAllDataToCloudKit()
        } else {
            showingAlert = true
        }
    }

    private func uploadAllDataToCloudKit() {
        do {
            let descriptor = FetchDescriptor<Item>()
            let items = try modelContext.fetch(descriptor)

            for item in items {
                let record = item.asCKRecord()
                saveRecordToCloudKit(record: record)
            }
        } catch {
            print("Failed to fetch items: \(error)")
        }
    }

    private func saveRecordToCloudKit(record: CKRecord) {
        let database = CKContainer.default().privateCloudDatabase

        database.save(record) { (savedRecord, error) in
            if let error = error {
                print("Error saving record: \(error.localizedDescription)")
            } else {
                print("Successfully saved record: \(record.recordID)")
            }
        }
    }

    private func deleteAllCloudKitData() {
        let database = CKContainer.default().privateCloudDatabase

        fetchAllCloudKitRecords(recordType: "Item") { records in
            for record in records {
                database.delete(withRecordID: record.recordID) { (_, error) in
                    if let error = error {
                        print("Error deleting record: \(error.localizedDescription)")
                    } else {
                        print("Successfully deleted record: \(record.recordID)")
                    }
                }
            }
        }
    }

    private func fetchAllCloudKitRecords(recordType: String, completion: @escaping @Sendable ([CKRecord] ) -> Void) {
        let database = CKContainer.default().privateCloudDatabase

        let query = CKQuery(recordType: recordType, predicate: NSPredicate(value: true))
        database.fetch(withQuery: query, inZoneWith: nil, desiredKeys: nil, resultsLimit: CKQueryOperation.maximumResults) { (result) in
            switch result {
            case .success(let queryResult):
                var records: [CKRecord] = []
                for recordResult in queryResult.matchResults {
                    switch recordResult.1 {
                    case .success(let record):
                        records.append(record)
                    case .failure(let error):
                        print("Error fetching record: \(error)")
                    }
                }
                completion(records)
            case .failure(let error):
                print("Error fetching records: \(error.localizedDescription)")
                completion([])
            }
        }
    }
}

//enum AdPrivacyType: String, CaseIterable, Identifiable {
//    var id: Self {
//        return self
//    }
//
//    case noTracking = "No Tracking"
//    case essential = "Only Essential Cookies"
//    case full = "Standard Tracking"
//}

// Define the Item model
@Model
class Item {
    @Attribute(.unique) var id: UUID = UUID()
    var name: String
    var timestamp: Date

    init(name: String, timestamp: Date) {
        self.name = name
        self.timestamp = timestamp
    }

    func asCKRecord() -> CKRecord {
        let record = CKRecord(recordType: "Item", recordID: CKRecord.ID(recordName: self.id.uuidString))
        record["name"] = self.name as CKRecordValue
        record["timestamp"] = self.timestamp as CKRecordValue
        return record
    }
}

#Preview("Settings View") {
    SettingsView()
}
