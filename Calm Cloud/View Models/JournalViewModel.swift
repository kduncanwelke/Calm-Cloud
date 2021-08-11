//
//  JournalViewModel.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 8/3/21.
//  Copyright © 2021 Kate Duncan-Welke. All rights reserved.
//

import Foundation
import UIKit

public class JournalViewModel {

    var days: [Int] = []
    var currentPage = 0
    var direction = 0
    var monthBeginning: Date?
    var selectedFromCalendar: Int?
    var monthName = ""

    // MARK: Cells/collection view

    func getDayCount() -> Int {
        return days.count
    }

    func getDateLabel(index: Int) -> String {
        if days[index] == 0 {
            return ""
        } else {
            return "\(days[index])"
        }
    }

    func getBackgroundColor(index: Int) -> UIColor {
        if days[index] == 0 {
            return.white
        } else if days[index] % 2 == 0 {
            return Colors.pink
        } else {
            return .white
        }
    }

    func isCheckMarkHidden(index: Int) -> Bool {
        let calendar = Calendar.init(identifier: .gregorian)
        var hideCheck = false

        if let beginning = monthBeginning {
            var components = DateComponents()
            components.year = calendar.component(.year, from: beginning)
            components.month = calendar.component(.month, from: beginning)
            components.day = days[index]

            if let calendarDate = calendar.date(from: components) {
                for entry in EntryManager.loadedEntries {
                    if let date = entry.date {
                        if Calendar.current.isDate(date, inSameDayAs: calendarDate) {
                            print("day match found")
                            hideCheck = false
                            return hideCheck
                        } else {
                            print("day match not found")
                            hideCheck = true
                        }
                    } else {
                        hideCheck = true
                    }
                }
            }
        }

        return hideCheck
    }

    func isDayViewable(index: Int) -> Bool {
        if days[index] == 0 {
            return false
        } else {
            return true
        }
    }

    func selected(index: Int) -> Bool {
        let calendar = Calendar.init(identifier: .gregorian)

        if let beginning = monthBeginning {
            var components = DateComponents()
            components.year = calendar.component(.year, from: beginning)
            components.month = calendar.component(.month, from: beginning)
            components.day = days[index]

            if let calendarDate = calendar.date(from: components) {
                var i = 0

                for entry in EntryManager.loadedEntries {
                    if let date = entry.date {
                        if Calendar.current.isDate(date, inSameDayAs: calendarDate) {
                            selectedFromCalendar = i
                            print("match found")
                            break
                        } else {
                            selectedFromCalendar = nil
                            print("match not found")
                        }
                    }

                    i += 1
                }
            }
        }

        if selectedFromCalendar != nil {
            return true
        } else {
            return false
        }
    }

    // MARK: Journal Entry

    func getMonthName() -> String {
        return monthName
    }

    func saveButtonEnabled() -> Bool {
        if let currentEntry = EntryManager.entry, let content = currentEntry.text {
            return false
        } else {
            return true
        }
    }

    func getEntryDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        if let entry = EntryManager.entry, let chosenDate = entry.date {
            return dateFormatter.string(from: chosenDate)
        } else {
            return dateFormatter.string(from: Date())
        }
    }

    func getEntryText() -> String {
        if let entry = EntryManager.entry, let content = entry.text {
            return content
        } else {
            return "Start typing . . ."
        }
    }

    func isEditable() -> Bool {
        if let entry = EntryManager.entry, let content = entry.text {
            return false
        } else {
            return true
        }
    }

    func increaseDirection() {
        direction += 1
    }

    func decreaseDirection() {
        direction -= 1
    }

    func goForward() -> Bool {
        if currentPage > 0 {
            currentPage -= 1
            EntryManager.entry = EntryManager.loadedEntries[currentPage]
            return true
        } else {
            return false
        }
    }

    func goBackward() -> Bool {
        if currentPage < EntryManager.loadedEntries.count - 1 {
            currentPage += 1
            EntryManager.entry = EntryManager.loadedEntries[currentPage]
            return true
        } else {
            return false
        }
    }

    func viewEntry() {
        if let selected = selectedFromCalendar {
            currentPage = selected
            EntryManager.entry = EntryManager.loadedEntries[currentPage]
        }
    }

    func configureEntry() {
        if currentPage == 0 {
            if EntryManager.loadedEntries.isEmpty {
                // if there are no entries add a blank one
                var managedContext = CoreDataManager.shared.managedObjectContext
                EntryManager.loadedEntries.insert(JournalEntry(context: managedContext), at: 0)
            } else {
                // if the entry's first item does not match the current date there is no entry for today, so add a blank one
                if let firstEntry = EntryManager.loadedEntries.first, let dateofEntry = firstEntry.date {
                    let calendar = Calendar.init(identifier: .gregorian)
                    let entryIsForToday = calendar.isDate(dateofEntry, inSameDayAs: Date())

                    if entryIsForToday == false {
                        var managedContext = CoreDataManager.shared.managedObjectContext
                        EntryManager.loadedEntries.insert(JournalEntry(context: managedContext), at: 0)
                    }
                }
            }
        }

        if EntryManager.loadedEntries.count > 0 {
            EntryManager.entry = EntryManager.loadedEntries[currentPage]
        }
    }

    func configureCalendar() {
        let calendar = Calendar.init(identifier: .gregorian)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none

        // show initial calendar page for current month
        let today = Date()
        days.removeAll()

        if let monthToShow = calendar.date(byAdding: .month, value: direction, to: today) {
            let comps = calendar.dateComponents([.year, .month], from: monthToShow)

            let monthFormatter = DateFormatter()
            monthFormatter.dateFormat = "LLLL YYYY"
            let nameOfMonth = monthFormatter.string(from: monthToShow)
            monthName = nameOfMonth

            if let firstOfMonth = calendar.date(from: comps) {
                monthBeginning = firstOfMonth
                let dayOfWeek = calendar.component(.weekday, from: firstOfMonth)

                var comps2 = DateComponents()
                comps2.month = 1
                comps2.day = -1
                let endOfMonth = Calendar.current.date(byAdding: comps2, to: firstOfMonth)

                if dayOfWeek != 1 {
                    let daysToAdd = dayOfWeek - 1
                    for day in 1...daysToAdd {
                        days.append(0)
                    }
                }

                if let end = endOfMonth {
                    let endDay = calendar.component(.day, from: end)

                    for day in 1...endDay {
                        days.append(day)
                    }
                }
            }
        }
    }

    func saveEntry(text: String?) -> Bool? {
        if text != nil && text != "Start typing . . ." {
            var managedContext = CoreDataManager.shared.managedObjectContext

            EntryManager.entry?.date = Date()
            EntryManager.entry?.text = text

            // remove empty placeholder
            EntryManager.loadedEntries.remove(at: 0)

            guard let newEntry = EntryManager.entry else { return nil }

            EntryManager.loadedEntries.insert(newEntry, at: 0)

            do {
                try managedContext.save()
                print("saved entry")

                if TasksManager.journal == false {
                    TasksManager.journal = true
                    DataFunctions.saveTasks(updatingActivity: false, removeAll: false)
                }

                return true
            } catch {
                // this should never be displayed but is here to cover the possibility
                //showAlert(title: "Save failed", message: "Notice: Data has not successfully been saved.")
                return nil
            }
        } else {
            print("text view was empty or nil")
            return nil
        }
    }

}
