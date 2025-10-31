//
//  SplashView.swift
//  Visona
//

//
//  SplashView.swift
//  Visona
//

import SwiftUI
import PhotosUI
import UIKit

// MARK: - GLOBAL BACK CHEVRON (Theme)
private struct VBackChevronButton: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        Button(action: { dismiss() }) {
            Image(systemName: "chevron.left")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.vOrange)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Back")
    }
}

private struct VBackChevronModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .toolbarBackground(Color.vIndigo, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .tint(.vOrange)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    VBackChevronButton()
                }
            }
    }
}

private extension View {
    func vBackChevron() -> some View { self.modifier(VBackChevronModifier()) }
}

// MARK: - SPLASH (1. ekran)
struct SplashView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.vIndigo.ignoresSafeArea()
                VStack(spacing: 20) {
                    Spacer()

                    // Logo / Başlık
                    Text("Visona")
                        .font(.montserrat(44, weight: .bold))
                        .foregroundStyle(LinearGradient.vCTA)

                    // Slogan (tırnak içinde) — paletten renk
                    Text("\"Turn your imagination into stunning visuals.\"")
                        .font(.montserrat(18, weight: .medium))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.vAmber)
                        .padding(.horizontal, 28)

                    // BUTON — hemen sloganın altında
                    NavigationLink(destination: ModeSelectionView()) {
                        Text("Let's Get Started")
                            .font(.montserrat(17, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(LinearGradient.vCTA)
                            .foregroundColor(.vIndigo) // beyaz yok, paletten
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.vOrangeDark.opacity(0.4)))
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 60)

                    Spacer()
                }
            }
        }
    }
}

// MARK: - REUSABLE MODE CARD (opsiyonel; VPrimaryButton varsa onu kullanıyoruz)
private struct VModeCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let titleGradient: LinearGradient
    let borderGradient: LinearGradient
    let isPressed: Bool
    var chips: [String] = []
    var showChevron: Bool = true

    var body: some View {
        ZStack {
            // Depthy glass + soft inner gradient
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color.white.opacity(0.10), Color.white.opacity(0.03)],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(borderGradient.opacity(0.95), lineWidth: 1.6)
                )
                .shadow(color: Color.black.opacity(isPressed ? 0.16 : 0.10),
                        radius: isPressed ? 10 : 14, y: isPressed ? 4 : 8)

            HStack(alignment: .center, spacing: 16) {
                // Icon pill (bigger)
                ZStack {
                    Circle()
                        .fill(borderGradient.opacity(0.28))
                        .frame(width: 46, height: 46)
                        .overlay(Circle().stroke(borderGradient, lineWidth: 1.3))
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.vOrange)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text(title)
                        .font(.montserrat(19, weight: .bold))
                        .foregroundStyle(titleGradient)

                    Text(subtitle)
                        .font(.montserrat(14, weight: .regular))
                        .foregroundColor(.vAmber)
                        .fixedSize(horizontal: false, vertical: true)

                    if !chips.isEmpty {
                        HStack(spacing: 8) {
                            ForEach(chips, id: \.self) { chip in
                                Text(chip)
                                    .font(.montserrat(12, weight: .semibold))
                                    .padding(.vertical, 6)
                                    .padding(.horizontal, 10)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                                            .fill(Color.white.opacity(0.08))
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                                            .stroke(borderGradient.opacity(0.8), lineWidth: 1)
                                    )
                                    .foregroundColor(.vAmber)
                            }
                            Spacer(minLength: 0)
                        }
                        .padding(.top, 2)
                    }
                }

                if showChevron {
                    // Trailing chevron
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.06))
                            .overlay(Circle().stroke(borderGradient.opacity(0.9), lineWidth: 1))
                        Image(systemName: "chevron.right")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.vOrange)
                    }
                    .frame(width: 34, height: 34)
                }
            }
            .padding(20)
        }
        .scaleEffect(isPressed ? 0.97 : 1.0)
    }
}

// MARK: - MODE SELECTION (2. ekran)
struct ModeSelectionView: View {
    @State private var showTitle = false
    @State private var showTextCard = false
    @State private var showPhotoCard = false

    @GestureState private var isPressingText = false
    @GestureState private var isPressingPhoto = false

