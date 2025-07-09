struct CamelStatistics {
    let winChances: [CamelColor: Double]
    let secondPlaceChances: [CamelColor: Double]
    let loseChances: [CamelColor: Double]
}

class SimulationEngine {
    static func simulate(gameState: GameState, iterations: Int = 10000) -> CamelStatistics {
        var winCounts = [CamelColor: Int]()
        var secondCounts = [CamelColor: Int]()
        var lastCounts = [CamelColor: Int]()

        for _ in 0..<iterations {
            let simulated = simulateOneRace(from: gameState)
            if let first = simulated.first {
                winCounts[first.color, default: 0] += 1
            }
            if simulated.count > 1 {
                secondCounts[simulated[1].color, default: 0] += 1
            }
            if let last = simulated.last {
                lastCounts[last.color, default: 0] += 1
            }
        }

        func ratio(_ counts: [CamelColor: Int]) -> [CamelColor: Double] {
            counts.mapValues { Double($0) / Double(iterations) }
        }

        return CamelStatistics(
            winChances: ratio(winCounts),
            secondPlaceChances: ratio(secondCounts),
            loseChances: ratio(lastCounts)
        )
    }

    private static func simulateOneRace(from state: GameState) -> [CamelState] {
        var camels = state.camels
        let dice = state.remainingDice.shuffled()

        for color in dice {
            let steps = Int.random(in: 1...3)
            moveCamel(&camels, color: color, steps: steps)
        }

        return camels.sorted {
            if $0.position == $1.position {
                return $0.stackIndex < $1.stackIndex
            }
            return $0.position > $1.position
        }
    }

    private static func moveCamel(_ camels: inout [CamelState], color: CamelColor, steps: Int) {
        guard let moverIndex = camels.firstIndex(where: { $0.color == color }) else { return }
        let mover = camels[moverIndex]

        // Ki van a mozgó teve fölött?
        let _riding = camels.filter {
            $0.position == mover.position && $0.stackIndex > mover.stackIndex
        }.sorted { $0.stackIndex < $1.stackIndex }

        // Alatta lévőket viszi magával
        for i in 0..<camels.count {
            if camels[i].position == mover.position && camels[i].stackIndex >= mover.stackIndex {
                camels[i].position += steps
            }
        }

        // Új stacket kell kiszámolni
        let samePos = camels.filter { $0.position == mover.position + steps }
        for i in 0..<camels.count {
            if camels[i].position == mover.position + steps {
                camels[i].stackIndex = samePos.count
            }
        }
    }
}
