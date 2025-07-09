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

        // Kikkel együtt mozog? (ő + a fölötte lévők)
        var movingStack = camels
            .filter { $0.position == mover.position && $0.stackIndex >= mover.stackIndex }
            .sorted(by: { $0.stackIndex < $1.stackIndex }) // alulról felfelé

        // Mozgatandó tevek eltávolítása (az új pozíció előtt)
        for camel in movingStack {
            if let index = camels.firstIndex(where: { $0.color == camel.color }) {
                camels.remove(at: index)
            }
        }

        // Új pozíció
        let newPosition = mover.position + steps

        // Az új pozíción már ott levő tevek (stackIndex alapján alulra kerülnek az újak)
        let existingAtDestination = camels
            .filter { $0.position == newPosition }
            .sorted(by: { $0.stackIndex < $1.stackIndex })

        let baseStackIndex = existingAtDestination.count

        // Mozgatott tevek újra hozzáadása friss pozícióval és stackIndex-szel
        for (i, var camel) in movingStack.enumerated() {
            camel.position = newPosition
            camel.stackIndex = baseStackIndex + i
            camels.append(camel)
        }
    }

    // Összes lehetőség ellenőrzése
    static func exhaustiveSectionStatistics(gameState: GameState) -> CamelStatistics {
            var winCounts = [CamelColor: Int]()
            var secondCounts = [CamelColor: Int]()
            var lastCounts = [CamelColor: Int]()
            var totalCount = 0

            // Összes dobási sorrend permutáció
            let diceOrders = permutations(of: gameState.remainingDice)

            for order in diceOrders {
                // Minden sorrendre végigpróbáljuk az összes dobás-kombinációt
                allStepCombinations(of: order.count) { steps in
                    var camels = gameState.camels.map { $0 } // másolat

                    for (i, color) in order.enumerated() {
                        let step = steps[i]
                        moveCamel(&camels, color: color, steps: step)
                    }

                    let sorted = camels.sorted {
                        if $0.position == $1.position {
                            return $0.stackIndex < $1.stackIndex
                        }
                        return $0.position > $1.position
                    }

                    if let first = sorted.first {
                        winCounts[first.color, default: 0] += 1
                    }
                    if sorted.count > 1 {
                        secondCounts[sorted[1].color, default: 0] += 1
                    }
                    if let last = sorted.last {
                        lastCounts[last.color, default: 0] += 1
                    }

                    totalCount += 1
                }
            }

            func ratio(_ counts: [CamelColor: Int]) -> [CamelColor: Double] {
                counts.mapValues { Double($0) / Double(totalCount) }
            }

            return CamelStatistics(
                winChances: ratio(winCounts),
                secondPlaceChances: ratio(secondCounts),
                loseChances: ratio(lastCounts)
            )
        }

        // Segédfüggvény: összes permutáció a hátralevő dobásokra
        private static func permutations<T>(of array: [T]) -> [[T]] {
            guard array.count > 1 else { return [array] }
            var result: [[T]] = []
            for (i, item) in array.enumerated() {
                var rest = array
                rest.remove(at: i)
                for perm in permutations(of: rest) {
                    result.append([item] + perm)
                }
            }
            return result
        }

        // Segédfüggvény: összes dobás-értékkombináció
        private static func allStepCombinations(of count: Int, handle: ([Int]) -> Void) {
            func recurse(current: [Int]) {
                if current.count == count {
                    handle(current)
                    return
                }
                for step in 1...3 {
                    recurse(current: current + [step])
                }
            }
            recurse(current: [])
        }
}
