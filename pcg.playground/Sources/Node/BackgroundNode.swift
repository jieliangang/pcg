import Foundation
import SpriteKit

class BackgroundNode: SKNode {
    
    let emitter = SKEmitterNode(fileNamed: "Passing")
    var gradientBackground = SKSpriteNode(texture: Constants.yellowGradientBG)

    init(_ frame: CGRect, type: PlayerType) {
        super.init()
        zPosition = -1
        setGradientBackground(frame: frame, type: type)
        setParallaxObjects(frame: frame)

        guard let backgroundEmitter = emitter else {
            return
        }
        backgroundEmitter.zPosition = -2
        backgroundEmitter.position = CGPoint(x: Constants.gameWidth/2, y: 0)
        self.addChild(backgroundEmitter)
    }

    init(_ frame: CGRect) {
        super.init()
        zPosition = -1
        setGradientBackground(frame: frame)
        setParallaxObjects(frame: frame)

        guard let backgroundEmitter = emitter else {
            return
        }
        backgroundEmitter.zPosition = -2
        backgroundEmitter.position = CGPoint(x: Constants.gameWidth/2, y: 0)
        self.addChild(backgroundEmitter)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setGradientBackground(frame: CGRect, type: PlayerType) {
        let backgroundTexture: SKTexture
        switch type {
        case .arrow: backgroundTexture = Constants.blueGradientBG
        case .glide: backgroundTexture = Constants.redGradientBG
        case .flappy:backgroundTexture = Constants.greenGradientBG
        }
        gradientBackground = SKSpriteNode(texture: backgroundTexture)
        gradientBackground.size.height = frame.height
        gradientBackground.size.width = frame.width
        gradientBackground.position = CGPoint(x: frame.midX, y: frame.midY)
        gradientBackground.zPosition = -5
        addChild(gradientBackground)
    }

    private func setGradientBackground(frame: CGRect) {
        gradientBackground.texture = Constants.yellowGradientBG
    }

    func updateBackground(type: PlayerType) {
        switch type {
        case .arrow: gradientBackground.texture = Constants.blueGradientBG
        case .glide: gradientBackground.texture = Constants.redGradientBG
        case .flappy: gradientBackground.texture = Constants.greenGradientBG
        }
    }

    private func setParallaxObjects(frame: CGRect) {
        setupMovingNode(frame, texture: Constants.caveWithLight, zPos: -1, duration: 20)
    }

    private func setupMovingNode(_ frame: CGRect, texture: SKTexture, zPos: CGFloat, duration: Double) {
        let shiftBackground = SKAction.moveBy(x: -texture.size().width, y: 0, duration: duration)
        let replaceBackground = SKAction.moveBy(x: texture.size().width, y: 0, duration: 0)
        let movingAndReplacingBackground =
            SKAction.repeatForever(SKAction.sequence([shiftBackground, replaceBackground]))

        for index in 0..<2 {
            let background = SKSpriteNode(texture: texture)
            background.size.height = frame.height
            background.position = CGPoint(x: (texture.size().width * CGFloat(index)) - 1, y: frame.midY)
            background.run(movingAndReplacingBackground)
            background.zPosition = zPos
            addChild(background)
        }
    }
}
