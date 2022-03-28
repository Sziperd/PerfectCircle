/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The content of the scroll view. Adds some margin and a shadow. Setting the documentView places this view, and sizes it to the canvasSize.
*/

import UIKit

//struct MyVariables {
//    var scoreString = 0.0
//}
public var scoreString = 0.0
var saveLastRadius = 0.0
var saveLastX = 0.0
var saveLastY = 0.0
var saveLastSpeed = 0.0
var saveLastAngle = 0.0
var saveLastDistance = 0.0

var radiusCorrect = 1.0
var accuracyTotal = 0.0

//var angleChange = 0.0
//var lastAngle = 0.0
var angleTotal = 0.0
var direction = 0
var directionStart = 0

var Contain = 0.0

public var isFinished = false

// var saveLastScore = 0.0
class CanvasContainerView: UIView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //var angleTotal = 0.0
        //var accuracyTotal = 0.0
        var directionStart = 0
        var highscore = 0.0
        var timeLimit = 0.0
        let touch = touches.first!
        let location = touch.location(in: documentView)
       // let canvasCenter = CGPoint(x: (frame.width) / 2.0, y: (frame.height) / 2.0)
        let canvasCenter = CGPoint(x: 468  , y: 392 )
        let xCenter = canvasCenter.x
        let yCenter = canvasCenter.y
       
        saveLastAngle = 180 + 180 * atan2(location.y - canvasCenter.y, location.x - canvasCenter.x) / .pi
        saveLastRadius = sqrt(pow(location.x - xCenter, 2) + pow(location.y - yCenter, 2))
        
        radiusCorrect = saveLastRadius
        
        saveLastX = location.x
        saveLastY = location.y
        
      //angleChange =  lastAngle - saveLastAngle
        //angleChange = abs(angleChange)
//        if (angleChange < -180) {
//                   angleChange += 360;
//               } else if (angleChange > 180) {
//                   angleChange -= 360;
//               }

        //direction = (angleChange < 0) ? -1 : 1
        directionStart = direction

        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
   
       // var angleTotal = 0.0
        //var accuracyTotal = 0.0
       // var directionStart = 0
        var highscore = 0.0
        var timeLimit = 0.0
        let touch = touches.first!
        let location = touch.location(in: documentView)
       // let canvasCenter = CGPoint(x: (frame.width) / 2.0, y: (frame.height) / 2.0)
        let canvasCenter = CGPoint(x: 468  , y: 392 )
       
        let xCenter = canvasCenter.x
        let yCenter = canvasCenter.y
        
       var lastAngle = 180 + 180 * atan2(location.y - canvasCenter.y, location.x - canvasCenter.x) / .pi
        
        var angleChange = lastAngle - saveLastAngle
        if (angleChange < -180) {
                   angleChange += 360
               } else if (angleChange > 180) {
                   angleChange -= 360
               }
        direction = (angleChange < 0) ? -1 : 1
        // tutaj dodaj wylaczanie gry kiedy zmieni sie direction
   
        let lastRadius = sqrt(pow(location.x - xCenter, 2) + pow(location.y - yCenter, 2))
        var accuracy = 1 - abs((lastRadius + saveLastRadius) / 2 - radiusCorrect) / radiusCorrect
        accuracy = max(accuracy,0)
        
      
        if (lastRadius < 10){
            print("Too close to the middle!")
            print("game should restart")
            isFinished = true
        }
    
        
            saveLastAngle = lastAngle
            saveLastRadius = lastRadius
            angleChange = abs(angleChange)
        
        angleTotal = Total(angleChange: angleChange, angleTotal: angleTotal)
        
       // angleTotal += angleChange
            if (angleTotal > 360) {
                    angleChange = angleChange - (angleTotal - 360)
                    angleTotal = 360
                }
           
        accuracyTotal = Accuracyy(angleChange: angleChange, accuracy: accuracy, accuracyTotal: accuracyTotal)
        
            //accuracyTotal += angleChange * accuracy
            print(angleTotal)
            scoreString = round(1000 * accuracyTotal / angleTotal)
        
       
      
        
        
    //  print(angleTotal)
        
        if (angleTotal == 360){
            print("360 degrees obtain, restart")
            isFinished = true
            
            
        }
    }
        
    func Accuracyy(angleChange: Double, accuracy: Double, accuracyTotal: Double) -> Double {
        var sum2 = (angleChange * accuracy) + accuracyTotal
        
        return sum2
    }
    
    func Total(angleChange: Double, angleTotal: Double) -> Double {
       
        var sum = angleTotal + angleChange
       // Contain(value: sum)
        return  sum
        
    }
    
    
    
    let canvasSize: CGSize
    
    let canvasView: UIView
    
    var documentView: UIView? {
        willSet {
            if let previousView = documentView {
                previousView.removeFromSuperview()
            }
        }
        didSet {
            if let newView = documentView {
                newView.frame = canvasView.bounds
                canvasView.addSubview(newView)
            }
        }
    }
    
    required init(canvasSize: CGSize) {
        let screenBounds = UIScreen.main.bounds
        let minDimension = max(screenBounds.width, screenBounds.height)
        self.canvasSize = canvasSize

        var size = canvasSize
        size.width = max(minDimension, size.width)
        size.height = max(minDimension, size.height)
        
        let frame = CGRect(origin: .zero, size: size)
        
        let canvasOrigin = CGPoint(x: (frame.width - canvasSize.width) / 2.0, y: (frame.height - canvasSize.height) / 2.0)
        let canvasFrame = CGRect(origin: canvasOrigin, size: canvasSize)
        canvasView = UIView(frame: canvasFrame)
        canvasView.backgroundColor = UIColor.white
        canvasView.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        canvasView.layer.shadowRadius = 4.0
        canvasView.layer.shadowColor = UIColor.darkGray.cgColor
        canvasView.layer.shadowOpacity = 1.0
        
        
        
     
        super.init(frame: frame)
        self.backgroundColor = UIColor.lightGray
        self.addSubview(canvasView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
