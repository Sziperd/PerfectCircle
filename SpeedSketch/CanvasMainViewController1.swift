/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The primary view controller.
*/

import UIKit

class CanvasMainViewController: UIViewController {

    
    
    @IBOutlet weak var TopHiScoText: UILabel!
    @IBOutlet weak var highScoreText: UITextField!
    @IBOutlet weak var ScoreText: UITextField!
    var cgView: StrokeCGView!
    @IBOutlet var leftRingControl: RingControl!
    @IBOutlet var leftRingControlHeight: NSLayoutConstraint!
    @IBOutlet var leftRingControlWidth: NSLayoutConstraint!
    @IBOutlet var leftRingControlLeading: NSLayoutConstraint!
    @IBOutlet var leftRingControlTop: NSLayoutConstraint!

    var fingerStrokeRecognizer: StrokeGestureRecognizer!
    var pencilStrokeRecognizer: StrokeGestureRecognizer!

    @IBOutlet var pencilButton: UIButton!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var separatorView: UIView!

    
    
    @IBOutlet weak var againButton: UIButton!
    var strokeCollection = StrokeCollection()
    var canvasContainerView: CanvasContainerView!
   

    /// Prepare the drawing canvas.
    /// - Tag: CanvasMainViewController-viewDidLoad
    override func viewDidLoad() {
//        let defaults = UserDefaults.standard
//        let Score = defaults.double(forKey: "Score")
//        print(Score)
//        ScoreText.text = "\(Score)"
        super.viewDidLoad()
        if (highscore == 0){
            highScoreText.isHidden = true
            TopHiScoText.isHidden = true
            
        }else{
            highScoreText.isHidden = false
            TopHiScoText.isHidden = false
        }
        
        againButton.layer.cornerRadius = 20
       
        highScoreText.borderStyle = .none
        highScoreText.backgroundColor = UIColor.clear
       ScoreText.borderStyle = .none
       
        ScoreText.backgroundColor = UIColor.clear
        let screenBounds = UIScreen.main.bounds
        let maxScreenDimension = max(screenBounds.width, screenBounds.height)

        let cgView = StrokeCGView(frame: CGRect(origin: .zero, size: CGSize(width: maxScreenDimension, height: maxScreenDimension)))
        cgView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.cgView = cgView
        
        let canvasContainerView = CanvasContainerView(canvasSize: cgView.frame.size)
        canvasContainerView.documentView = cgView
        self.canvasContainerView = canvasContainerView
        scrollView.contentSize = canvasContainerView.frame.size
        scrollView.contentOffset = CGPoint(x: (canvasContainerView.frame.width - scrollView.bounds.width) / 2.0,
                                           y: (canvasContainerView.frame.height - scrollView.bounds.height) / 2.0)
        scrollView.addSubview(canvasContainerView)
        scrollView.backgroundColor = canvasContainerView.backgroundColor
        scrollView.maximumZoomScale = 3.0
        scrollView.minimumZoomScale = 0.5
        scrollView.panGestureRecognizer.allowedTouchTypes = [UITouch.TouchType.direct.rawValue as NSNumber]
        scrollView.pinchGestureRecognizer?.allowedTouchTypes = [UITouch.TouchType.direct.rawValue as NSNumber]
        // We put our UI elements on top of the scroll view, so we don't want any of the
        // delay or cancel machinery in place.
        scrollView.delaysContentTouches = false

        self.fingerStrokeRecognizer = setupStrokeGestureRecognizer(isForPencil: false)
        self.pencilStrokeRecognizer = setupStrokeGestureRecognizer(isForPencil: true)

        if #available(iOS 12.1, *) {
            let pencilInteraction = UIPencilInteraction()
            pencilInteraction.delegate = self
            view.addInteraction(pencilInteraction)
        }

        setupDrawingTools()
        setupPencilUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
       