    var body: some View {
        ZStack {
            Color.vIndigo.ignoresSafeArea()
            VStack(spacing: 24) {
                Spacer(minLength: 8)

                Text("Choose Your Creative Mode")
                    .font(.montserrat(22, weight: .bold))
                    .foregroundStyle(LinearGradient.vCTA)
                    .padding(.top, 8)
                    .opacity(showTitle ? 1 : 0)
                    .offset(y: showTitle ? 0 : 20)
                    .animation(.spring(response: 0.5, dampingFraction: 0.8), value: showTitle)

                VStack(spacing: 18) {
                    // Text → Art kartı
                    NavigationLink(destination: TextToImageView()) {
                        VModeCard(
                            title: "Text → Art",
                            subtitle: "Describe what you imagine and watch it come to life.",
                            icon: "text.quote",
                            titleGradient: LinearGradient(colors: [.vAmber, .vOrange], startPoint: .topLeading, endPoint: .bottomTrailing),
                            borderGradient: LinearGradient(colors: [.vOrangeDark, .vAmber], startPoint: .topLeading, endPoint: .bottomTrailing),
                            isPressed: isPressingText,
                            chips: ["Fast", "HD 2×", "Styles"]
                        )
                        .opacity(showTextCard ? 1 : 0)
                        .offset(y: showTextCard ? 0 : 24)
                        .animation(.spring(response: 0.35, dampingFraction: 0.75), value: isPressingText)
                        .animation(.spring(response: 0.55, dampingFraction: 0.85).delay(0.05), value: showTextCard)
                    }
                    .buttonStyle(.plain)
                    .gesture(
                        LongPressGesture(minimumDuration: 0.001)
                            .updating($isPressingText) { _, state, _ in state = true }
                    )

                    // Photo → Art kartı
                    NavigationLink(destination: PhotoToPhotoView()) {
                        VModeCard(
                            title: "Photo → Art",
                            subtitle: "Upload a photo and reimagine it in a new artistic style.",
                            icon: "photo.artframe",
                            titleGradient: LinearGradient(colors: [.vAmber, .vOrangeDark], startPoint: .topLeading, endPoint: .bottomTrailing),
                            borderGradient: LinearGradient(colors: [.vAmber, .vOrangeDark], startPoint: .topLeading, endPoint: .bottomTrailing),
                            isPressed: isPressingPhoto,
                            chips: ["Face-safe", "Noise fix", "Presets"]
                        )
                        .opacity(showPhotoCard ? 1 : 0)
                        .offset(y: showPhotoCard ? 0 : 24)
                        .animation(.spring(response: 0.35, dampingFraction: 0.75), value: isPressingPhoto)
                        .animation(.spring(response: 0.55, dampingFraction: 0.85).delay(0.12), value: showPhotoCard)
                    }
                    .buttonStyle(.plain)
                    .gesture(
                        LongPressGesture(minimumDuration: 0.001)
                            .updating($isPressingPhoto) { _, state, _ in state = true }
                    )
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding()
            .padding(.top, -60)
        }
        // Back rengi tema ile
        .vBackChevron()
        .onAppear {
            // staged reveals
            showTitle = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.03) { showTextCard = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) { showPhotoCard = true }
        }
    }
}

// MARK: - TEXT → ART (3. ekran) — Pollinations bağlı
struct TextToImageView: View {
    // MARK: UI State
    @State private var prompt: String = ""
    @State private var goToLoading = false

    // 🔸 Local yerine Pollinations (ücretsiz)
    private let pollinations = PollinationsService()

    // MARK: Style chips (includes Normal)
    enum Style: String, CaseIterable, Identifiable {
        case normal = "Normal"
        case cinematic = "Cinematic"
        case oil = "Oil Paint"
        case neon = "Neon"
        case vintage = "Vintage"
        case anime = "Anime"
        var id: String { rawValue }
        var subtitle: String {
            switch self {
            case .normal: return "Balanced, realistic look"
            case .cinematic: return "Filmic colors, dramatic lighting"
            case .oil: return "Painterly, textured brush strokes"
            case .neon: return "Glowing edges, cyber vibes"
            case .vintage: return "Kodak/film grain, warm tones"
            case .anime: return "Stylized, clean lines"
            }
        }
    }
    @State private var selectedStyle: Style = .normal

