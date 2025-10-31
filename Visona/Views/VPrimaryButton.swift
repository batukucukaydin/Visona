//
//  VPrimaryButton.swift
//  Visona
//


import SwiftUI

struct VPrimaryButton: View {
    let title: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.montserrat(18, weight: .semibold))     // ← FontManager
                .foregroundColor(.vIndigo)                     // paletten
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(LinearGradient.vCTA)               // ← DesignSystem
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color.vOrangeDark.opacity(0.4), lineWidth: 1) // paletten
                )
                .shadow(color: .black.opacity(0.25), radius: 10, y: 6)
        }
        .buttonStyle(.plain)
    }
}
