//
//  APIKey.swift
//  GeminiMultimodelChat
//
//  Created by Omkar Anarse on 16/02/24.
//

import Foundation

enum APIKey {
    // Fetch the API key from 'GenerativeAI-Info.plist'
    static var `default`: String {
        guard let filePath = Bundle.main.path(forResource: "GenerativeAI-Info", ofType: "plist") else {
            fatalError("Could not find file 'GenerativeAI-Info.plist'.")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "API_KEY") as? String else {
            fatalError("Could not find key 'API_KEY' in 'GenerativeAI-Info.plist'.")
        }
        if value.starts(with: "_") || value.isEmpty {
            fatalError("Follow the instruction at https://ai.google.dev/tutorials/setup to get an APi key")
        }
        return value
    }
}
