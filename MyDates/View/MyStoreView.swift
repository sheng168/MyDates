//
//  StoreView.swift
//  MyDates
//
//  Created by Jin on 9/7/23.
//

import SwiftUI
import StoreKit

struct MyStoreView: View {
//    @Query var birdFood: [Item]
    
    var body: some View {
        SubscriptionStoreView(groupID: "21385947")
            .subscriptionStoreButtonLabel(.multiline)
            .storeButton(.visible, for: .redeemCode, .restorePurchases)
    }
}

#Preview {
    MyStoreView()
}
