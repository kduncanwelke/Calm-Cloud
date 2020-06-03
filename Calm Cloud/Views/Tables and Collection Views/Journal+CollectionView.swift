//
//  Journal+CollectionView.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 6/2/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import Foundation
import UIKit

extension JournalViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return days.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calendarCell", for: indexPath) as! CalendarCollectionViewCell
        
        let day = days[indexPath.row]
       
        if day == 0 {
            cell.dateLabel.text = ""
        } else {
            cell.dateLabel.text = "\(day)"
        }
        
        if day == 0 {
            cell.backgroundColor = .white
        } else if day % 2 == 0 {
            cell.backgroundColor = Colors.pink
        } else {
            cell.backgroundColor = .white
        }
        
        if let beginning = monthBeginning {
            var components = DateComponents()
            components.year = calendar.component(.year, from: beginning)
            components.month = calendar.component(.month, from: beginning)
            components.day = day
            
            if let calendarDate = calendar.date(from: components) {
                for entry in EntryManager.loadedEntries {
                    if let date = entry.date {
                        if Calendar.current.isDate(date, inSameDayAs: calendarDate) {
                            cell.checkMark.isHidden = false
                            print("day match found")
                            break
                        } else {
                            cell.checkMark.isHidden = true
                            print("day match not found")
                        }
                    } else {
                        cell.checkMark.isHidden = true
                    }
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tappedCell = collectionView.cellForItem(at:indexPath) as! CalendarCollectionViewCell
        let day = days[indexPath.row]
        tappedCell.backgroundColor = Colors.blue
        // show this journal entry or give option to go to
        
        if let beginning = monthBeginning {
            var components = DateComponents()
            components.year = calendar.component(.year, from: beginning)
            components.month = calendar.component(.month, from: beginning)
            components.day = day
            
            if let calendarDate = calendar.date(from: components) {
                var index = 0
                for entry in EntryManager.loadedEntries {
                    
                    if let date = entry.date {
                        if Calendar.current.isDate(date, inSameDayAs: calendarDate) {
                            selectedFromCalendar = index
                            print("match found")
                            break
                        } else {
                            print("match not found")
                        }
                    }
                    
                    index += 1
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let tappedCell = collectionView.cellForItem(at:indexPath) as! CalendarCollectionViewCell
        let day = days[indexPath.row]
        
        if day == 0 {
            tappedCell.backgroundColor = .white
        } else if day % 2 == 0 {
            tappedCell.backgroundColor = Colors.pink
        } else {
            tappedCell.backgroundColor = .white
        }
        
        collectionView.deselectItem(at: indexPath, animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width
        let maxNumColumns = 7
        let cellWidth = (availableWidth / CGFloat(maxNumColumns)).rounded(.down)
        
        return CGSize(width: cellWidth, height: cellWidth)
    }
}
