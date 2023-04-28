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
    
    func getCarbStoreUpdates() {
        // get updates from carb store
        // if carb entry no longer in carb store, delete from futureCarbEntries
        // if carb entry has changed, update local copy ?
    }
    
    func generateMealtimeReminder(carbEntry: StoredCarbEntry) {
        // store carb entries (flagged for mealtime reminder in carb entry view) in memory
        futureCarbEntries.append(carbEntry)
                
    }
    
    func manageMealtimeReminderNotifications() {
        // schedule notifications
        
        // remove unwanted pending notifications
    }
}
