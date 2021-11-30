//
//  Sounds.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 5/6/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import Foundation
import AVFoundation
import AudioToolbox

class Sound {
    var resourceName: String
    var type: String
    
    init(resourceName: String, type: String) {
        self.resourceName = resourceName
        self.type = type
    }
    
    static var calmMusicPlayer: AVAudioPlayer?
    
    static func loadSound(resourceName: String, type: String) {
        let path = Bundle.main.path(forResource: resourceName, ofType: type)
        let soundURL = URL(fileURLWithPath: path!)
       
        do {
            calmMusicPlayer = try AVAudioPlayer(contentsOf: soundURL)
            calmMusicPlayer?.numberOfLoops = -1
        } catch {
            print("could not load file")
        }
    }
    
    static func startPlaying() {
        calmMusicPlayer?.play()
    }
    
    static func stopPlaying() {
        calmMusicPlayer?.stop()
    }
}

class FireSound {
    var resourceName: String
    var type: String
    
    init(resourceName: String, type: String) {
        self.resourceName = resourceName
        self.type = type
    }
    
    static var firePlayer: AVAudioPlayer?
    
    static func loadSound(resourceName: String, type: String) {
        let path = Bundle.main.path(forResource: resourceName, ofType: type)
        let soundURL = URL(fileURLWithPath: path!)
        
        do {
            firePlayer = try AVAudioPlayer(contentsOf: soundURL)
            firePlayer?.numberOfLoops = -1
        } catch {
            print("could not load file")
        }
    }
    
    static func startPlaying() {
        firePlayer?.play()
    }
    
    static func stopPlaying() {
        firePlayer?.stop()
    }
}

class SoundEffect {
    var number: SystemSoundID
    var resourceName: String
    var type: String

    init(number: SystemSoundID, resourceName: String, type: String) {
        self.number = number
        self.resourceName = resourceName
        self.type = type
    }

    static func loadSound(number: inout SystemSoundID, resourceName: String, type: String) {
        let path = Bundle.main.path(forResource: resourceName, ofType: type)
        let soundURL = URL(fileURLWithPath: path!)
        AudioServicesCreateSystemSoundID(soundURL as CFURL, &number)
    }

    static func playSound(number: SystemSoundID) {
        AudioServicesPlaySystemSound(number)
    }
}


struct Sounds {
    // SPRING/SUMMER
    
    static let outside = Sound(resourceName: "audio_hero_ForestDay_DIGIX05_11_362", type: "mp3")
    static let night = Sound(resourceName: "audio_hero_NightAmbienceCalm+PE011801", type: "mp3")
    // also indoors nighttime sound
    
    static let inside = Sound(resourceName: "tspt_city_spring_indoor_ambience_loop_019", type: "mp3")
    static let insideNight = Sound(resourceName: "Blastwave_FX_NightCornField_S011AM.8", type: "mp3")
    
    // RAIN
    
    static let rainOutdoors = Sound(resourceName: "zapsplat_nature_rain_internal_home_rec_open_window_occ_cars_pass_low_thunder_rumbles_001_25102", type: "mp3")
    static let rainIndoors = Sound(resourceName: "west_wolf_Rear_Street_City_Rain_With_Thunders", type: "mp3")
    
    // FALL/WINTER
    
    static let outsideFallWinter = Sound(resourceName: "zapsplat_nature_forest_ambience_wind_trees_birds_leaves_fall_to_ground_autumn_20090", type: "mp3")
    static let outsideFallWinterNight = Sound(resourceName: "zapsplat_horror_graveyard_ambience_night_wind_owls_43583", type: "mp3")
    
    static let insideFallWinter = Sound(resourceName: "kedr_sfx_stockholm_roomtone_flat_day_closed_window_ac_hum_calm_street_sounds_behind_wall", type: "mp3")
    static let insideFallWinterNight = Sound(resourceName: "weather-wind-trees-bushes-countryside", type: "mp3")
    
    static let snow = Sound(resourceName: "spa_snowstorm_ambience_snow_falling_on_ground_with_wind", type: "mp3")
    
    static let fire = FireSound(resourceName: "audio_hero_FireMediumRoarHiss_PE052201_358", type: "mp3")
    
    // music
    static let music = Sound(resourceName: "loire", type: "mp3")

    // game
    static let gameMusic = Sound(resourceName: "music_zapsplat_game_music_childrens_soft_arp_warm_fun_001", type: "mp3")

    static let pop = SoundEffect(number: 1, resourceName: "zapsplat_multimedia_cell_phone_smart_screen_button_press_click_feedback_002_60931", type: "mp3")
    static let gameOver = SoundEffect(number: 2, resourceName: "zapsplat_multimedia_notification_digital_bell_warm_success_53924", type: "mp3")
}

// Forest Autumn Ambience, Outdoor Owl Night Ambience, Rain Ambience, and Wind Ambience by Zapsplat
// Snowstorm Ambience by Silverplatter Audio on Zapsplat
// City Rain by West Wolf on Zapsplat
// Night Ambience, Forest Ambience, and Fire Ambience by Audio Hero on Zapsplat
// Room Tone by KEDR FX on Zapsplat
// Indoor Ambience by The Sound Pack Tree on Zapsplat
// Cornfield Ambience by BlastWave FX on Zapsplat
// Loire and You Will Know by Taylor Howard on Zapsplat
// Calm game music and pop by Zapsplat
