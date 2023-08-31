//
//  AboutView.swift
//  MyDates
//
//  Created by Jin on 8/30/23.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        Form  {
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
        }
    }
}

#Preview {
    AboutView()
        .environmentObject(StateManager())
}
