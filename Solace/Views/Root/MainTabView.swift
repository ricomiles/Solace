import SwiftUI

struct MainTabView: View {
    @Environment(AppState.self) private var appState
    var body: some View {
        @Bindable var bindableState = appState

        TabView {
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }

            NavigationStack {
                CalendarView()
            }
            .tabItem {
                Label("Calendar", systemImage: "calendar")
            }

            NavigationStack {
                SearchView()
            }
            .tabItem {
                Label("Search", systemImage: "magnifyingglass")
            }

            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Label("You", systemImage: "person.fill")
            }
        }
        .tint(.solaceTerra200)
        .fullScreenCover(isPresented: $bindableState.showMoodCheckIn) {
            MoodCheckInView()
        }
        .fullScreenCover(isPresented: $bindableState.showFocusedWriting) {
            FocusedWritingView()
        }
        .fullScreenCover(isPresented: $bindableState.showPromptedWriting) {
            PromptedWritingView()
        }
    }
}
