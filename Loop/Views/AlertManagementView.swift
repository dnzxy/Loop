//
//  AlertManagementView.swift
//  Loop
//
//  Created by Nathaniel Hamming on 2022-09-09.
//  Copyright © 2022 LoopKit Authors. All rights reserved.
//

import SwiftUI
import LoopKit
import LoopKitUI

struct AlertManagementView: View {
    @Environment(\.appName) private var appName

    @ObservedObject private var checker: AlertPermissionsChecker
    @ObservedObject private var alertMuter: AlertMuter

    private var formatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.hour, .minute]
        return formatter
    }()

    private var enabled: Binding<Bool> {
        Binding(
            get: { alertMuter.configuration.shouldMute },
            set: { enabled in
                alertMuter.configuration.startTime = enabled ? Date() : nil
            }
        )
    }

    private var formattedSelectedDuration: Binding<String> {
        Binding(
            get: { formatter.string(from: alertMuter.configuration.duration)! },
            set: { newValue in
                guard let selectedDurationIndex = formatterDurations.firstIndex(of: newValue)
                else { return }
                DispatchQueue.main.async {
                    // avoid publishing during view update
                    alertMuter.configuration.duration = AlertMuter.allowedDurations[selectedDurationIndex]
                }
            }
        )
    }

    private var formatterDurations: [String] {
        AlertMuter.allowedDurations.compactMap { formatter.string(from: $0) }
    }
    
    private var missedMealNotificationsEnabled: Binding<Bool> {
        Binding(
            get: { UserDefaults.standard.missedMealNotificationsEnabled },
            set: { enabled in
                UserDefaults.standard.missedMealNotificationsEnabled = enabled
            }
        )
    }

    private var mealtimeReminderNotificationsEnabled: Binding<Bool> {
        Binding(
            get: { UserDefaults.standard.mealtimeReminderNotificationsEnabled },
            set: { enabled in
                UserDefaults.standard.mealtimeReminderNotificationsEnabled = enabled
            }
        )
    }

    public init(checker: AlertPermissionsChecker, alertMuter: AlertMuter = AlertMuter()) {
        self.checker = checker
        self.alertMuter = alertMuter
    }

    var body: some View {
        List {
            alertPermissionsSection
            if FeatureFlags.criticalAlertsEnabled {
                muteAlertsSection

                if alertMuter.configuration.shouldMute {
                    mutePeriodSection
                }
            }
            missedMealAlertSection
            mealtimeReminderAlertSection
        }
        .navigationTitle(NSLocalizedString("Alert Management", comment: "Title of alert management screen"))
    }

    private var alertPermissionsSection: some View {
        Section(footer: DescriptiveText(label: String(format: NSLocalizedString("Notifications give you important %1$@ app information without requiring you to open the app.", comment: "Alert Permissions descriptive text (1: app name)"), appName))) {
            NavigationLink(destination:
                            NotificationsCriticalAlertPermissionsView(mode: .flow, checker: checker))
            {
                HStack {
                    Text(NSLocalizedString("Alert Permissions", comment: "Alert Permissions button text"))
                    if checker.showWarning ||
                        checker.notificationCenterSettings.scheduledDeliveryEnabled {
                        Spacer()
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.critical)
                    }
                }
            }
        }
    }

    @ViewBuilder
    private var muteAlertsSection: some View {
        Section(footer: muteAlertsSectionFooter) {
            Toggle(NSLocalizedString("Mute All Alerts", comment: "Label for toggle to mute all alerts"), isOn: enabled)
        }
    }

    private var mutePeriodSection: some View {
        SingleSelectionCheckList(header: NSLocalizedString("Select Mute Period", comment: "List header for mute all alerts period"), footer: muteAlertsFooterString, items: formatterDurations, selectedItem: formattedSelectedDuration)
    }

    @ViewBuilder
    private var muteAlertsSectionFooter: some View {
        if !alertMuter.configuration.shouldMute {
            DescriptiveText(label: muteAlertsFooterString)
        }
    }

    private var muteAlertsFooterString: String {
        NSLocalizedString("No alerts will sound while muted. Once this period ends, your alerts and alarms will resume as normal.", comment: "Description of temporary mute alerts")
    }
    
    private var missedMealAlertSection: some View {
        Section(footer: DescriptiveText(label: NSLocalizedString("When enabled, Loop can notify you when it detects a meal that wasn't logged.", comment: "Description of missed meal notifications."))) {
            Toggle(NSLocalizedString("Missed Meal Notifications", comment: "Title for missed meal notifications toggle"), isOn: missedMealNotificationsEnabled)
        }
    }
    
    private var mealtimeReminderAlertSection: some View {
        Section(footer: DescriptiveText(label: NSLocalizedString("When activated, Loop can remind you of a meal you've pre-bolused for and it's time to eat. You can manually activate a mealtime reminder for each carbohydrate entry dated in the future (15min and more).", comment: "Description of mealtime reminder notifications."))) {
            Toggle(NSLocalizedString("Mealtime Reminder Notifications", comment: "Title for mealtime reminder notifications toggle"), isOn: mealtimeReminderNotificationsEnabled)
        }
    }
}

extension UserDefaults {
    private enum Key: String {
        case missedMealNotificationsEnabled = "com.loopkit.Loop.MissedMealNotificationsEnabled"
        case mealtimeReminderNotificationsEnabled = "com.loopkit.Loop.MealtimeReminderNotificationsEnabled"
    }
    
    var missedMealNotificationsEnabled: Bool {
        get {
            return object(forKey: Key.missedMealNotificationsEnabled.rawValue) as? Bool ?? false
        }
        set {
            set(newValue, forKey: Key.missedMealNotificationsEnabled.rawValue)
        }
    }
    
    var mealtimeReminderNotificationsEnabled: Bool {
        get {
            return object(forKey: Key.mealtimeReminderNotificationsEnabled.rawValue) as? Bool ?? false
        }
        set {
            set(newValue, forKey: Key.mealtimeReminderNotificationsEnabled.rawValue)
        }
    }
}

struct AlertManagementView_Previews: PreviewProvider {
    static var previews: some View {
        AlertManagementView(checker: AlertPermissionsChecker(), alertMuter: AlertMuter())
    }
}
