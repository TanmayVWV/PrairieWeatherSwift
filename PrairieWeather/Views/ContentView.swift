import SwiftUI

struct ContentView: View {
    @EnvironmentObject var vm: WeatherViewModel

    var body: some View {
        NavigationStack {
            Group {
                if vm.isLoading && vm.forecast == nil {
                    ProgressView("Loading…")
                        .accessibilityLabel("Loading weather")
                } else if let f = vm.forecast {
                    List {
                        Section("\(f.city) • 7-Day Forecast") {
                            ForEach(f.days) { day in
                                ForecastRow(day: day)
                            }
                        }
                        if let fetched = vm.forecast?.fetchedAt {
                            Text("Last updated: \(RelativeDateTimeFormatter().localizedString(for: fetched, relativeTo: Date()))")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                    .listStyle(.insetGrouped)
                    .refreshable { await vm.refresh() }
                } else {
                    VStack(spacing: 12) {
                        Text(vm.errorMessage ?? "No data")
                        Button("Retry") { Task { await vm.load() } }
                            .buttonStyle(.borderedProminent)
                    }
                    .padding()
                }
            }
            .navigationTitle("PrairieWeather")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { Task { await vm.refresh() } } label: { Image(systemName: "arrow.clockwise") }
                        .accessibilityLabel("Refresh")
                }
            }
        }
    }
}
