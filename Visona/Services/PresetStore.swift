//
//  PresetStore.swift
//  Visona
//
//

import Foundation
import Combine

/// Kullanıcının oluşturduğu custom preset’leri kalıcı tutar.
/// UserDefaults üzerinde JSON olarak saklar.
final class PresetStore: ObservableObject {
    static let shared = PresetStore()

    /// Kullanıcı tanımlı preset’ler
    @Published var custom: [StylePreset] = [] {
        didSet { save() }
    }

    private let storageKey = "visona.custom.presets.v1"
    private var cancellables = Set<AnyCancellable>()

    private init() {
        custom = (try? load()) ?? []
    }

    // MARK: - CRUD

    func add(_ preset: StylePreset) {
        custom.append(preset)
    }

    func update(_ preset: StylePreset) {
        guard let idx = custom.firstIndex(where: { $0.id == preset.id }) else { return }
        custom[idx] = preset
    }

    func remove(_ preset: StylePreset) {
        custom.removeAll { $0.id == preset.id }
    }

    // MARK: - Persistence

    private func save() {
        do {
            let data = try JSONEncoder().encode(custom)
            UserDefaults.standard.set(data, forKey: storageKey)
        } catch {
            #if DEBUG
            print("[PresetStore] save error:", error)
            #endif
        }
    }

    private func load() throws -> [StylePreset] {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else {
            return []
        }
        return try JSONDecoder().decode([StylePreset].self, from: data)
    }
}
