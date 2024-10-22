//
//  WidgetDemo.swift
//  WidgetDemo
//
//  Created by Ming on 28/7/2022.
//

import ActivityKit
import WidgetKit
import SwiftUI
import AppIntents

//@main
//struct Widgets: WidgetBundle {
//   var body: some Widget {
//       PizzaDeliveryActivityWidget()
//       PizzaAdActivityWidget()
//   }
//}



struct PizzaDeliveryActivityWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: PizzaDeliveryAttributes.self) { context in
            // MARK: - For devices that don't support the Dynamic Island.
            LockScreenView(state: context.state)
            // MARK: - For Dynamic Island
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
//                    Label("", systemImage: "bag")
                    Text("\(context.state.name)")
//                        .font(.title3)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Label {
                        Text(timerInterval: context.state.dateRange, countsDown: true)
                            .multilineTextAlignment(.trailing)
//                            .frame(width: 50)
                            .monospacedDigit()
//                            .font(.caption2)
                    } icon: {
//                        Image(systemName: "timer")
                    }
                    .font(.title2)
                }
//                DynamicIslandExpandedRegion(.center) {
//                    EmptyView()
//                    Text("\(context.state.driverName)")
//                        .lineLimit(1)
//                        .font(.caption)
//                        .foregroundColor(.secondary)
//                }
                DynamicIslandExpandedRegion(.bottom) {
                    // Deep Linking
                    HStack {
                        Button("Cancel", intent: CancelIntent(id: "Cancel"))
//                        Link(destination: URL(string: "https://www.apple.com/")!) {
//                             Label("Open", systemImage: "phone.circle.fill")
//                                .font(.caption)
//                                .padding()
//                         }.background(Color.accentColor)
//                         .clipShape(RoundedRectangle(cornerRadius: 15))
                        Spacer()
                        
                        Toggle("Clear", isOn: true, intent: CancelIntent(id: "Clear"))
//                        Link(destination: URL(string: "pizza://cancelOrder")!) {
//                             Label("Clear", systemImage: "xmark.circle.fill")
//                                .font(.caption)
//                                .padding()
//                         }.background(Color.red)
//                         .clipShape(RoundedRectangle(cornerRadius: 15))
                    }
                }
            } compactLeading: {
                Label {
                    Text("\(context.state.name)")
                } icon: {
//                    Image(systemName: "bag")
                }
                .font(.caption2)
            } compactTrailing: {
                Text(timerInterval: context.state.dateRange, countsDown: true)
//                    .multilineTextAlignment(.center)
//                    .frame(width: 40)
//                    .font(.caption2)
            } minimal: {
                VStack(alignment: .center) {
//                    Image(systemName: "timer")
                    Text(timerInterval: context.state.dateRange, countsDown: true)
//                        .multilineTextAlignment(.center)
                        .monospacedDigit()
//                        .font(.caption2)
                }
            }
            .keylineTint(.accentColor)
            .widgetURL(URL(string: "widget://item/\(context.attributes.id)")!)
        }
    }
}

struct LockScreenView: View { // or no island
    let state: PizzaDeliveryAttributes.ContentState
    
    var body: some View {
        let date = state.timestamp
        
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    LabeledContent {
                        
                    } label: {
                        Text("\(state.name)")
//                            .font(.headline)
                        HStack {
                            Text(date, format: Date.FormatStyle(date: .numeric, time: .standard)).lineLimit(1)
                            Spacer()
                            Text(date, style: .relative)
                        }
                        
//                        Text(date, style: .timer)
//
//                        Text(date, style: .offset)
//
//                        Text(timerInterval: state.dateRange, countsDown: true)
                    }

                    
                    
                    
                    if true {
                        
                    } else {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(.secondary)
                            HStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(.blue)
                                    .frame(width: 50)
                                Image(systemName: "shippingbox.circle.fill")
                                    .foregroundColor(.white)
                                    .padding(.leading, -25)
                                Image(systemName: "arrow.forward")
                                    .foregroundColor(.white.opacity(0.5))
                                Image(systemName: "ellipsis")
                                    .foregroundColor(.white.opacity(0.5))
                                Text(timerInterval: state.dateRange, countsDown: true)
                                    .bold()
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.8))
                                    .multilineTextAlignment(.center)
                                Image(systemName: "ellipsis")
                                    .foregroundColor(.white.opacity(0.5))
                                Image(systemName: "arrow.forward")
                                    .foregroundColor(.white.opacity(0.5))
                                Image(systemName: "house.circle.fill")
                                    .foregroundColor(.green)
                                    .background(.white)
                                    .clipShape(Circle())
                            }
                        }
                    }
                }
                //                    Spacer()
                //                    VStack {
                //                        Text("\(context.attributes.numberOfPizzas) 🍕")
                //                            .font(.title)
                //                            .bold()
                //                        Spacer()
                //                    }
            }.padding(5)
            //                Text("You've already paid: \(context.attributes.totalAmount) + $9.9 Delivery Fee 💸")
            //                    .font(.caption)
            //                    .foregroundColor(.secondary)
            //                    .padding(.horizontal, 5)
        }.padding(15)
    }
}