    // Quick prompt helpers
    private let quickPrompts = [
        "soft studio portrait, rim light, 85mm",
        "epic mountain vista at sunrise, fog, birds",
        "futuristic city street, rain, reflections, night",
        "cozy reading nook, warm light, plants"
    ]

    var body: some View {
        ZStack {
            Color.vIndigo.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 18) {

                    // Title & subtitle
                    VStack(spacing: 8) {
                        Text("Describe your vision")
                            .font(.montserrat(20, weight: .bold))
                            .foregroundStyle(LinearGradient.vCTA)

                        Text("Write what you want to see, pick a style, then generate.")
                            .font(.montserrat(13, weight: .regular))
                            .foregroundColor(.vAmber)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                    }
                    .padding(.top, 6)

                    // Prompt field
                    TextField("e.g. A cyberpunk city at night", text: $prompt, axis: .vertical)
                        .padding(14)
                        .background(Color.white.opacity(0.07))
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .font(.montserrat(16, weight: .regular))
                        .foregroundColor(.vAmber)

                    // Style selector
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Style")
                            .font(.montserrat(15, weight: .semibold))
                            .foregroundStyle(LinearGradient.vCTA)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(Style.allCases) { style in
                                    let isSelected = style == selectedStyle
                                    Text(style.rawValue)
                                        .font(.montserrat(12, weight: .semibold))
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 12)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                                .fill(Color.white.opacity(isSelected ? 0.14 : 0.08))
                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                                .stroke(isSelected ? Color.vOrange : Color.vAmber.opacity(0.5), lineWidth: 1.1)
                                        )
                                        .foregroundColor(.vAmber)
                                        .onTapGesture { withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) { selectedStyle = style } }
                                        .contextMenu {
                                            Text(style.subtitle)
                                                .font(.footnote)
                                        }
                                }
                            }
                            .padding(.horizontal, 2)
                        }
                    }

                    // Quick prompt chips
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Try a quick prompt")
                            .font(.montserrat(15, weight: .semibold))
                            .foregroundStyle(LinearGradient.vCTA)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(quickPrompts, id: \.self) { qp in
                                    Button {
                                        prompt = qp
                                    } label: {
                                        HStack(spacing: 6) {
                                            Image(systemName: "sparkles")
                                                .font(.system(size: 12, weight: .bold))
                                            Text(qp)
                                                .lineLimit(1)
                                        }
                                        .font(.montserrat(12, weight: .semibold))
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 12)
                                        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.08)))
                                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.vAmber.opacity(0.5)))
                                        .foregroundColor(.vAmber)
                                    }
                                }
                            }
                        }
                    }

                    Spacer(minLength: 12)
                }
                .padding(.horizontal)
                .padding(.top, 12)
                .padding(.bottom, 110) // room for the persistent button
            }

            // Hidden loading navigation link — Pollinations çağrısı burada
            NavigationLink(isActive: $goToLoading) {
                LoadingView(
                    title: "We’re crafting your vision…",
                    subtitle: "Hang tight while the magic happens",
                    generator: {
                        // Compose styled prompt
                        let styledPrompt: String = {
                            if selectedStyle == .normal { return prompt }
                            return "\(selectedStyle.rawValue.lowercased()) style, \(prompt)"
                        }()

                        // Pollinations’a isteği gönder
                        guard !styledPrompt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return nil }
                        return await pollinations.generateImage(prompt: styledPrompt)
                    }
                )
            } label: { EmptyView() }
        }
        .vBackChevron()
        // Persistent bottom Generate button (doesn't jump when keyboard hides)
        .safeAreaInset(edge: .bottom) {
            let disabled = prompt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            VStack {
                Button {
                    goToLoading = true
                } label: {
                    Text("Generate")
                        .font(.montserrat(17, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(LinearGradient.vCTA)
                        .foregroundColor(.vIndigo)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.vOrangeDark.opacity(0.35)))
                        .shadow(color: .black.opacity(0.2), radius: 12, y: 6)
                        .opacity(1.0)
                }
                .disabled(disabled)
                .padding(.horizontal, 16)
                .padding(.top, 6)
                .padding(.bottom, 6)
            }
            .background(
                Color.vIndigo.opacity(0.92)
                    .overlay(Divider().background(Color.vOrangeDark.opacity(0.25)), alignment: .top)
                    .ignoresSafeArea()
            )
            .padding(.bottom, 10)
            .offset(y: -12)
        }
    }
}

