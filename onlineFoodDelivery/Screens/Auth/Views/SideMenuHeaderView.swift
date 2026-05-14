//
//  SideMenuHeaderView.swift
//  onlineFoodDelivery
//
//  Created by Ashirwad on 05/05/26.
//

import SwiftUI

struct MenuContent: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var userStateViewModel = UserStateViewModel()

    var body: some View {
        List {
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Label("Home", systemImage: "house.fill")
                    .labelStyle(.titleAndIcon)
            }
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Label("Past Orders", systemImage: "clock.fill")
                    .labelStyle(.titleAndIcon)
            }
            Button(action: {
                userStateViewModel.signOut()
            }) {
                Label("Logout", systemImage: "rectangle.portrait.and.arrow.right")
                    .labelStyle(.titleAndIcon)
            }
        }
        .listStyle(PlainListStyle())
    }
}

struct SideMenuHeaderView: View {

    var body: some View {
        HStack {
            ZStack{
                VStack(alignment: .leading, spacing: 0) {
                    MenuContent()
                    Spacer()
                }
            }
        }.navigationBarBackButtonHidden()
    }
}
