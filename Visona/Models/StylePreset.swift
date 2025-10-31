//
//  StylePreset.swift
//  Visona
//

//
import Foundation

/// Prompt’a eklenecek stil kuyruğu (suffix) tutar.
struct StylePreset: Identifiable, Codable, Equatable, Hashable {
    var id: String
    var name: String
    /// Örn: "cinematic", "oil painting", "neon" … (Normal için boş string)
    var promptSuffix: String

    // Varsayılan / Normal
    static let normal = StylePreset(id: "normal", name: "Normal", promptSuffix: "")

    // Uygulamada gözükecek yerleşik stiller
    static let builtins: [StylePreset] = [
        .normal,
        StylePreset(id: "cinematic", name: "Cinematic", promptSuffix: "cinematic"),
        StylePreset(id: "oil",      name: "Oil Paint", promptSuffix: "oil painting"),
        StylePreset(id: "neon",     name: "Neon",      promptSuffix: "neon"),
        StylePreset(id: "vintage",  name: "Vintage",   promptSuffix: "vintage film"),
        StylePreset(id: "anime",    name: "Anime",     promptSuffix: "anime style")
    ]
}
