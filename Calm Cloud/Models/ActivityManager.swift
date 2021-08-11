//
//  ActivityManager.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 4/9/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import Foundation

struct ActivityManager {

    static var loaded: [ActivityId] = []
    static var completion: [Int : Bool] = [:]
    static var searchResults: [Activity] = []

    static let activities = [
        Activity(title: "Draw", category: .creative, id: 10),
        Activity(title: "Try breathing exercises", category: .mindfulness, id: 26),
        Activity(title: "Listen to music", category: .creative, id: 27),
        Activity(title: "Do yoga", category: .physical, id: 49),
        Activity(title: "Clean a room", category: .home, id: 21),
        Activity(title: "Garden", category: .nature, id: 2),
        Activity(title: "Take photos outside", category: .nature, id: 35),
        Activity(title: "Play an instrument", category: .creative, id: 12),
        Activity(title: "Do a coloring page", category: .creative, id: 17),
        Activity(title: "Play with a pet", category: .interaction, id: 4),
        Activity(title: "Do laundry", category: .home, id: 8),
        Activity(title: "Sit outside and listen", category: .mindfulness, id: 5),
        Activity(title: "Meditate", category: .mindfulness, id: 25),
        Activity(title: "Dance to music", category: .physical, id: 23),
        Activity(title: "Bake cookies", category: .creative, id: 32),
        Activity(title: "Open windows for air", category: .nature, id: 33),
        Activity(title: "Vacuum", category: .home, id: 19),
        Activity(title: "Phone or text someone", category: .interaction, id: 41),
        Activity(title: "Play a relaxing game", category: .interaction, id: 37),
        Activity(title: "Go for a run", category: .physical, id: 22),
        Activity(title: "Game with friends", category: .interaction, id: 42),
        Activity(title: "Talk with friends or family", category: .interaction, id: 13),
        Activity(title: "Do some dusting", category: .home, id: 39),
        Activity(title: "Perform an act of kindness", category: .kindness, id: 47),
        Activity(title: "Make origami", category: .creative, id: 34),
        Activity(title: "Listen to ambient noise", category: .mindfulness, id: 28),
        Activity(title: "Write a letter", category: .interaction, id: 44),
        Activity(title: "Floss and brush teeth", category: .selfCare, id: 7),
        Activity(title: "Take a walk", category: .physical, id: 0),
        Activity(title: "Have a spa day", category: .selfCare, id: 48),
        Activity(title: "Write down your thoughts", category: .mindfulness, id: 36),
        Activity(title: "Hike on a nature trail", category: .nature, id: 50),
        Activity(title: "Write a thank you note", category: .kindness, id: 51),
        Activity(title: "Make a calm jar", category: .creative, id: 30),
        Activity(title: "Assemble a to-do list", category: .mindfulness, id: 24),
        Activity(title: "Take a shower", category: .selfCare, id: 15),
        Activity(title: "Journal", category: .mindfulness, id: 9),
        Activity(title: "Water plants", category: .nature, id: 16),
        Activity(title: "Offer to help someone", category: .kindness, id: 3),
        Activity(title: "Plant an herb garden", category: .home, id: 40),
        Activity(title: "Take a nap", category: .selfCare, id: 18),
        Activity(title: "Change your sheets", category: .home, id: 1),
        Activity(title: "Read a book", category: .creative, id: 14),
        Activity(title: "Take a bubble bath", category: .selfCare, id: 29),
        Activity(title: "Make a gift for someone", category: .kindness, id: 43),
        Activity(title: "Make a box of donations", category: .kindness, id: 20),
        Activity(title: "Trim your nails", category: .selfCare, id: 6),
        Activity(title: "Check on a friend", category: .kindness, id: 45),
        Activity(title: "Stretch your muscles", category: .physical, id: 38),
        Activity(title: "Swing on a porch swing", category: .physical, id: 31),
        Activity(title: "Sing", category: .creative, id: 11),
        Activity(title: "Chat with friends online", category: .interaction, id: 52),
        Activity(title: "Bird watch", category: .nature, id: 46),
        Activity(title: "Write down your favorite things", category: .mindfulness, id: 53),
        Activity(title: "Call a friend", category: .interaction, id: 54),
        Activity(title: "Watch funny videos", category: .selfCare, id: 55),
        Activity(title: "Organize part of a room", category: .home, id: 56),
        Activity(title: "Make a wish list", category: .selfCare, id: 57),
        Activity(title: "Do yard work", category: .physical, id: 58),
        Activity(title: "Start a craft project", category: .creative, id: 59),
        Activity(title: "Give someone a compliment", category: .kindness, id: 60),
        Activity(title: "Pull weeds", category: .nature, id: 61),
        Activity(title: "Lift weights", category: .physical, id: 62),
        Activity(title: "Close your eyes and listen", category: .mindfulness, id: 63),
        Activity(title: "Pumice your hands or feet", category: .selfCare, id: 64),
        Activity(title: "Visit a park", category: .nature, id: 65),
        Activity(title: "Write a short story", category: .creative, id: 66),
        Activity(title: "Watch a favorite show or movie", category: .selfCare, id: 67),
        Activity(title: "Volunteer", category: .kindness, id: 68),
        Activity(title: "Decorate for a holiday or season", category: .home, id: 69),
        Activity(title: "Walk with a friend", category: .interaction, id: 70),
        Activity(title: "Research hobbies to try", category: .mindfulness, id: 71),
        Activity(title: "Sit under a tree", category: .nature, id: 72),
        Activity(title: "Ride a bike", category: .physical, id: 73),
        Activity(title: "Wash the dishes", category: .home, id: 74),
        Activity(title: "Cook for someone", category: .kindness, id: 75)
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
