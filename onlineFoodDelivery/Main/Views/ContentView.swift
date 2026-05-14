//
//  ContentView.swift
//  onlineFoodDelivery
//
//  Created by Ashirwad on 09/04/26.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    var body: some View {
        LoginView()
    }
    
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
