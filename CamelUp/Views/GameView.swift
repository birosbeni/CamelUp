import SwiftUI

struct GameView: View {
    @State var gameState: GameState
    @State var stats: CamelStatistics? = nil

    var body: some View {
        VStack(spacing: 20) {
            Text("Jelenlegi állás")
            ForEach(
                gameState.camels.sorted(by: {
                    if $0.position != $1.position {
                        return $0.position > $1.position // nagyobb mező elöl
                    } else {
                        return $0.stackIndex > $1.stackIndex // ugyanazon mezőn: aki feljebb van, az elöl
                    }
                }),
                id: \.color
            ) { camel in
                Text("\(camel.color.rawValue.capitalized): mező \(camel.position), stack \(camel.stackIndex)")
            }

            Button("Számítsd ki a statisztikát") {
                stats = SimulationEngine.simulate(gameState: gameState)
            }

            if let stats {
                StatisticsView(stats: stats)
            }
        }
        .padding()
    }
}
