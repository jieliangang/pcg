import SpriteKit

public class StartScene: SKScene {
    var titleLabel: SKLabelNode!
    var playLabel: SKLabelNode!
    var wwdcLabel: SKLabelNode!

    public override func didMove(to view: SKView) {
        initBackground()
        initTitleLabel()
        initPlayLabel()
        initWWDCLabel()
        initTapLabel()
    }

    private func initBackground() {
        let backgroundNode = BackgroundNode(self.frame)
        self.addChild(backgroundNode)
    }

    private func initTitleLabel() {
        titleLabel = SKLabelNode(fontNamed: "HelveticaNeue-Light")
        titleLabel.text = "D A S H"
        titleLabel.fontSize = 60
        titleLabel.position = CGPoint(x: self.frame.midX - titleLabel.frame.width/2, y: self.frame.midY)
        self.addChild(titleLabel)
    }

    private func initPlayLabel() {
        playLabel = SKLabelNode(fontNamed: "HelveticaNeue-Light")
        playLabel.text = "a Procedurally Generated game developed by Jie Liang"
        playLabel.fontSize = 16
        playLabel.position = CGPoint(x: self.frame.midX - titleLabel.frame.width/2, y: titleLabel.position.y - 40)
        self.addChild(playLabel)
    }
    
    private func initWWDCLabel() {
        wwdcLabel = SKLabelNode(fontNamed: "HelveticaNeue-Light")
        wwdcLabel.text = "WWDC 2020"
        wwdcLabel.fontSize = 20
        wwdcLabel.position = CGPoint(x: self.frame.midX - titleLabel.frame.width/2, y: playLabel.position.y - 40)
        self.addChild(wwdcLabel)
    }
    
    private func initTapLabel() {
        let tapLabel = SKLabelNode(fontNamed: "HelveticaNeue-Light")
        tapLabel.text = "Tap to Play"
        tapLabel.fontSize = 14
        tapLabel.position = CGPoint(x: self.frame.midX - titleLabel.frame.width/2, y: wwdcLabel.position.y - 40)
        self.addChild(tapLabel)
    }

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let menuScene = MenuScene(fileNamed: "MenuScene") {
            self.view?.presentScene(menuScene)
        }
    }
}
