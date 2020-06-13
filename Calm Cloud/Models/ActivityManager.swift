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
        Activity(title: "Take a walk", category: .physical, id: 0),
        Activity(title: "Change your sheets", category: .home, id: 1),
        Activity(title: "Garden", category: .nature, id: 2),
        Activity(title: "Offer to help someone", category: .kindness, id: 3),
        Activity(title: "Play with a pet", category: .interaction, id: 4),
        Activity(title: "Sit outside and listen", category: .mindfulness, id: 5),
        Activity(title: "Trim your nails", category: .selfCare, id: 6),
        Activity(title: "Floss and brush teeth", category: .selfCare, id: 7),
        Activity(title: "Do some laundry", category: .home, id: 8),
        Activity(title: "Journal", category: .mindfulness, id: 9),
        Activity(title: "Draw", category: .creative, id: 10),
        Activity(title: "Sing", category: .creative, id: 11),
        Activity(title: "Play an instrument", category: .creative, id: 12),
        Activity(title: "Talk with friends or family", category: .interaction, id: 13),
        Activity(title: "Read a book", category: .creative, id: 14),
        Activity(title: "Take a shower", category: .selfCare, id: 15),
        Activity(title: "Water plants", category: .nature, id: 16)
    ]
}

struct Activity {
    let title: String
    let category: Type
    let id: Int
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
