struct GameState: Codable {
    var camels: [CamelState]
    var remainingDice: [CamelColor]
    // TODO: lehet majd oázis, homokvihar, stb.
}
