import SpriteKit

class CoinScoreNode: SKSpriteNode {
    var label: SKLabelNode!

    convenience init() {
        self.init(texture: Constants.greenGem)
        self.size = CGSize(width: 20, height: 20)
        self.zPosition = 100
        initLabel()
    }

    private func initLabel() {
        label = SKLabelNode()
        label.fontSize = 24
        label.position = CGPoint(x: 25, y: -10)
        self.addChild(label)
    }

    func update(_ coinCount: Int) {
        label.text = "\(coinCount)"
    }
}
