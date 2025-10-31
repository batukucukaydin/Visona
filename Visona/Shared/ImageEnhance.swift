//
//  ImageEnhance.swift
//  Visona
//
import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins

enum Enhance {
    static func upscale2x(_ image: UIImage) -> UIImage? {
        guard let cg = image.cgImage else { return nil }
        let base = CIImage(cgImage: cg)

        // 1) Lanczos upsample (2x)
        let lanczos = CIFilter.lanczosScaleTransform()
        lanczos.inputImage = base
        lanczos.scale = 2.0
        lanczos.aspectRatio = 1.0
        guard let up = lanczos.outputImage else { return nil }

        // 2) Unsharp mask (hafif)
        let unsharp = CIFilter.unsharpMask()
        unsharp.inputImage = up
        unsharp.intensity = 0.5
        unsharp.radius = 1.2
        guard let sharp = unsharp.outputImage else { return nil }

        let ctx = CIContext(options: [CIContextOption.useSoftwareRenderer: false])
        guard let outCG = ctx.createCGImage(sharp, from: sharp.extent) else { return nil }
        return UIImage(cgImage: outCG, scale: image.scale, orientation: image.imageOrientation)
    }
}
