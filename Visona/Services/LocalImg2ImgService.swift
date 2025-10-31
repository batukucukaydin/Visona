//
//  LocalImg2ImgService.swift
//  Visona
//
//
//
import Foundation
import UIKit

// MARK: - Protocol
protocol Img2ImgServicing {
    func stylize(
        image: UIImage,
        prompt: String,
        negative: String,
        strength: Float,
        steps: Int,
        guidance: Float,
        size: CGSize,
        seed: Int?
    ) async throws -> UIImage

    func ping() async -> String
}

// MARK: - Defaults
extension Img2ImgServicing {
    func stylize(image: UIImage, prompt: String) async throws -> UIImage {
        try await stylize(
            image: image,
            prompt: prompt,
            negative: "text, watermark, signature, low quality",
            strength: 0.55,
            steps: 12,
            guidance: 6.5,
            size: .init(width: 512, height: 512),
            seed: nil
        )
    }
}

// MARK: - Implementation
final class LocalImg2ImgService: Img2ImgServicing {

    // SIMÜLATÖR için localhost en stabil yol
    private let base = "http://localhost:7860"
    private lazy var img2imgURL = URL(string: "\(base)/img2img")!
    private lazy var healthURL  = URL(string: "\(base)/health")!

    private lazy var session: URLSession = {
        let c = URLSessionConfiguration.default
        c.timeoutIntervalForRequest = 180
        c.timeoutIntervalForResource = 480
        c.waitsForConnectivity = true
        return URLSession(configuration: c)
    }()

    private struct Resp: Decodable { let image_base64: String }

    // UI'ye dokunmadan bağlantı testi
    func ping() async -> String {
        var req = URLRequest(url: healthURL)
        req.httpMethod = "GET"
        req.timeoutInterval = 10
        do {
            let (d, r) = try await session.data(for: req)
            let code = (r as? HTTPURLResponse)?.statusCode ?? -1
            return "health \(code), \(d.count)B"
        } catch { return "health error: \(error.localizedDescription)" }
    }

    func stylize(
        image: UIImage,
        prompt: String,
        negative: String,
        strength: Float,
        steps: Int,
        guidance: Float,
        size: CGSize,
        seed: Int?
    ) async throws -> UIImage {

        // 512×512’ye indir (büyük görüntülerde timeout riskini azaltır)
        let target = CGSize(width: max(64, Int(size.width)), height: max(64, Int(size.height)))
        let renderer = UIGraphicsImageRenderer(size: target)
        let resized = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: target))
        }

        guard let data = resized.jpegData(compressionQuality: 0.9) else {
            throw NSError(domain: "ImageEncoding", code: -1,
                          userInfo: [NSLocalizedDescriptionKey:"encode failed"])
        }

        let body: [String: Any] = [
            "image_base64": data.base64EncodedString(),
            "prompt": prompt,
            "negative_prompt": negative,
            "strength": strength,
            "steps": steps,
            "guidance_scale": guidance,
            "width": Int(target.width),
            "height": Int(target.height),
            "seed": seed as Any
        ]

        var req = URLRequest(url: img2imgURL)
        req.httpMethod = "POST"
        req.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        req.timeoutInterval = 180
        req.httpBody = try JSONSerialization.data(withJSONObject: body)

        print("➡️ POST to:", img2imgURL.absoluteString, "| payload:", req.httpBody?.count ?? 0, "bytes")

        let (respData, resp) = try await session.data(for: req)
        print("⬅️ HTTP:", (resp as? HTTPURLResponse)?.statusCode ?? -1, "bytes:", respData.count)

        guard let http = resp as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw NSError(domain: "ServerError", code: -2,
                          userInfo: [NSLocalizedDescriptionKey:"bad response"])
        }
        guard let out = try? JSONDecoder().decode(Resp.self, from: respData),
              let png = Data(base64Encoded: out.image_base64),
              let img = UIImage(data: png) else {
            throw NSError(domain: "ImageDecoding", code: -3,
                          userInfo: [NSLocalizedDescriptionKey:"decode failed"])
        }
        return img
    }
}
