import SwiftUI

struct GameView: View {
    @State var gameState: GameState
    @State var monteCarloStats: CamelStatistics? = nil
    @State var exhaustiveStats: CamelStatistics? = nil

    var body: some View {
        VStack(spacing: 20) {
            Text("Jelenlegi állás")
                .font(.title2)

            ForEach(
                gameState.camels.sorted(by: {
                    if $0.position != $1.position {
                        return $0.position > $1.position
                    } else {
                        return $0.stackIndex > $1.stackIndex
                    }
                }),
                id: \.color
            ) { camel in
                Text("\(camel.color.rawValue.capitalized): mező \(camel.position), stack \(camel.stackIndex)")
            }

            Button("Számítsd ki a statisztikát") {
                monteCarloStats = SimulationEngine.simulate(gameState: gameState)
                exhaustiveStats = SimulationEngine.exhaustiveSectionStatistics(gameState: gameState)
            }

            if let monteCarloStats {
                StatisticsView(stats: monteCarloStats, label: "Monte Carlo")
            }

            if let exhaustiveStats {
                StatisticsView(stats: exhaustiveStats, label: "Brute-force")
            }
        }
        .padding()
    }
}
