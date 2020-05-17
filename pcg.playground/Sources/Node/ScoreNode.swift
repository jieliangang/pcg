import SpriteKit

class ScoreNode: SKLabelNode {

    override init() {
        super.init()
        self.text = "0m"
        self.fontSize = 24
        self.fontColor = SKColor.white
        self.zPosition = 100
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(_ score: Int) {
        self.text = "\(score)m"
    }
}
