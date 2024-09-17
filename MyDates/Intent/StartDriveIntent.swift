//
//  StartDriveIntent.swift
//  TesWatch
//
//  Created by Jin on 1/27/24.
//

import AppIntents

struct NewItemIntent: AppIntent {
//    init() {
//        
//    }
    
    static var title: LocalizedStringResource = "New date"
    static var openAppWhenRun: Bool = true
    
    var date = Date()
    
    @MainActor
    func perform() async throws -> some IntentResult {
        print("perform New date")
//        withAnimation {
//            let newItem = Item(timestamp: Date())
//            MyDatesApp.container.mainContext.insert(newItem)
//        }
        return .result(dialog: "Started Drive")
    }
}

struct OpenFrunkIntent: AppIntent {
    static var title: LocalizedStringResource = "Open Frunk"
    
    @MainActor
    func perform() async throws -> some IntentResult {
        return .result(dialog: "Open Frunk")
    }
}

struct VehicleCommandIntent: AppIntent {
    static var title: LocalizedStringResource = "Open Frunk"
    
    // An example configurable parameter.
    @Parameter(title: "Vehicle", default: "😃")
    var vehicle: String

    @Parameter(title: "Command", default: "😃")
    var command: String

    @MainActor
    func perform() async throws -> some IntentResult {
        return .result(dialog: "Open Frunk")
    }
}

//enum Command: AppEnum {
//    typealias RawValue = <#type#>
//
//    static var typeDisplayRepresentation: TypeDisplayRepresentation
//
//    static var caseDisplayRepresentations: [Command : DisplayRepresentation]
//
////    public typealias Specification = 1
//    
//    
//}
