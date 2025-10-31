//
//  DesignSystem.swift
//  Visona

import SwiftUI

public enum VTheme { }
/*
public extension Color {
    static let vIndigo     = Color(red: 18/255,  green: 12/255,  blue: 64/255)
    static let vOrange     = Color(red: 255/255, green: 150/255, blue: 40/255)
    static let vOrangeDark = Color(red: 210/255, green: 110/255, blue: 20/255)
    static let vAmber      = Color(red: 255/255, green: 220/255, blue: 170/255)
}
*/
public extension LinearGradient {
    static var vCTA: LinearGradient {
        LinearGradient(colors: [.vOrange, .vAmber],
                       startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}
