import Foundation

public class GameEngine {
    private var gameModel: GameModel
    
    private var inGameTime = 0
    private var currentStageTime = 0
    
    private var timer: Timer?
    
    init(_ model: GameModel, seed: UInt64) {
        gameModel = model
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: Constants.fps, target: self,
                                     selector: #selector(updateGame), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        timer?.invalidate()
    }

    @objc private func updateGame() {
    }
    
}