        scrollView.flashScrollIndicators()
        
        
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    /// A helper method that creates stroke gesture recognizers.
    /// - Tag: setupStrokeGestureRecognizer
    func setupStrokeGestureRecognizer(isForPencil: Bool) -> StrokeGestureRecognizer {
        let recognizer = StrokeGestureRecognizer(target: self, action: #selector(strokeUpdated(_:)))
        recognizer.delegate = self
        recognizer.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(recognizer)
        recognizer.coordinateSpaceView = cgView
        recognizer.isForPencil = isForPencil
        return recognizer
    }

    func setupDrawingTools() {
        let ringDiameter = CGFloat(74.0)
        let ringImageInset = CGFloat(14.0)
        let borderWidth = CGFloat(1.0)
        let ringOutset = ringDiameter / 2.0 - (floor(sqrt((ringDiameter * ringDiameter) / 8.0) - borderWidth))

        leftRingControlHeight.constant = ringDiameter
        leftRingControlWidth.constant = ringDiameter
        leftRingControlTop.constant = -ringDiameter + (ringOutset * 2)
        leftRingControlLeading.constant = -ringOutset

        leftRingControl.setupRings(itemCount: StrokeViewDisplayOptions.allCases.count)
        leftRingControl.setupInitialSelectionState()

        for (index, ringView) in leftRingControl.ringViews.enumerated() {
            let option = StrokeViewDisplayOptions.allCases[index]
            ringView.actionClosure = { self.cgView.displayOptions = option }
            let imageView = UIImageView(frame: ringView.bounds.insetBy(dx: ringImageInset, dy: ringImageInset))
            imageView.image = UIImage(named: option.description)
            imageView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
            ringView.addSubview(imageView)
        }
    }
    
    func receivedAllUpdatesForStroke(_ stroke: Stroke) {
        cgView.setNeedsDisplay(for: stroke)
        
      
        
        stroke.clearUpdateInfo()
    }
    
    func hideAgainButton(){
        againButton.isHidden = true
        isFinished = false
//        if fingerStrokeRecognizer.view == nil {
//            scrollView.addGestureRecognizer(fingerStrokeRecognizer)
//        }
        //self.pencilMode = false
    }
    
    func showAgainButton(){
        againButton.isHidden = false
        isFinished = true
//        if let view = fingerStrokeRecognizer.view {
//            view.removeGestureRecognizer(fingerStrokeRecognizer)
//        }
       // self.pencilMode = true
    }
    
    @IBAction func againButtonTapped(_ sender: UIButton) {
        //isFinished = false
        clearCircle()
        hideAgainButton()
        
   
      //  touch.view.isUserInteractionEnabled = false
        
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
   
    }
    

    func clearCircle(){
        self.strokeCollection = StrokeCollection()
        cgView.strokeCollection = self.strokeCollection
        
        
        
    }
    
    @IBAction func clearButtonAction(_ sender: AnyObject) {
        self.strokeCollection = StrokeCollection()
        cgView.strokeCollection = self.strokeCollection
        
        
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
           
      //  self.isUserInteractionEnabled = true
       
    }
 
    /// Handles the gesture for `StrokeGestureRecognizer`.
    /// - Tag: strokeUpdate
    ///
    ///
    ///

    
  
        
    public func returnMultipleValues() -> (lastAngle: Double, lastRadius: Double, angleChange: Double, angleTotal: Double, saveLastAngle: Double, saveLastRadius: Double, accuracyTotal: Double, directionStart: Int, radiusCorrect: Double, accuracy: Double) {
       
        
        return (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0.0, 0.0)
    }
    @objc
    func strokeUpdated(_ strokeGesture: StrokeGestureRecognizer) {
        if (isFinished == true){
            //clearCircle()
           // self.isUserInteractionEnabled = false
       
            
//            if let view = fingerStrokeRecognizer.view {
//                view.removeGestureRecognizer(fingerStrokeRecognizer)
//            }
            //fingerStrokeRecognizer.isEnabled = false
            
            strokeGesture.state = .ended
            //fingerStrokeRecognizer.isEnabled = false
            
            showAgainButton()
            //isFinished = false
        }
       
        self.scrollView.isScrollEnabled = false
        scrollView.pinchGestureRecognizer?.isEnabled = false
        scrollView.panGestureRecognizer.isEnabled = false
        
        let z = Double(round(10000 * highscore) / 100)
        let y = Double(round(100 * scoreString) / 1000)
      //  ScoreText.backgroundColor = UIColor.white
       if (highscore == 0){
           highScoreText.isHidden = true
           TopHiScoText.isHidden = true
           
       }else{
           highScoreText.isHidden = false
           TopHiScoText.isHidden = false
       }
        
        ScoreText.text = "\(y)%"
        highScoreText.text = "\(z)%"
       // ScoreText.text = "\(MyVariables.scoreString)"
      //  print(scoreString)
        if strokeGesture === pencilStrokeRecognizer {
            lastSeenPencilInteraction = Date()
        }
        
        var stroke: Stroke?
        if strokeGesture.state != .cancelled {
            stroke = strokeGesture.stroke
            if strokeGesture.state == .began ||
               (strokeGesture.state == .ended && strokeCollection.activeStroke == nil) {
                strokeCollection.activeStroke = stroke
                leftRingControl.cancelInteraction()
            }
        } else {
            strokeCollection.activeStroke = nil
        }
        
        if let stroke = stroke {
            if strokeGesture.state == .ended {
                if strokeGesture === pencilStrokeRecognizer {
                    // Make sure we get the final stroke update if needed.
                    stroke.receivedAllNeededUpdatesBlock = { [weak self] in
                        self?.receivedAllUpdatesForStroke(stroke)
                    }
                }
               strokeCollection.takeActiveStroke()
            }
        }

        cgView.strokeCollection = strokeCollection
    }

    // MARK: Pencil Recognition and UI Adjustments
    /*
         Since usage of the Apple Pencil can be very temporary, the best way to
         actually check for it being in use is to remember the last interaction.
         Also make sure to provide an escape hatch if you modify your UI for
         times when the pencil is in use vs. not.
     */

    // Timeout the pencil mode if no pencil has been seen for 5 minutes and the app is brought back in foreground.
    let pencilResetInterval = TimeInterval(60.0 * 5)

    var lastSeenPencilInteraction: Date? {
        didSet {
            if lastSeenPencilInteraction != nil && !pencilMode {
                pencilMode = true
            }
        }
    }

    func shouldTimeoutPencilMode() -> Bool {
        guard let lastSeenPencilInteraction = self.lastSeenPencilInteraction else { return true }
        return abs(lastSeenPencilInteraction.timeIntervalSinceNow) > self.pencilResetInterval
    }
    
    private func setupPencilUI() {
        self.pencilMode = false

        self.willEnterForegroundNotification = NotificationCenter.default.addObserver(
            forName: UIApplication.willEnterForegroundNotification,
            object: UIApplication.shared,
            queue: nil) { [unowned self](_) in
                if self.pencilMode && self.shouldTimeoutPencilMode() {
                    self.stopPencilButtonAction(nil)
                }
        }
    }

    var willEnterForegroundNotification: NSObjectProtocol?

    /// Toggles pencil mode for the app.
    /// - Tag: pencilMode
    var pencilMode = false {
        didSet {
            if pencilMode {
                scrollView.panGestureRecognizer.minimumNumberOfTouches = 5
                pencilButton.isHidden = false
                if let view = fingerStrokeRecognizer.view {
                    view.removeGestureRecognizer(fingerStrokeRecognizer)
                }
            } else {
                scrollView.panGestureRecognizer.minimumNumberOfTouches = 5
                pencilButton.isHidden = true
                if fingerStrokeRecognizer.view == nil {
                    scrollView.addGestureRecognizer(fingerStrokeRecognizer)
                }
            }
        }
    }
    
    @IBAction func stopPencilButtonAction(_ sender: AnyObject?) {
        lastSeenPencilInteraction = nil
        pencilMode = false
    }

}

// MARK: - UIGestureRecognizerDelegate

extension CanvasMainViewController: UIGestureRecognizerDelegate {

