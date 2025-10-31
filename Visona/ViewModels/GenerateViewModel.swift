//
//  GenerateViewModel.swift
//  Visona
//
import Foundation
import UIKit

@MainActor
final class GenerateViewModel: ObservableObject {

    enum Mode { case text2img, img2img }

    // MARK: Inputs
    @Published var mode: Mode = .text2img
    @Published var basePrompt: String = ""
    @Published var negatives: String = ""
    @Published var selectedPreset: StylePreset = .normal

    // MARK: Outputs
    @Published var isLoading: Bool = false
    @Published var resultImage: UIImage?
    @Published var errorMessage: String?

    // MARK: Presets (yerleşik + kullanıcı)
    let builtinPresets: [StylePreset] = StylePreset.builtins
    @Published var customPresets: [StylePreset] = []

    // MARK: Init
    /// Servis burada opsiyonel; kullanılmasa da VM’nin compile etmesini sağlar.
    init() { }
}
