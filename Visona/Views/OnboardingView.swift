//
//  OnboardingView.swift
//  Visona
//
//

import SwiftUI

struct OnboardingView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.vIndigo.ignoresSafeArea()

                VStack(spacing: 20) {
                    Spacer(minLength: 8)

                    Text("Visona")
                        .font(.montserrat(38, weight: .bold))
                        .foregroundStyle(LinearGradient.vCTA)

                    Text("Turn your imagination into stunning visuals.")
                        .font(.montserrat(16, weight: .medium))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.vAmber)
                        .padding(.horizontal, 28)

                    // Başla
                    NavigationLink {
                        SplashView()
                    } label: {
                        VPrimaryButton(title: "Get Started") { }
                            .contentShape(Rectangle()) // tıklanabilir alan net
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 40)

                    // Küçük bilgi satırı
                    Text("No sign-up required • Free text-to-art via Pollinations")
                        .font(.montserrat(12, weight: .regular))
                        .foregroundColor(.vAmber.opacity(0.8))
                        .padding(.top, 4)

                    Spacer()
                }
                .padding(.bottom, 28)
            }
            .toolbarBackground(Color.vIndigo, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .tint(.vOrange)
        }
    }
}
