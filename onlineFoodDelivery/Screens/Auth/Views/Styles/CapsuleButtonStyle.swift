//
//  CapsuleButtonStyle.swift
//  onlineFoodDelivery
//
//  Created by Ashirwad on 09/04/26.
//

import SwiftUI

struct CapsuleButtonStyle: ButtonStyle {
    var bgColor: Color = .teal
    var textColor: Color = .white
    var hasBorder: Bool = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(textColor)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Capsule().fill(bgColor))
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .overlay {
                hasBorder ? Capsule().stroke(.gray, lineWidth: 2) : nil
            }
    }
}
