//
//  FontManager.swift
//  Visona

import SwiftUI
import UIKit

enum FontNames {
    // PostScript adlarını KONSOL ÇIKTISINA GÖRE birebir yaz
    // (Aşağıdaki varsayılan isimler çoğu MontserratAlternates paketinde böyle)
    static let regular  = "MontserratAlternates-Regular"
    static let medium   = "MontserratAlternates-Medium"
    static let semiBold = "MontserratAlternates-SemiBold"
    static let bold     = "MontserratAlternates-Bold"

    // İsim mevcut mu kontrol
    static func isLoaded(_ name: String) -> Bool {
        UIFont(name: name, size: 12) != nil
    }

    // Yanlış ad varsa sessizce sistem fonta düşmesin; geliştiricide uyarı basalım
    @discardableResult
    static func assertLoaded(_ name: String) -> Bool {
        let ok = isLoaded(name)
        if !ok {
            print("⚠️ [Font] Not found in app bundle:", name,
                  "| Check UIAppFonts & PostScript name.")
        }
        return ok
    }

    // Ağırlığa göre uygun PostScript adı
    static func name(for weight: Font.Weight) -> String {
        switch weight {
        case .bold:     return bold
        case .semibold: return semiBold
        case .medium:   return medium
        default:        return regular
        }
    }
}

extension Font {
    /// SwiftUI kullanımı
    static func montserrat(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        let ps = FontNames.name(for: weight)
        // Uyarıyı bir kere görelim
        _ = FontNames.assertLoaded(ps)
        return .custom(ps, size: size)
    }
}

extension UIFont {
    /// UIKit kullanımı (gerekirse)
    static func montserrat(_ size: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
        let map: [UIFont.Weight: String] = [
            .bold: FontNames.bold,
            .semibold: FontNames.semiBold,
            .medium: FontNames.medium,
            .regular: FontNames.regular
        ]
        let ps = map[weight, default: FontNames.regular]
        if FontNames.assertLoaded(ps), let f = UIFont(name: ps, size: size) {
            return f
        }
        return .systemFont(ofSize: size, weight: weight) // güvenli fallback
    }
}
