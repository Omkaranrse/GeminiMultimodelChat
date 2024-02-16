//
//  Chat.swift
//  GeminiMultimodelChat
//
//  Created by Omkar Anarse on 16/02/24.
//

import Foundation

enum ChatRole {
    case user
    case model
}

struct ChatMessage: Identifiable, Equatable {
    let id = UUID().uuidString
    var role: ChatRole
    var message: String
    var images: [Data]?
    
}
