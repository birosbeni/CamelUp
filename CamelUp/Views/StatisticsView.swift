import SwiftUI

struct StatisticsView: View {
    let stats: CamelStatistics
    let label: String

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                Text("Statisztikák – \(label)")
                    .font(.headline)
                    .padding(.bottom, 5)

                HStack {
                    Text("Teve").frame(width: 80, alignment: .leading)
                    Text("Győzelem").frame(width: 80, alignment: .leading)
                    Text("Második").frame(width: 80, alignment: .leading)
                    Text("Utolsó").frame(width: 80, alignment: .leading)
                }
                .font(.subheadline)
                .foregroundColor(.gray)

                Divider()

                ForEach(CamelColor.allCases, id: \.self) { color in
                    HStack {
                        Text(color.rawValue.capitalized).frame(width: 80, alignment: .leading)
                        Text(formatted(stats.winChances[color])).frame(width: 80, alignment: .leading)
                        Text(formatted(stats.secondPlaceChances[color])).frame(width: 80, alignment: .leading)
                        Text(formatted(stats.loseChances[color])).frame(width: 80, alignment: .leading)
                    }
                }
            }
            .padding()
        }
    }

    private func formatted(_ value: Double?) -> String {
        guard let value else { return "-" }
        return String(format: "%.1f%%", value * 100)
    }
}
