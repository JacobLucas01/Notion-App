//
//  ButtonScaleStyle.swift
//  Truthify
//
//  Created by Jacob Lucas on 1/5/23.
//

import SwiftUI
import Foundation

struct ButtonScaleStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}