    // Since our gesture recognizer is beginning immediately, we do the hit test ambiguation here
    // instead of adding failure requirements to the gesture for minimizing the delay
    // to the first action sent and therefore the first lines drawn.
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {

        return leftRingControl.hitTest(touch.location(in: leftRingControl), with: nil) == nil
        
    }

    
    

    
    // We want the pencil to recognize simultaniously with all others.
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer === pencilStrokeRecognizer {
            return otherGestureRecognizer !== fingerStrokeRecognizer
        }

        return false
    }

}

// MARK: - UIScrollViewDelegate

extension CanvasMainViewController: UIScrollViewDelegate {

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.canvasContainerView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        var desiredScale = self.traitCollection.displayScale
        let existingScale = cgView.contentScaleFactor
        
        if scale >= 2.0 {
            desiredScale *= 2.0
        }
        
        if abs(desiredScale - existingScale) > 0.000_01 {
            cgView.contentScaleFactor = desiredScale
            cgView.setNeedsDisplay()
        }
    }
}

// MARK: - UIPencilInteractionDelegate

@available(iOS 12.1, *)
extension CanvasMainViewController: UIPencilInteractionDelegate {

    /// Handles double taps that the user makes on an Apple Pencil.
    /// - Tag: pencilInteractionDidTap
    func pencilInteractionDidTap(_ interaction: UIPencilInteraction) {
        if UIPencilInteraction.preferredTapAction == .switchPrevious {
            leftRingControl.switchToPreviousTool()
        }
    }

}
