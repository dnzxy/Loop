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
    
    func generateMealtimeReminder(carbEntry: StoredCarbEntry) {
        var reminderDates = futureCarbEntries.map({ $0.startDate })
        NotificationManager.removeUnnecessaryMealtimeReminderNotifications(reminderDates: reminderDates)
        
        futureCarbEntries.append(carbEntry)
        reminderDates.append(carbEntry.startDate)
        
        for reminderDate in reminderDates {
            NotificationManager.sendMealtimeReminderNotification(mealtime: reminderDate)
        }
    }
    
}
