//
//  WishKitView.swift
//  MyDates
//
//  Created by Jin on 10/6/23.
//

import SwiftUI
import WishKit

struct WishKitView: View {
    init() {
        WishKit.configure(with: "93946F1E-B15C-435D-A37E-5B145DFBB1E9")
        WishKit.config.commentSection = .hide
        WishKit.config.buttons.addButton.bottomPadding = .large
        WishKit.config.expandDescriptionInList = true
    }
    
    var body: some View {
        WishKit.FeedbackListView().withNavigation()
            .onAppear {
                MyAnalytics.view(self)
            }
    }
}

#Preview {
    WishKitView()
}
