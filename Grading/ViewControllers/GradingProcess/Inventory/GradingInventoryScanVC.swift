//
//  GradingInventoryScanVC.swift
//  Grading
//


import UIKit
import AVFoundation
import CoreGraphics

protocol GradingQRScanDelegate {
    func returnScanValue(val: String)
}

class GradingInventoryScanVC: UIViewController {
    
    var squareView: SquareView? = nil
    private let bottomSpace: CGFloat = 60.0
    private let spaceFactor: CGFloat = 16.0
    
    lazy var captureSession = AVCaptureSession()
    lazy var videoPreviewLayer: AVCaptureVideoPreviewLayer = {
        let layer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        layer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        layer.cornerRadius = 10.0
        return layer
    }()
    
    var delegate: GradingQRScanDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        videoPreviewLayer.frame = CGRect(x:view.bounds.origin.x, y: view.bounds.origin.y, width: view.bounds.size.width, height: view.bounds.size.height - bottomSpace)
        view.layer.insertSublayer(videoPreviewLayer, at: 0)
        
        let width: CGFloat = 200.0
        let height: CGFloat = 200.0
        
        let rect = CGRect.init(origin: CGPoint.init(x: self.view.frame.midX - width/2, y: self.view.frame.midY - (width+bottomSpace)/2), size: CGSize.init(width: width, height: height))
        self.squareView = SquareView(frame: rect)
        if let squareView = squareView {
            self.view.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
            squareView.autoresizingMask = UIView.AutoresizingMask(rawValue: UInt(0.0))
            self.view.addSubview(squareView)
            
            let maskLayer = CAShapeLayer()
            maskLayer.frame = view.bounds
            maskLayer.fillColor = UIColor(white: 0.0, alpha: 0.5).cgColor
            let path = UIBezierPath(rect: rect)
            path.append(UIBezierPath(rect: view.bounds))
            maskLayer.path = path.cgPath
            maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
            
            view.layer.insertSublayer(maskLayer, above: videoPreviewLayer)
        }
        
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        do {
            videoInput = try AVCaptureDeviceInput(device: captureDevice)
        } catch {
            return
        }
        
        if ((captureSession.canAddInput(videoInput))) {
            captureSession.addInput(videoInput)
        } else {
            return
        }
        
        let captureMetadataOutput = AVCaptureMetadataOutput()
        
        captureSession.addOutput(captureMetadataOutput)
        
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        captureMetadataOutput.metadataObjectTypes = [
            AVMetadataObject.ObjectType.qr,
            AVMetadataObject.ObjectType.pdf417,
            AVMetadataObject.ObjectType.aztec,
            AVMetadataObject.ObjectType.code128,
            AVMetadataObject.ObjectType.code39,
            AVMetadataObject.ObjectType.code39Mod43,
            AVMetadataObject.ObjectType.code93,
            AVMetadataObject.ObjectType.ean13,
            AVMetadataObject.ObjectType.ean8
        ]
        
        captureSession.commitConfiguration()
        captureSession.startRunning()
        
        captureMetadataOutput.rectOfInterest = videoPreviewLayer.metadataOutputRectConverted(fromLayerRect: CGRect(x: (squareView?.frame.origin.x)!, y: (squareView?.frame.origin.y)!, width: 200, height: 200))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        captureSession.startRunning()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        captureSession.stopRunning()
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func onTapBackUB(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension GradingInventoryScanVC: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count == 0 {
            print("No QR code is detected")
            return
        }
            
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            if metadataObj.stringValue != nil {
                print(metadataObj.stringValue!)
                captureSession.stopRunning()
                self.dismiss(animated: true) {
                    self.delegate?.returnScanValue(val: metadataObj.stringValue!)
                }
                
            }
        }
    }
}