/*
struct PizzaAdActivityWidget_: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: PizzaAdAttributes.self) { context in
            HStack {
                let logo = UserDefaults(suiteName: "group.io.startway.iOS16-Live-Activities")?.data(forKey: "pizzaLogo")
                if (logo != nil) {
                    Image(uiImage: UIImage(data: logo!)!)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 64, height: 64)
                        .cornerRadius(15)
                }
                Spacer()
                VStack(alignment: .leading) {
                    Text(context.state.adName).font(.caption).foregroundColor(.secondary)
                    Text("Get \(Text(context.attributes.discount).fontWeight(.black).foregroundColor(.blue)) OFF").bold().font(.system(size: 25)).foregroundColor(.secondary)
                    Text("when purchase 🍕 every $500").font(.callout).italic().lineLimit(1)
                }.padding(.trailing)
            }.padding()
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Label(context.attributes.discount, systemImage: "dollarsign.arrow.circlepath")
                        .font(.title2)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Label {
                        Text("Ads")
                            .multilineTextAlignment(.trailing)
                            .frame(width: 50)
                            .monospacedDigit()
                            .font(.caption2)
                    } icon: {
                        Image(systemName: "dollarsign.circle.fill")
                    }
                    .font(.title2)
                }
                DynamicIslandExpandedRegion(.center) {
                    Text(context.state.adName)
                        .lineLimit(1)
                        .font(.caption)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Button {
                        // Deep link into the app.
                    } label: {
                        Label("Pay now", systemImage: "creditcard")
                    }
                }
            } compactLeading: {
                Label {
                    Text(context.attributes.discount)
                } icon: {
                    Image(systemName: "dollarsign.circle.fill")
                }
                .font(.caption2)
                .foregroundColor(.red)
            } compactTrailing: {
                Text("Due")
                    .multilineTextAlignment(.center)
                    .frame(width: 40)
                    .font(.caption2)
            } minimal: {
                VStack(alignment: .center) {
                    Image(systemName: "dollarsign.circle.fill")
                    Text(context.attributes.discount)
                        .multilineTextAlignment(.center)
                        .monospacedDigit()
                        .font(.caption2)
                }
            }
            .keylineTint(.accentColor)
        }
    }
}
*/
// Preview available on iOS 16.2 or above
@available(iOSApplicationExtension 16.2, *)
struct PizzaDeliveryActivityWidget_Previews: PreviewProvider {
    static let activityAttributes = PizzaDeliveryAttributes(id: "1000")
    static let activityState = PizzaDeliveryAttributes.ContentState(name: "Tim", timestamp: Date().addingTimeInterval(15 * 60))
    
    static var previews: some View {
        activityAttributes
            .previewContext(activityState, viewKind: .content)
            .previewDisplayName("Notification")
        
        activityAttributes
            .previewContext(activityState, viewKind: .dynamicIsland(.compact))
            .previewDisplayName("Compact")
        
        activityAttributes
            .previewContext(activityState, viewKind: .dynamicIsland(.expanded))
            .previewDisplayName("Expanded")
        
        activityAttributes
            .previewContext(activityState, viewKind: .dynamicIsland(.minimal))
            .previewDisplayName("Minimal")
    }
}
