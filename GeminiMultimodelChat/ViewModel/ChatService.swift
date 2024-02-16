//
//  ChatService.swift
//  GeminiMultimodelChat
//
//  Created by Omkar Anarse on 16/02/24.
//

import Foundation
import SwiftUI
import GoogleGenerativeAI

// Define a class for managing chat messages and interacting with generative AI
@Observable
class ChatService {
    // Instantiate the main generative AI model
    private var proModel = GenerativeModel(name: "gemini-pro", apiKey: APIKey.default)
    // Instantiate a vision-related generative AI model
    private var proVisionModel = GenerativeModel(name: "gemini-pro-vision", apiKey: APIKey.default)
    // Array to store chat messages
    private(set) var messages = [ChatMessage]()
    // Flag to indicate whether the service is waiting for a response
    private(set) var loadingResponse = false
    
    // Function to send a message to the AI model
    func sendMessage(message: String, imageData: [Data]) async {
        // Set loadingResponse to true to indicate a response is being awaited
        loadingResponse = true
        
        // Add user's message and a placeholder AI model message to the list
        messages.append(.init(role: .user, message: message, images: imageData))
        messages.append(.init(role: .model, message: "", images: nil))
        
        do {
            // Determine which AI model to use based on whether imageData is empty
            let chatModel = imageData.isEmpty ? proModel : proVisionModel
            var images = [PartsRepresentable]()
            
            // Compress image data if provided
            for data in imageData {
                if let compressedData = UIImage(data: data)?.jpegData(compressionQuality: 0.1) {
                    images.append(ModelContent.Part.jpeg(compressedData))
                }
            }
            
            // Request and stream the response from the AI model
            let outputStream = chatModel.generateContentStream(message, images)
            for try await chunk in outputStream {
                guard let text = chunk.text else { return }
                let lastChatMessageIndex = messages.count - 1
                // Append the received text to the last model message in the conversation
                messages[lastChatMessageIndex].message += text
            }
            // Set loadingResponse to false after receiving the response
            loadingResponse = false
        } catch {
            // Handle errors
            loadingResponse = false
            // Remove the last model message from the conversation
            messages.removeLast()
            // Add an error message to the conversation
            messages.append(.init(role: .model, message: "Something went wrong. Please try again."))
            // Print the error
            print("DEBUG: Error occurred \(error.localizedDescription)")
        }
    }
}
//AIzaSyD1VFbswLFFtrFejxdXb-bu98HSLwBxr94
