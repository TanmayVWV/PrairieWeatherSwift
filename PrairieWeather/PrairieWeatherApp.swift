import SwiftUI

@main
struct PrairieWeatherApp: App {
    @StateObject private var vm = WeatherViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(vm)
                .task { await vm.load() }
        }
    }
}
