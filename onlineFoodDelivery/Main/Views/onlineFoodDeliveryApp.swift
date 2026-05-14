//
//  onlineFoodDeliveryApp.swift
//  onlineFoodDelivery
//
//  Created by Ashirwad on 09/04/26.
//

import SwiftUI

@main
struct onlineFoodDeliveryApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
