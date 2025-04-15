//
//  Buttons.swift
//  GamesAndThings
//
//  Created by Adam Jolicoeur on 4/15/25.
//  Copyright © 2025 AdamJolicoeur. All rights reserved.
//

import SwiftUI

struct FloatingButton: ButtonStyle {
    @GestureState private var pressed = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.leading, Constants.SpacerMedium) // 16
            .padding(.trailing, Constants.SpacerLarge) // 24
            .padding(.vertical, Constants.SpacerSmall) // 8
            .frame(maxWidth: .infinity, maxHeight: 60, alignment: .center)
            .background(configuration.isPressed ? .backgroundTertiary : .secondaryApp)
            .foregroundStyle(.text)
            .cornerRadius(100)
            .shadow(color: .black.opacity(0.15), radius: 1.5, x: 0, y: 1)
            .shadow(color: .black.opacity(0.3), radius: 1, x: 0, y: 1)
            .bodyBoldStyle()
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    @GestureState private var pressed = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.leading, Constants.SpacerMedium) // 16
            .padding(.trailing, Constants.SpacerLarge) // 24
            .padding(.vertical, Constants.SpacerSmall) // 8
            .padding(.horizontal, Constants.SpacerLarge) // 24
            .frame(maxWidth: .infinity, maxHeight: 60, alignment: .center)
            .background(configuration.isPressed ? .backgroundBlue : .solidBlue)
            .foregroundStyle(configuration.isPressed ? .text : .lightText)
            .cornerRadius(100)
            .bodyBoldStyle()
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct OutlineButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.leading, Constants.SpacerMedium) // 16
            .padding(.trailing, Constants.SpacerLarge) // 24
            .padding(.vertical, Constants.SpacerSmall) // 8
            .padding(.horizontal, Constants.SpacerLarge) // 24
            .frame(maxWidth: .infinity, maxHeight: 60, alignment: .center)
            .background(configuration.isPressed ? .backgroundSecondary : .transparent)
            .foregroundStyle(configuration.isPressed ? .lightText : .text)
            .cornerRadius(100)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
            .overlay(
            RoundedRectangle(cornerRadius: 100)
                .inset(by: 0.5)
                .stroke(.text, lineWidth: 1)
                .scaleEffect(configuration.isPressed ? 0.95 : 1)
                .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
            )
    }
}

struct ButtonDemoView: View {
    var body: some View {
        VStack {
            
            Button("Floating Button Style") {}
            .buttonStyle(FloatingButton())
            
            Button("Primary Button Style") {}
            .buttonStyle(PrimaryButtonStyle())
            
            Button("Outline Button Style") {}
            .buttonStyle(OutlineButtonStyle())
        }
    }
}

#Preview("Button Demo") {
    ButtonDemoView()
}
