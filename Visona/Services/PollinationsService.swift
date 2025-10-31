//
//  PollinationsService.swift
//  Visona
//


import UIKit

final class PollinationsService {
    func generateImage(prompt: String) async -> UIImage? {
        // Prompt encoding
        guard let encoded = prompt.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://image.pollinations.ai/prompt/\(encoded)") else {
            print("Invalid prompt.")
            return nil
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                print("✅ Pollinations: Image received successfully.")
                return image
            } else {
                print("❌ Pollinations: Image decode failed.")
                return nil
            }
        } catch {
            print("⚠️ Pollinations error:", error)
            return nil
        }
    }
}
