//
//  MenuView.swift
//  onlineFoodDelivery
//
//  Created by Ashirwad on 05/05/26.
//

import SwiftUI

struct MenuView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .opacity(0.3)
                .ignoresSafeArea()
            
            HStack {
                VStack(alignment: .leading, spacing: 32) {
                    SideMenuHeaderView()
                    
                    Spacer()
                }
                .padding()
                .frame(width: 270, alignment: .leading)
                .background(.white)
                
                Spacer()
            }
        }
    }
}
