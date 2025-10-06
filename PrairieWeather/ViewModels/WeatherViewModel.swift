import Foundation

@MainActor
final class WeatherViewModel: ObservableObject {
    @Published var forecast: ForecastBundle?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let service: WeatherServicing

    init(service: WeatherServicing = WeatherService()) {
        self.service = service
        // Try warm-start from cache
        if let data = SimpleCache.load() {
            self.forecast = try? JSONDecoder().decode(ForecastBundle.self, from: data)
        }
    }

    func load() async {
        isLoading = true; errorMessage = nil
        do {
            let result = try await service.fetchSaskatoonForecast()
            self.forecast = result
            if let data = try? JSONEncoder().encode(result) { SimpleCache.save(data) }
        } catch {
            if forecast == nil { errorMessage = "Couldn’t fetch weather. Please try again." }
        }
        isLoading = false
    }

    func refresh() async { await load() }

    // Simple mapping from WMO weather codes to emojis (nice UX touch)
    func emoji(for code: Int) -> String {
        switch code {
        case 0: return "☀️"
        case 1,2,3: return "⛅️"
        case 45,48: return "🌫️"
        case 51,53,55,56,57: return "🌦️"
        case 61,63,65: return "🌧️"
        case 66,67,71,73,75,77,85,86: return "❄️"
        case 95,96,99: return "⛈️"
        default: return "🌤️"
        }
    }

    func formatted(_ date: Date) -> String {
        let f = DateFormatter(); f.dateFormat = "EEE, MMM d"
        return f.string(from: date)
    }
}
