import Foundation
import SpriteKit

public class Constants {
    public static let playerOriginX = -325
    public static let velocity = 12
    
    static let yVelocity = 600
    static let upwardVelocity = CGVector(dx: 0, dy: yVelocity)
    static let downwardVelocity = CGVector(dx: 0, dy: -yVelocity)
    
    public static let gameWidth = 1112
    public static let gameHeight = 834
    public static let stageWidth = 1560
    
    public static let arrow = SKTexture(imageNamed: "arrow3.png")
    public static let arrowUp = SKTexture(imageNamed: "arrow1.png")
    public static let arrowDown = SKTexture(imageNamed: "arrow2.png")
    
    public static let gravity = CGVector(dx: 0, dy: -10.5)
    public static let arrowGravity = CGVector(dx: 0, dy: 0)
    public static let flappyGravity = CGVector(dx: 0, dy: -20)
    public static let glideGravity = CGVector(dx: 0, dy: -10.5)
    
    public static let fps: Double = 1/60
    
}
