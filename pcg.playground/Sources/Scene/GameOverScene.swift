import Foundation
import SpriteKit

public class GameOverScene: SKScene {
    var playerType: PlayerType = .arrow
    var score = 0
    
    var scoreLabel: SKLabelNode!
    
    public override func didMove(to view: SKView) {
        initCurrentScoreLabel()
        initReplayLabel()
        initReturnToMenuLabel()
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else {
            return
        }

        let nodes = self.nodes(at: location)

        switch nodes.first?.name {
        case "replay":
            presentGameScene(with: playerType)
        case "menu":
            presentMainMenuScene()
        default:
            return
        }
    }
        
    private func initCurrentScoreLabel() {
        scoreLabel = SKLabelNode(fontNamed: "HelveticaNeue-Light")
        scoreLabel.text = "\(score) m"
        scoreLabel.fontSize = 40
        scoreLabel.position = CGPoint(x: -scoreLabel.frame.width/2, y: self.frame.midY + 40)
        self.addChild(scoreLabel)
    }

    private func initReplayLabel() {
        let replayLabel = SKLabelNode(fontNamed: "HelveticaNeue-Light")
        replayLabel.name = "replay"
        replayLabel.text = "Play Again"
        replayLabel.fontSize = 20
        replayLabel.position = CGPoint(x: -scoreLabel.frame.width/2, y: self.frame.midY)
        self.addChild(replayLabel)
    }
    
    private func initReturnToMenuLabel() {
        let returnLabel = SKLabelNode(fontNamed: "HelveticaNeue-Light")
        returnLabel.name = "menu"
        returnLabel.text = "Return to Menu"
        returnLabel.fontSize = 20
        returnLabel.position = CGPoint(x: -scoreLabel.frame.width/2, y: self.frame.midY - 40)
        self.addChild(returnLabel)
    }
    
    private func presentGameScene(with characterType: PlayerType) {
        if let gameScene = GameScene(fileNamed: "GameScene") {
            gameScene.playerType = characterType
//            gameScene.seed = Int.random(in: 0...999999999)
            self.view?.presentScene(gameScene)
        }
    }
    
    private func presentMainMenuScene() {
        if let menuScene = MenuScene(fileNamed: "MenuScene") {
            self.view?.presentScene(menuScene)
        }
    }

}
