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
public var saveLastRadius = 0.0
public var saveLastX = 0.0
public var saveLastY = 0.0
public var saveLastSpeed = 0.0
public var saveLastAngle = 0.0
//var saveLastDistance = 0.0

public var radiusCorrect = 1.0
public var accuracyTotal = 0.0
public var angleTotal = 0.0
public var direction = 0
public var directionStart = 0

var Contain = 0.0

var endingT = Date()


public var lastAngle = 0.0
public var lastRadius = 0.0
public var angleChange = 0.0

public var isFinished = false


public var highscore = 0.0

// var saveLastScore = 0.0
class CanvasContainerView: UIView {
 
 
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        

        
                let result = returnMultipleValues()
                    lastAngle = result.lastAngle
                    lastRadius = result.lastRadius
                    angleChange = result.angleChange
                    angleTotal = result.angleTotal
                    saveLastAngle = result.saveLastAngle
                    saveLastRadius = result.saveLastRadius
                    accuracyTotal = result.accuracyTotal
                    directionStart = result.directionStart
                    radiusCorrect = result.radiusCorrect
                    //direction = result.direction
       directionStart = 0
       // var highscore = 0.0
       // var timeLimit = 0.0
     
    
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "PKT")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

          
            
           // let currentT = Date() //UTC
           endingT = Date().addingTimeInterval(5) //UTC

            
      
        let touch = touches.first!
        let location = touch.location(in: documentView)
       // let canvasCenter = CGPoint(x: frame.midX , y: frame.midY)
       let canvasCenter = CGPoint(x: 468  , y: 485 )
        let xCenter = canvasCenter.x
        let yCenter = canvasCenter.y
       
        saveLastAngle = 180 + 180 * atan2(location.y - canvasCenter.y, location.x - canvasCenter.x) / .pi
        saveLastRadius = sqrt(pow(location.x - xCenter, 2) + pow(location.y - yCenter, 2))
        
        radiusCorrect = saveLastRadius
        
        if (radiusCorrect < 50){
            print("starting point too close to middle")
            isFinished = true
            
        }
        
        
        saveLastX = location.x
        saveLastY = location.y
        

        //direction = (angleChange < 0) ? -1 : 1
       // directionStart = 0


        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
       
       
        //var highscore = 0.0
        
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "PKT")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let currentT = Date() //UTC
        let touch = touches.first!
        let location = touch.location(in: documentView)
        //let canvasCenter = CGPoint(x: self.view.center.x , y: self.view.center.y)
       let canvasCenter = CGPoint(x: 468  , y: 485 )
       
        let xCenter = canvasCenter.x
        let yCenter = canvasCenter.y
        
        
        if (currentT  >= endingT){
            print("TIME'S UP. Youve been drawing for too long")
            isFinished = true
            
    
        }
        
        
        lastAngle = 180 + 180 * atan2(location.y - canvasCenter.y, location.x - canvasCenter.x) / .pi
        
         angleChange = lastAngle - saveLastAngle
        if (angleChange < -180) {
                   angleChange += 360
               } else if (angleChange > 180) {
                   angleChange -= 360
               }
        
        
        
//         direction = (angleChange < 0) ? -1 : 1
//
//        print(direction)
//        print(directionStart)
//        if (directionStart == 0) {
//            directionStart = direction
//                   if (abs(angleChange) < 0.1) {
//                     //isFinished = true
//                   }
//
//               }
//        print(directionStart)
//        // tutaj dodaj wylaczanie gry kiedy zmieni sie direction
//
//        if (direction != directionStart){
//            print("Dont change directions!")
//            isFinished = true
//
//        }
        
        
         lastRadius = sqrt(pow(location.x - xCenter, 2) + pow(location.y - yCenter, 2))
        var accuracy = 1 - abs((lastRadius + saveLastRadius) / 2 - radiusCorrect) / radiusCorrect
        accuracy = max(accuracy,0)
        
      
        if (lastRadius < 30){
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
           // print(angleTotal)
           
            scoreString = round(1000 * accuracyTotal / angleTotal)
        
                  
        
        if (angleTotal == 360){
            print("360 degrees obtained, restart")
            isFinished = true
            if (round(1000 * accuracyTotal / angleTotal) > round(1000 * highscore)) {
                if (highscore == 0) {
                                  
                                  highscore = accuracyTotal / angleTotal;
                                 
                              }
                              highscore = accuracyTotal / angleTotal;
                
            }
        }

    }
    
    
    
    
    public func returnMultipleValues() -> (lastAngle: Double, lastRadius: Double, angleChange: Double, angleTotal: Double, saveLastAngle: Double, saveLastRadius: Double, accuracyTotal: Double, directionStart: Int, radiusCorrect: Double, accuracy: Double) {
       
        
        return (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0.0, 0.0)
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
