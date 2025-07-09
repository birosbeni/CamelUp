import SwiftUI

struct NewGameSetupView: View {
    @State private var camels = CamelColor.allCases.map {
        CamelState(color: $0, position: 1, stackIndex: 0)
    }

    var body: some View {
        VStack {
            ForEach(0..<camels.count, id: \.self) { i in
                HStack {
                    Text(camels[i].color.rawValue.capitalized)
                    Stepper("Mező: \(camels[i].position)", value: $camels[i].position, in: 1...3)
                    Stepper("Stack: \(camels[i].stackIndex)", value: $camels[i].stackIndex, in: 0...4)
                }
            }

            NavigationLink("Tovább", destination: GameView(gameState: GameState(camels: camels, remainingDice: CamelColor.allCases)))
        }
        .padding()
    }
}