// MARK: - PHOTO → ART (4. ekran) — placeholder (hatasız)
struct PhotoToPhotoView: View {
    @State private var pickedItem: PhotosPickerItem? = nil
    @State private var image: UIImage? = nil
    @State private var prompt: String = ""
    @State private var goToLoading = false

    var body: some View {
        ZStack {
            Color.vIndigo.ignoresSafeArea()

            VStack(spacing: 20) {
                if let ui = image {
                    Image(uiImage: ui)
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.vAmber.opacity(0.35)))
                        .shadow(radius: 8)
                        .frame(maxHeight: 320)
                } else {
                    VStack(spacing: 22) {
                        // Illustration avatar-style circle
                        ZStack {
                            Circle()
                                .fill(Color.white.opacity(0.06))
                                .frame(width: 140, height: 140)
                                .overlay(Circle().stroke(Color.vAmber.opacity(0.35), lineWidth: 1.4))
                                .shadow(color: .black.opacity(0.18), radius: 10, y: 8)

                            Image(systemName: "person.crop.circle.fill")
                                .font(.system(size: 86))
                                .foregroundStyle(LinearGradient.vCTA)
                        }
                        .padding(.top, 12)

                        // Title + subtitle
                        VStack(spacing: 8) {
                            Text("Upload a photo to start")
                                .font(.montserrat(20, weight: .bold))
                                .foregroundStyle(LinearGradient.vCTA)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 24)

                            Text("Choose a clear photo for best results — you only need to do this once.")
                                .font(.montserrat(14, weight: .regular))
                                .foregroundColor(.vAmber)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 28)
                        }

                        // CTA button
                        PhotosPicker(selection: $pickedItem, matching: .images) {
                            HStack(spacing: 10) {
                                Text("Upload Photo")
                                    .font(.montserrat(17, weight: .semibold))
                                Image(systemName: "plus")
                                    .font(.system(size: 16, weight: .bold))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(LinearGradient.vCTA)
                            .foregroundColor(.vIndigo)
                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .stroke(Color.vOrangeDark.opacity(0.4), lineWidth: 1)
                            )
                            .shadow(color: .black.opacity(0.22), radius: 14, y: 8)
                        }
                        .padding(.horizontal, 24)
                        .onChange(of: pickedItem) { newVal in
                            guard let item = newVal else { return }
                            Task {
                                if let data = try? await item.loadTransferable(type: Data.self),
                                   let ui = UIImage(data: data) {
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                                        image = ui
                                    }
                                }
                            }
                        }

                        // Helpful chips
                        HStack(spacing: 10) {
                            ForEach(["Face-safe", "Noise fix", "Presets"], id: \.self) { tag in
                                Text(tag)
                                    .font(.montserrat(12, weight: .semibold))
                                    .padding(.vertical, 6)
                                    .padding(.horizontal, 10)
                                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.08)))
                                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.vAmber.opacity(0.5)))
                                    .foregroundColor(.vAmber)
                            }
                        }
                        .padding(.top, -2)
                    }
                }

                // Prompt describing how the photo should be transformed
                VStack(alignment: .leading, spacing: 8) {
                    Text("Describe the target style")
                        .font(.montserrat(16, weight: .semibold))
                        .foregroundStyle(LinearGradient.vCTA)
                    TextField("e.g. cinematic bokeh portrait, kodak film look", text: $prompt, axis: .vertical)
                        .padding(14)
                        .background(Color.white.opacity(0.07))
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .font(.montserrat(15, weight: .regular))
                        .foregroundColor(.vAmber)
                }

                // Hidden loading navigation link (dummy)
                NavigationLink(isActive: $goToLoading) {
                    LoadingView(
                        title: "Reimagining your photo…",
                        subtitle: "A bit of Visona magic is on the way",
                        generator: {
                            // Şimdilik sadece bekletip mevcut resmi döndürüyoruz
                            try? await Task.sleep(nanoseconds: 1_200_000_000)
                            return image
                        }
                    )
                } label: { EmptyView() }

                Spacer()
            }
            .padding()
            .padding(.bottom, 110) // space for persistent Generate bar
            .animation(.easeInOut(duration: 0.25), value: image)
        }
        .vBackChevron()
        .safeAreaInset(edge: .bottom) {
            let isDisabled = (image == nil)
            VStack(spacing: 10) {
                Button {
                    goToLoading = true
                } label: {
                    Text("Generate")
                        .font(.montserrat(17, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(LinearGradient.vCTA)
                        .foregroundColor(.vIndigo)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.vOrangeDark.opacity(0.35)))
                        .shadow(color: .black.opacity(0.2), radius: 12, y: 6)
                        .opacity(1.0)
                }
                .disabled(isDisabled)
                .padding(.horizontal, 16)
                .padding(.top, 6)
                .padding(.bottom, 6)
            }
            .background(
                // Slightly raised bar with clear contrast to avoid looking "faded"
                Color.vIndigo.opacity(0.92)
                    .overlay(Divider().background(Color.vOrangeDark.opacity(0.25)), alignment: .top)
                    .ignoresSafeArea()
            )
            .padding(.bottom, 10) // lift above the home indicator a bit
            .offset(y: -12)
        }
    }
}

