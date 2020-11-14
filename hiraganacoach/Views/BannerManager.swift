//
//  BannerManager.swift
//  hiraganacoach
//
//  Created by Maxson Yang on 11/13/20.
//

import Foundation
import SwiftUI
import NotificationBannerSwift

struct Banners
{
    
    static func getMasteredBanner() -> FloatingNotificationBanner
    {
        let banner = FloatingNotificationBanner(title: "Great work!",
                                                subtitle: "You're ready to move onto the next section!",
                                                style: .success)
        banner.backgroundColor = .mellowLime
        return banner
    }
    
    static func getLocalStreakRecordBanner(section: String) -> FloatingNotificationBanner
    {
        let banner = FloatingNotificationBanner(title: "Streak Broken!",
                                                subtitle: "You just broke your streak record for \(section)",
                                                leftView: Image(systemName: "star.fill")
                                                    .font(.system(size: 24.0))
                                                    .foregroundColor(.white) as? UIView,
                                                style: .warning)
        banner.backgroundColor = .rainyBlue
        banner.dismissOnTap = true
        return banner
    }
    
    static func getGlobalStreakRecordBanner(section: String) -> FloatingNotificationBanner
    {
        let banner = FloatingNotificationBanner(title: "New Record!",
                                                subtitle: "This is your highest streak ever! Keep it up",
                                                leftView: Image(systemName: "flame")
                                                    .font(.system(size: 24.0))
                                                    .foregroundColor(.white) as? UIView,
                                                style: .danger)
        banner.backgroundColor = .starYellow
        banner.dismissOnTap = true
        return banner
    }
    
    static func getScoreAchievementBanner(score: Int) -> FloatingNotificationBanner
    {
        let banner = FloatingNotificationBanner(title: "Score Milestone Achieved!",
                                                subtitle: "You've scored \(score) points for this section",
                                                leftView: Image(systemName: "exclamationmark.circle.fill")
                                                    .font(.system(size: 24.0))
                                                    .foregroundColor(.white) as? UIView,
                                                style: .success)
        banner.dismissOnTap = true
        banner.backgroundColor = .cyanProcess
        return banner
    }
    
}
