//
//  MealtimeReminderManager.swift
//  Loop
//
//  Created by Deniz Cengiz on 04/27/23.
//  Copyright © 2023 LoopKit Authors. All rights reserved.
//

import Foundation
import LoopKit
import UserNotifications

class MealtimeReminderManager {
    // TODO: add logging
    
    private var futureCarbEntries: [StoredCarbEntry]
    
    public init() {
        print("Hey there, it's Mealtime Reminder Manager ⏰")
        
        // keep track of the carb store entries that have mealtime notifications
        futureCarbEntries = []
    }
    
    // TODO: better way to keep in-memory `futureCarbEntries` in sync with carbStore?
    func getCarbStoreUpdates() {
        // get updates from carb store
        // if carb entry no longer in carb store, delete from futureCarbEntries
        // if carb entry has changed, update local copy ?
    }
    
    func hasEntryMealtimeReminder(carbEntry: StoredCarbEntry) -> Bool {
        return futureCarbEntries.contains(carbEntry)
    }
    
    func generateMealtimeReminder(carbEntry: StoredCarbEntry) {
//        // keep future entries in-memory store clean
//        self.removeExpiredEntries()
//
//        // store carb entries (flagged for mealtime reminder in carb entry view) in memory
//        futureCarbEntries.append(carbEntry)
//
//        // collect all reminder dates, set takes care of duplicates
//        var reminderDates = Set(futureCarbEntries.map({ $0.startDate }))
//
//        // remove all notifications with dates that are already in there
//        NotificationManager.removeUnnecessaryMealtimeReminderNotifications(reminderDates: reminderDates)
//
//        // add new future entry date to set of reminder dates
//        if !reminderDates.contains(carbEntry.startDate) {
//            reminderDates.insert(carbEntry.startDate)
//        }
//
//        // (re-)schedule reminder(s)
//        for reminderDate in reminderDates {
//            NotificationManager.sendMealtimeReminderNotification(mealtime: reminderDate)
//        }
        
//        NotificationManager.sendMealtimeReminderNotification(carbEntry: carbEntrymealtime: reminderDate)
    }
    
    func removeExpiredEntries() {
        let now = Date()
        
        futureCarbEntries = futureCarbEntries.filter({$0.startDate > now})
    }
    
}










// Notification Manager

// schedules meal notifications:
// use StoredCarbEntry syncIdentifier as its unique

// -> call from bolusViewModel.saveCarbEnty
// if theres a notif. -> take the replaceEntry, take that UUID, delete the corresponding notif.
// --> take new entry's UUID -> schedule notif w/ UUID

// deleteCarbEntry -> carb absorption view controller
// -> take entryToDel UUID -> delete scheduled notif.


