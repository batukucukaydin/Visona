//
//  PresetManagerView.swift
//  Visona
//
/*

import SwiftUI

struct PresetManagerView: View {
    @ObservedObject var store = PresetStore.shared
    @Environment(\.dismiss) private var dismiss

    @State private var name: String = ""
    @State private var suffix: String = ""

    // Yerleşik + kullanıcı preset’leri
    private var builtinPresets: [StylePreset] { StylePreset.builtins }
    private var customPresets: [StylePreset] { store.custom }

    var body: some View {
        ZStack {
            Color.vIndigo.ignoresSafeArea()

            VStack(spacing: 14) {
                presetsList
                createForm
                Spacer(minLength: 6)
                doneButton
            }
            .padding()
        }
        .vBackChevron()
        .navigationTitle("Presets")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - List
    private var presetsList: some View {
        List {
            Section("Default Presets") {
                ForEach(builtinPresets, id: \.id) { p in
                    row(for: p, deletable: false)
                }
            }

            Section("My Presets") {
                ForEach(customPresets, id: \.id) { p in
                    row(for: p, deletable: true)
                }
                .onDelete { indexSet in
                    store.delete(at: indexSet)
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.clear)
        .listRowBackground(Color.white.opacity(0.04))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }

    private func row(for preset: StylePreset, deletable: Bool) -> some View {
        HStack(spacing: 10) {
            Text(preset.name)
                .font(.montserrat(15, weight: .semibold))
                .foregroundColor(.vAmber)
            Spacer()
            Text(preset.promptSuffix)
                .font(.montserrat(12, weight: .regular))
                .foregroundColor(.vAmber.opacity(0.7))
                .lineLimit(1)
        }
        .listRowBackground(Color.white.opacity(0.04))
        .contentShape(Rectangle())
    }

    // MARK: - Create
    private var createForm: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Create a preset")
                .font(.montserrat(16, weight: .semibold))
                .foregroundStyle(LinearGradient.vCTA)

            TextField("Name (e.g. Cinematic)", text: $name)
                .padding(12)
                .background(Color.white.opacity(0.07))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .foregroundColor(.vAmber)

            TextField("Prompt suffix (e.g. \"cinematic lighting, kodak film look\")",
                      text: $suffix, axis: .vertical)
                .padding(12)
                .background(Color.white.opacity(0.07))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .foregroundColor(.vAmber)

            Button(action: addPreset) {
                Text("Add Preset")
                    .font(.montserrat(15, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(LinearGradient.vCTA)
                    .foregroundColor(.vIndigo)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
            .disabled(name.trimmed.isEmpty || suffix.trimmed.isEmpty)
        }
    }

    // MARK: - Done
    private var doneButton: some View {
        Button("Done") { dismiss() }
            .font(.montserrat(14, weight: .semibold))
            .foregroundColor(.vAmber)
    }

    // MARK: - Actions
    private func addPreset() {
        let n = name.trimmed
        let s = suffix.trimmed
        guard !n.isEmpty, !s.isEmpty else { return }
        store.add(name: n, promptSuffix: s)
        name = ""
        suffix = ""
    }
}

// Küçük yardımcı
private extension String {
    var trimmed: String { trimmingCharacters(in: .whitespacesAndNewlines) }
}
*/
