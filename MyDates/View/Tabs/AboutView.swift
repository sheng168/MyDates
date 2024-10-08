//
//  AboutView.swift
//  MyDates
//
//  Created by Jin on 8/30/23.
//

import KeweApp
import SwiftUI
import FirebaseRemoteConfigSwift
import FirebaseInstallations

struct AboutView: View {
    @RemoteConfigProperty(key: "updateMessage", fallback: nil) var updateMessage: String?
    @RemoteConfigProperty(key: "about", fallback: Config.shared.about) var about: [KeweApp.Section]
    
    let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    let buildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
    @State var installId = ""

    var body: some View {
        Form  {
            if let updateMessage {
                Section("Update") {
                    Text(LocalizedStringKey(updateMessage))
                }
            }
            
            ForEach(about) { section in
                Section(section.id) {
                    Text(LocalizedStringKey(section.detail))
                }
            }
            
            Section("Info") {
                Text("Version: \(appVersion ?? "-") Build: \(buildNumber ?? "-")")
                Text("Installation: \(installId)") // Installation: fgkRDGhTB0FCnOo2zRDvTn
                    .textSelection(.enabled)
            }

            /*
            Section("Features") {
                Text("""
                - Save list of name and date
                - Quickly see family members' age
                - Calculate year, month, day, hour, minute, seconds
                - Count down to future days
                - Backup and sync to all your iPhone/iPads using your apple ID
                """)
            }
            Section("Todos") {
                Text("""
                - Set image or icon with each entry
                - Organize entries into groups
                - Display preferences
                """)
            }
            Section("About") {
                Text("""
                I built this app to replace one that I've been using. I felt that $10 per year to remove baner ads and access premium features was too much for such as simple app.
                
                While my app is currently free, I plan to charge $1 per year so that it can be maintained and enhanced.       
                """)
            }
             */
            
        }
        .onAppear {
            MyAnalytics.view(self)
        }
        .task {
            do {
                installId = try await Installations.installations().installationID()
            } catch {
                installId = "<fail>"
            }
        }
    }
}

#Preview {
    AboutView()
        .environmentObject(StateManager())
}
