# Calm Cloud
A calming, whimsical world.
[Visit on the App Store](https://apps.apple.com/us/app/id1503747823)

![Screenshot of the app Calm Cloud](https://i.ibb.co/qkD414s/Screen-Shot-2020-08-05-at-2-29-28-PM.png)

## Description
Calm Cloud invites you to enter into the calming, whimsical world of Zen, the cloud kitty! Ease your mind by caring for Zen daily, completing simple tasks, and growing and harvesting plants in the outdoor garden!

Relax with soothing ambient background sounds, charming animations, and easy-to-use features to help manage and reduce your stress.

Features include:

* Gentle gameplay that is easy and soothing
* Cute and whimsically fanciful art
* Interactive toys, lights, and more
* Surprise deliveries!
* Leveling system with special level-specific unlocks
* Lights off mode for tranquil relaxation
* Outdoor garden; water, harvest, and watch plants grow!
* Various seedlings - customize your garden
* Honor stand for selling garden goodies
* Store for purchasing more seedlings and currency
* Photo collection for your favorite things
* Daily thankfulness journal for mindfulness
* Reminders, delivered via notification, both daily and one-time
* Soothing activities that can be completed each day
* Two fun mini-games
* Different day and night visuals and atmospheres
* Daily task sheet with achievable, fulfilling goals

## Features
Calm Cloud has a number of features that all work together to provide a calming and fulfilling stress reduction experience. The main element is a gamified view with an imaginary creature - a cloud kitty - that the user takes care of and can interact with daily. Besides the main interior room, the user/cloud kitty can also visit the outdoor garden, where they can plant and care for seedlings (which arrive via delivery on level up, or can be purchased in the shop for coins), watch them grow, then harvest them! The user can then choose to sell harvested plants for coins in an honor stand, or donate them for experience points. Other helpful features, like reminders, favorite photos, soothing activities, a thankfulness journal, and an achievable daily task sheet are included to help create structure and provide support.

### Animation
Animations are an integral part of the look of the app, giving dynamism to the cloud kitty's movements, and to the user's interaction with touch-activated elements (ie toys) in the little world within the app. The way Zen (the cloud kitty) moves is randomized, and her expressions are based on her mood, which depends on which care actions the user has taken recently. Zen will exhibit hunger or thirst if her food or water have run out, and embarassment if her potty has not been cleaned.

### Gamification 
Gamification, through caring for Zen in a low-pressure tamagotchi style along with maintaining the garden, provides an easygoing element of fun. Users accumulate experience points (EXP) through both indoors care actions (providing food, water, and potty cleaning) and outdoor garden actions (planting, watering, and harvesting). A flat leveling system allows the user to progress through levels with more EXP required to reach each successive level. Certain features - indoor string lights, record player, and outdoor hanging lights - require a certain level achievement to activate, providing goals for users to work towards. 

### Core Data
Throughout the app information is persisted via Core Data, including records of reminders, journal entries, document paths for photos, and tracking of achievements, level status, currency, and daily tasks. All of this data is saved locally on the device, and is thus private and non public-facing. 

### Notifications
The reminders feature of the app takes advantage of local device notifications to notify users of reminders they have created. The reminders can be one-time only (such as a reminder of a non-recurring appointment) or can be daily (such as a reminder to feed a pet). Users can delete reminders, which will delete the associated notifications that have been set as well. This feature is dependent upon the user having allowed the app to send notifications.

### Image Picker
The favorites element of the app allows users to create a collection of photos of their favorite things, which relies on the use of an image picker. This picker allows selection of photos on the user's device, and relies on image paths to retrieve them, so the image files themselves are not duplicated and thus do not waste application space. 

### In-App Purchases
In App Purchases (IAP) have been incorporated into the app in order to allow users to purchase additional currency (coins). These coins can be used to purchase more seedlings to plant in the garden, and can also be earned separately within the app from sales of grown plants at honor stand, and through awards or random events. IAP allow a user the option to acquire these coins more easily and more quickly, so they can begin buying and planting their favorites seedlings in the garden sooner.

### Sounds
Ambient background sounds and some music are used within the app to provide a soothing, restful atmosphere and vary depending upon conditions. These sounds were created by contributers Audio Hero, The Sound Pack Tree, BlastWave FX, and Taylor Howard on [Zapsplat.com](https://www.zapsplat.com).

## Art
All of the art used within the app was created by the developer for exclusive use within this app, and belongs to no one else.

## Dependencies
[OpenSSL-Universal](https://cocoapods.org/pods/OpenSSL-Universal) handles cryptography to help secure receipt validation. [Cocoapods](https://github.com/CocoaPods/CocoaPods) has been used as the dependency manager for this project - please refer to Cocoapods documentation for details.

The integration of these items in the Podfile for this project is as follows:
```
pod 'OpenSSL-Universal'
```

Details on use of each dependency and the Cocoapods manager itself can be found in the links already included.

## Support
If you experience trouble using the app, have any questions, or simply want to contact me, you can contact me via email at kduncanwelke@gmail.com. I will be happy to discuss this project.
