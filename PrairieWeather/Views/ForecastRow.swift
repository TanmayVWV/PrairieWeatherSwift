import SwiftUI

struct ForecastRow: View {
    @EnvironmentObject var vm: WeatherViewModel
    let day: DailyForecast

    var body: some View {
        HStack {
            Text(vm.formatted(day.date))
                .font(.body)
                .accessibilityHidden(true)

            Spacer()

            Text("\(Int(day.minTemp))° / \(Int(day.maxTemp))°")
                .monospacedDigit()

            Text(vm.emoji(for: day.weatherCode))
                .font(.title3)
                .accessibilityLabel("Weather code \(day.weatherCode)")
        }
        .padding(.vertical, 4)
    }
}
