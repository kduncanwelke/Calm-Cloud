//
//  ActivityManager.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 4/9/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import Foundation

struct ActivityManager {
    static let activities = [
        Activity(title: "Take a walk", category: .physical),
        Activity(title: "Change your sheets", category: .home),
        Activity(title: "Garden", category: .nature),
        Activity(title: "Offer to help someone", category: .kindness),
        Activity(title: "Play with a pet", category: .interaction),
        Activity(title: "Sit outside and listen", category: .mindfulness),
        Activity(title: "Trim your nails", category: .selfCare),
        Activity(title: "Floss your teeth", category: .selfCare),
        Activity(title: "Do some laundry", category: .home),
        Activity(title: "Journal", category: .mindfulness),
        Activity(title: "Draw", category: .creative),
        Activity(title: "Sing", category: .creative),
        Activity(title: "Play an instrument", category: .creative),
        Activity(title: "Talk with friends or family", category: .interaction),
        Activity(title: "Read a book", category: .creative),
        Activity(title: "Take a shower", category: .selfCare),
        Activity(title: "Water plants", category: .nature)
    ]
}

struct Activity {
    let title: String
    let category: Type
}

enum Type: String {
    case creative = "Creative"
    case home = "Around the home"
    case interaction = "Interaction"
    case kindness = "Act of kindness"
    case mindfulness = "Mindfulness"
    case nature = "Nature"
    case physical = "Physical"
    case selfCare = "Self Care"
}
