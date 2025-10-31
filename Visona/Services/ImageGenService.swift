//
//  ImageGenService.swift
//  Visona
//

import Foundation
import UIKit

public protocol ImageGenServicing {
    func ping() async throws -> Bool
    func text2img(
        prompt: String,
        negative: String?,
        steps: Int,
        width: Int,
        height: Int,
        guidanceScale: Double,
        seed: Int?
    ) async throws -> UIImage
}

public final class ImageGenService: ImageGenServicing {
    private let baseURL: URL
    private let session: URLSession

    public init(baseURLString: String = "http://127.0.0.1:7860",
                session: URLSession = .shared) {
        self.baseURL = URL(string: baseURLString)!
        self.session = session
    }

    public func ping() async throws -> Bool {
        var req = URLRequest(url: baseURL.appendingPathComponent("health"))
        req.timeoutInterval = 4
        let (_, resp) = try await session.data(for: req)
        return (resp as? HTTPURLResponse).map { (200..<300).contains($0.statusCode) } ?? false
    }

    public func text2img(
        prompt: String,
        negative: String?,
        steps: Int = 20,
        width: Int = 768,
        height: Int = 768,
        guidanceScale: Double = 7.5,
        seed: Int? = nil
    ) async throws -> UIImage {

        var req = URLRequest(url: baseURL.appendingPathComponent("txt2img"))
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")

        struct Payload: Encodable {
            let prompt: String
            let negative_prompt: String?
            let steps: Int
            let width: Int
            let height: Int
            let guidance_scale: Double
            let seed: Int?
        }

        req.httpBody = try JSONEncoder().encode(Payload(
            prompt: prompt, negative_prompt: negative, steps: steps,
            width: width, height: height, guidance_scale: guidanceScale, seed: seed
        ))

        do {
            let (data, resp) = try await session.data(for: req)
            guard let http = resp as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
                return Self.placeholder()
            }

            struct Resp: Decodable { let image: String? }
            if let decoded = try? JSONDecoder().decode(Resp.self, from: data),
               let b64 = decoded.image,
               let raw = Data(base64Encoded: b64),
               let img = UIImage(data: raw) {
                return img
            }
            if let img = UIImage(data: data) { return img }
            return Self.placeholder()
        } catch {
            return Self.placeholder()
        }
    }

    private static func placeholder() -> UIImage {
        let size = CGSize(width: 512, height: 512)
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        UIColor(white: 0.12, alpha: 1).setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        let attrs: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.orange,
            .font: UIFont.systemFont(ofSize: 22, weight: .semibold)
        ]
        ("Generated Placeholder\n(no server)" as NSString)
            .draw(in: CGRect(x: 24, y: 24, width: size.width-48, height: size.height-48), withAttributes: attrs)
        let img = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return img
    }
}
