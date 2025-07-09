import Foundation

struct ProbabilityCalculator {
    static func calculateProbabilities(from gameState: GameState) -> CamelStatistics {
        return SimulationEngine.simulate(gameState: gameState)
    }
}
