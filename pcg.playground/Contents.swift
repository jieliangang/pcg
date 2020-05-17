//: A SpriteKit based Playground
//: Created by Jie Liang Ang on 6/5/20.

/*:
    Dash is a progressive endless runner game in which the goal of the player is to travel as far as possible while staying within the upper and lower walls. The player-character moves to the right through procedurally generated landscapes. There are three types of characters designed for this prototype: arrow, flappy and glide. Different obstacles and gems can be encountered and collected respectively throughout the game as the games gets harder as player progresses. Have fun!
 */

/*:
      Instructions for the three different modes:
        #1: Arrow: Tap to change direction (up or down)
        #2: Glide: Tap and hold to accelerate upwards.
        #3: Flappy: Tap to fly upwards. (Small force towards opposite direction of gravity) Similar to Flappy Bird.
 
       Note: Your character starts to move once you tap or hold.
 */

import PlaygroundSupport
import SpriteKit

// Load the SKScene from 'StartScene.sks'
let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 900, height: 563))
if let scene = StartScene(fileNamed: "StartScene") {
    // Set the scale mode to scale to fit the window
    
    // Present the scene
    sceneView.presentScene(scene)
}

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