// MARK: - RESULT (son ekran)
struct ResultView: View {
    let image: UIImage?

    var body: some View {
        ZStack {
            Color.vIndigo.ignoresSafeArea()
            VStack(spacing: 18) {
                Group {
                    if let img = image {
                        Image(uiImage: img)
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                            .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color.vAmber.opacity(0.35)))
                            .shadow(color: .black.opacity(0.35), radius: 16, y: 8)
                    } else {
                        RoundedRectangle(cornerRadius: 18)
                            .fill(Color.white.opacity(0.05))
                            .frame(height: 320)
                            .overlay(Text("Your artwork will appear here").foregroundColor(.vAmber))
                    }
                }

                HStack(spacing: 12) {
                    Button {
                        if let img = image { UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil) }
                    } label: {
                        Text("Save")
                            .font(.montserrat(15, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.vAmber)
                            .foregroundColor(.vIndigo)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }

                    Button {
                        if let img = image { VShare.present([img]) }
                    } label: {
                        Text("Share")
                            .font(.montserrat(15, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.vOrange)
                            .foregroundColor(.vIndigo)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }
                }
                Spacer(minLength: 8)
            }
            .padding()
        }
        .vBackChevron()
    }
}

// MARK: - SMALL HELPERS
private struct VShare {
    static func present(_ items: [Any]) {
        let activity = UIActivityViewController(activityItems: items, applicationActivities: nil)
        let keyWindow = UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first
        keyWindow?.rootViewController?.present(activity, animated: true)
    }
}

// MARK: - LOADING VIEW (shared)
struct LoadingView: View {
    let title: String
    let subtitle: String
    let generator: () async -> UIImage?

    @State private var navigate = false
    @State private var image: UIImage? = nil
    @State private var spin = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color.vIndigo.ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer(minLength: 12)

                // Animated ring + sparkle
                ZStack {
                    Circle()
                        .stroke(LinearGradient.vCTA, style: StrokeStyle(lineWidth: 10, lineCap: .round, dash: [24, 18]))
                        .frame(width: 120, height: 120)
                        .rotationEffect(.degrees(spin ? 360 : 0))
                        .animation(.linear(duration: 1.2).repeatForever(autoreverses: false), value: spin)

                    Image(systemName: "sparkles")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(LinearGradient.vCTA)
                        .offset(y: -90)
                        .opacity(0.9)
                        .shadow(color: .black.opacity(0.25), radius: 8, y: 6)
                }

                VStack(spacing: 8) {
                    Text(title)
                        .font(.montserrat(20, weight: .bold))
                        .foregroundStyle(LinearGradient.vCTA)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)

                    Text(subtitle)
                        .font(.montserrat(14, weight: .regular))
                        .foregroundColor(.vAmber)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 28)

                    Text("\"Dreaming it into reality…\"")
                        .font(.montserrat(14, weight: .regular))
                        .foregroundColor(.vAmber)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 28)
                }

                Spacer()

                Button("Cancel") { dismiss() }
                    .font(.montserrat(14, weight: .semibold))
                    .foregroundColor(.vAmber)
                    .padding(.bottom, 16)
            }
        }
        .vBackChevron()
        .onAppear {
            spin = true
            Task {
                let out = await generator()
                image = out
                navigate = true
            }
        }
        .background(
            NavigationLink("", destination: ResultView(image: image), isActive: $navigate)
                .hidden()
        )
    }
}

#Preview {
    SplashView()
    
}
