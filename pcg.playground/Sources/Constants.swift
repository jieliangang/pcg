import Foundation
import SpriteKit

public class Constants {
    public static let playerOriginX = -325
    public static let velocity = 12
    
    static let playerSize = 35
    static let playerBound = 25
    
    static let yVelocity = 600
    static let upwardVelocity = CGVector(dx: 0, dy: yVelocity)
    static let downwardVelocity = CGVector(dx: 0, dy: -yVelocity)

    public static let glideVelocity = 12
    public static let arrowVelocity = 13
    public static let flappyVelocity = 10
    
    public static let gameWidth = 900
    public static let gameHeight = 563
    public static let stageWidth = 1100
    
    public static let arrow = SKTexture(imageNamed: "arrow3.png")
    public static let arrowUp = SKTexture(imageNamed: "arrow1.png")
    public static let arrowDown = SKTexture(imageNamed: "arrow2.png")
    
    static let obstacle1 = SKTexture(imageNamed: "Obstacle1")
    static let obstacle2 = SKTexture(imageNamed: "Obstacle2")
    static let obstacle3 = SKTexture(imageNamed: "Obstacle3")
    static let obstacle4 = SKTexture(imageNamed: "Obstacle4")
    static let obstacle5 = SKTexture(imageNamed: "Obstacle5")
    static let obstacles = [obstacle1, obstacle2, obstacle3, obstacle4, obstacle5]
    static let movingObstacle = SKTexture(imageNamed: "MovingObstacle")

    static func getObstacleTexture() -> SKTexture {
        let index = Int(arc4random_uniform(UInt32(obstacles.count)))
        return obstacles[index]
    }
    
    static let greenGem = SKTexture(imageNamed: "GreenGemSmall")
    static let coinSize = 30
    
    
    public static let gravity = CGVector(dx: 0, dy: -10.5)
    public static let arrowGravity = CGVector(dx: 0, dy: 0)
    public static let flappyGravity = CGVector(dx: 0, dy: -20)
    public static let glideGravity = CGVector(dx: 0, dy: -10.5)
    
    public static let fps: Double = 1/60
    
    // Background Images
    static let yellowGradientBG = SKTexture(imageNamed: "YellowGradient")
    static let redGradientBG = SKTexture(imageNamed: "RedGradient")
    static let greenGradientBG = SKTexture(imageNamed: "GreenGradient")
    static let blueGradientBG = SKTexture(imageNamed: "BlueGradient")

    static let topUpperCave = SKTexture(imageNamed: "TopUpperCave")
    static let topLowerCave = SKTexture(imageNamed: "TopLowerCave")
    static let bottomUpperCave = SKTexture(imageNamed: "BottomUpperCave")
    static let bottomLowerCave = SKTexture(imageNamed: "BottomLowerCave")
    static let caveWithLight = SKTexture(imageNamed: "CaveWithLight")
    
    // Path Generation
    static let pathTopCap = gameHeight/2 - 40
    static let pathBotCap = -pathTopCap
    static let pathTopSmoothCap = pathTopCap - 60
    static let pathBotSmoothCap = pathBotCap + 60
    static let pathInterval = 50
    static let pathMaxInterval = 200
    
    static let bottomBound = -gameHeight/2
    static let topBound = gameHeight/2
    
}
