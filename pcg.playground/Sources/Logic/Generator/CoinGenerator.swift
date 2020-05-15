import Foundation

import Foundation

/**
 `CoinGenerator` handles generation of `Coin`
 */
class CoinGenerator {

    var generator: SeededGenerator

    init(_ seed: UInt64) {
        generator = SeededGenerator(seed: seed)
    }

    func generateCoin(xPos: Int, path: Path) -> Coin {
        let yPos = path.getPointAt(xVal: xPos)
        return Coin(yPos: yPos)
    }
}
