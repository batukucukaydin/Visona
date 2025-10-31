//
//  BackgroundStudioView.swift
//  Visona
//

//


import SwiftUI
import Vision
import CoreImage
import CoreImage.CIFilterBuiltins

struct BackgroundStudioView: View {
    let original: UIImage
    @State private var working: Bool = false
    @State private var edited: UIImage?
    @State private var showShare = false

    var body: some View {
        VStack(spacing: 12) {
            (edited ?? original).imageView

            HStack(spacing: 10) {
                Button("White BG") { Task { await applyWhite() } }
                    .buttonStyle(.borderedProminent).tint(.yellow)

                Button("Gradient BG") { Task { await applyGradient() } }
                    .buttonStyle(.borderedProminent).tint(.orange)

                Button("Blur BG") { Task { await applyBlur() } }
                    .buttonStyle(.bordered).tint(.gray)
            }

            HStack(spacing: 10) {
                Button("Save") {
                    UIImageWriteToSavedPhotosAlbum(edited ?? original, nil, nil, nil)
                }
                .buttonStyle(.borderedProminent).tint(.green)

                Button("Share") { showShare = true }
                    .buttonStyle(.bordered)
            }
        }
        .padding()
        .overlay(alignment: .center) {
            if working { ProgressView().scaleEffect(1.3) }
        }
        .sheet(isPresented: $showShare) {
            ShareSheet(items: [edited ?? original])
        }
        .navigationTitle("Background Studio")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Ops’lar

    private func personMask(for cg: CGImage) throws -> CIImage {
        let req = VNGeneratePersonSegmentationRequest()
        req.qualityLevel = .accurate
        req.outputPixelFormat = kCVPixelFormatType_OneComponent8
        let handler = VNImageRequestHandler(cgImage: cg, options: [:])
        try handler.perform([req])
        guard let res = req.results?.first else { throw NSError() }
        return CIImage(cvPixelBuffer: res.pixelBuffer)
    }

    private func render(_ ci: CIImage) -> UIImage? {
        let ctx = CIContext(options: [CIContextOption.useSoftwareRenderer: false])
        guard let cg = ctx.createCGImage(ci, from: ci.extent) else { return nil }
        return UIImage(cgImage: cg)
    }

    private func maskedForeground(_ base: CIImage, mask: CIImage) -> CIImage {
        let blurred = mask.clampedToExtent()
            .applyingFilter("CIGaussianBlur", parameters: [kCIInputRadiusKey: 3])
            .cropped(to: base.extent)
        return base.applyingFilter("CIBlendWithMask", parameters: [kCIInputMaskImageKey: blurred])
    }

    private func applyWhite() async {
        await setWorking(true)
        defer { Task { await setWorking(false) } }
        guard let cg = original.cgImage else { return }
        do {
            let base = CIImage(cgImage: cg)
            let mask = try personMask(for: cg)
            let fg = maskedForeground(base, mask: mask)
            let bg = CIImage(color: .white).cropped(to: base.extent)
            edited = render(bg.composited(over: fg))
        } catch { }
    }

    private func applyGradient() async {
        await setWorking(true)
        defer { Task { await setWorking(false) } }
        guard let cg = original.cgImage else { return }
        do {
            let base = CIImage(cgImage: cg)
            let mask = try personMask(for: cg)
            let fg = maskedForeground(base, mask: mask)

            // Senin palette: e66000 -> ffcb00
            let grad = CIFilter.linearGradient()
            grad.point0 = CGPoint(x: 0, y: 0)
            grad.point1 = CGPoint(x: base.extent.width, y: base.extent.height)
            grad.color0 = CIColor(red: 0xE6/255, green: 0x60/255, blue: 0x00/255)
            grad.color1 = CIColor(red: 0xFF/255, green: 0xCB/255, blue: 0x00/255)
            let bg = grad.outputImage!.cropped(to: base.extent)

            edited = render(bg.composited(over: fg))
        } catch { }
    }

    private func applyBlur() async {
        await setWorking(true)
        defer { Task { await setWorking(false) } }
        guard let cg = original.cgImage else { return }
        do {
            let base = CIImage(cgImage: cg)
            let mask = try personMask(for: cg)

            // Arka planı blurla: önce komple blur, sonra maskeyle kişi net kalsın
            let blurredBG = base
                .applyingFilter("CIGaussianBlur", parameters: [kCIInputRadiusKey: 12])
                .clampedToExtent()
                .cropped(to: base.extent)

            let blurredComposed = blurredBG
                .applyingFilter("CIBlendWithMask", parameters: [kCIInputMaskImageKey: mask.inverted()])

            // Ön planı net ekle
            let fg = maskedForeground(base, mask: mask)
            edited = render(blurredComposed.composited(over: fg))
        } catch { }
    }

    private func setWorking(_ flag: Bool) async {
        await MainActor.run { self.working = flag }
    }
}

// Küçük yardımcılar
private extension UIImage {
    var imageView: some View {
        Image(uiImage: self)
            .resizable()
            .scaledToFit()
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color.white.opacity(0.08)))
            .shadow(radius: 10)
    }
}
private extension CIImage {
    func inverted() -> CIImage {
        applyingFilter("CIColorInvert", parameters: [:])
    }
}
