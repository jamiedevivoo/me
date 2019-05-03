import UIKit

final class FeedManager {
    static fileprivate var sharedInstance: FeedManager?
    private init() {}
}
    
// MARK: Access Methods for Managing shared Instance
extension FeedManager {
    static func shared() -> FeedManager {
        guard let sharedInstance = sharedInstance else { return FeedManager() }
        return sharedInstance
    }
    
    static func destroy() {
        sharedInstance = nil
    }
}






// Feed Message - Header and Time - Methods
extension FeedManager {
    private func generateGreeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 00...03: return "zzz"
        case 04...06: return "Early Morning!"
        case 07...10: return "Good Morning,"
        case 10...12: return "It's Lunchtime!"
        case 12...17: return "Good Afternoon,"
        case 17...22: return "Good Evening,"
        case 22...24: return "Good Night,"
        default:      return "Welcome"
        }
    }
}

// Feed Message - Contextual Message - Methods
extension FeedManager {
    
    func generateMessage(
        forAccount account: Account,
        withHighlights highlights: [Highlight],
        withMoods moods: [MoodLog],
        withInsight insightss: [Insight],
        withActions actionLogs: [SentimentLog],
        withSentimentLogs sentimentLogs: [ActionLog])
    -> (message: String, responses: [FeedMessageResponse]) {
        
        /// Priority 0 - Logic for when user is in tutorial mode
        if account.flags.tutorialIsActive {
            
            /// Priority 0.1 - Catch users who haven't logged a mood
            guard !(moods.count < 1) else {
                return (
                ["Welcome to Self! You're amazing! Let's log your first mood.",
                 "You're amazing! Welcome to Self! How are you feeling?"	
                ].randomElement()!,
                [FeedMessageResponse(title: "✏️ Log my first mood", action: "N/A", sentimentTrend: .neutral)])
            }
            
            /// Priority 0.2 - Catch users who haven't responded to a message
            guard !(sentimentLogs.count < 2) else {
                return (
                ["Great work! This screen will reguarly update with the latest advice and messages, You can use the emoji's below to respond to each message and help me get to know you better. Try it now!",
                 "Awesome! I'll keep hold of that for you. Every day I'll help you reflect on yourself with advice and messages like this. You can use the emoji's below to respond to each message and help me get to know you better. Try it"
                ].randomElement()!,
                [FeedMessageResponse(title: "🎉", action: "N/A", sentimentTrend: .neutral),
                 FeedMessageResponse(title: "🤔", action: "N/A", sentimentTrend: .neutral)])
            }
            
            /// Priority 0.3 - Catch users who haven't tapped SOS yet
            guard !(sentimentLogs.count < 3) else {
                return (
                ["No one feels 100% all of the time, for those times when you're feeling down, look out for the SOS button to find useful crisis sources and advice. It's also always visible in the sidebar. Try tapping it now.",
                 "If you're ever feeling really down and need some help, look out for the SOS button. You can also find it in the sidebar. Tap it now to see what's available."
                ].randomElement()!,
                [FeedMessageResponse(title: "🆘", action: "N/A", sentimentTrend: .neutral)])
            }

            /// Priority 0.4 - Catch users who haven't chosen a challenge yet
           guard !(actionLogs.count < 1) else {
                return (
                ["Ready for your first challenge? Let's go!",
                 "Every day you'll get a challenge to complete, let's see what today's is!"
                ].randomElement()!,
                [FeedMessageResponse(title: "👍", action: "N/A", sentimentTrend: .neutral),
                 FeedMessageResponse(title: "👎", action: "N/A", sentimentTrend: .neutral)])
            }
            
            /// Priority 0.5 - Catch users who haven't completed their account yet
            guard account.flags.accountIsComplete else {
                return (
                ["Self is all about you. As the app learns from you and get's to know you you'll unlock insights, highlights and trophies. When you're ready to exlore more of Self, finish creating your account below.",
                 "Wow, you've already covered the basics! But there's still so much more. To unlock highlights, insights and trophies, finish creating your account below and continue using the app to track and improve your wellbeing."
                ].randomElement()!,
                [FeedMessageResponse(title: "✓ Complete my account", action: "N/A", sentimentTrend: .positive)])
            }
            
        }
        
        if !account.flags.tutorialIsActive && account.flags.accountIsComplete {
        
//            /// Priority 1 - Logic for when user is in tutorial mode
//            if account.flags.tutorialIsActive {
//                return(
//                ["Did you know Mondays are your happiest days? Let’s rock today!",
//                 "Did you know Mondays are your happiest days? Let’s rock today!"
//                ].randomElement()!,
//                [FeedMessageResponse(title: "💪", action: "NA", sentimentTrend: .positive),
//                 FeedMessageResponse(title: "😔", action: "NA", sentimentTrend: .negative)])
//            }
//
//            /// Priority 1 - Logic for when user is in tutorial mode
//            if account.flags.tutorialIsActive {
//
//            }
        
            // Unlock today's Challenge!
            // How is the daily challenge going?
            // Low mood
            // How are you today
            // Mood logged but no wildcard question
            // New unviewed Insight
            // Mood reminders
            
            // fun Facts
            
            // Day Commentary
            
            
            // + Automatically add SOS if mood is low
            
            
            
        
        }
        
        return ("hey", [FeedMessageResponse(title: "✓ Complete my account", action: "N/A", sentimentTrend: .positive)])

    }
}

// Feed Action Methods
extension FeedManager {

}
