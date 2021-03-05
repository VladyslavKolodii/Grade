//
//  GradingMaterialCaptureVC.swift
//  Grading
//
//  Created by Aira on 21.02.2021.
//

import UIKit
import AVFoundation

protocol GradingMaterialCaptureVCDelegate {
    func didTapBackUB()
    func didTapSkipUB()
    func didCompleteCapture()
}

class GradingMaterialCaptureVC: UIViewController {
    
    @IBOutlet weak var topUV: UIView!
    @IBOutlet weak var captureUB: UIView!
    @IBOutlet weak var retakeUB: UIView!
    @IBOutlet weak var photoGuideUB: UIView!
    @IBOutlet weak var rightActionUB: UIButton!
    @IBOutlet weak var decoUV: UIView!
    
    var delegate: GradingMaterialCaptureVCDelegate?
    
    var captureSession : AVCaptureSession!
    
    var backCamera : AVCaptureDevice!
    var frontCamera : AVCaptureDevice!
    var backInput : AVCaptureInput!
    var frontInput : AVCaptureInput!
    
    var previewLayer : AVCaptureVideoPreviewLayer!
    
    var videoOutput : AVCaptureVideoDataOutput!
    
    var takePicture = false
    var backCameraOn = true
    var isAlreadyOn = false
    
    var capturedImgArr: [UIImage] = [UIImage]()
    var isEmptyCapturedImgArr: Bool = false
    
    let switchCameraButton : UIButton = {
        let button = UIButton()
        let image = UIImage(named: "switchcamera")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapCapture = UITapGestureRecognizer(target: self, action: #selector(onTapCaptureUB))
        captureUB.addGestureRecognizer(tapCapture)
        
        let tapRetake = UITapGestureRecognizer(target: self, action: #selector(onTapRetakeUB))
        retakeUB.addGestureRecognizer(tapRetake)
        
        let tapPhotoGuide = UITapGestureRecognizer(target: self, action: #selector(onTapPhotoGuideUB))
        photoGuideUB.addGestureRecognizer(tapPhotoGuide)
        
        initUIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.isAlreadyOn == false {
            self.checkPermissions()
            self.setupAndStartCaptureSession()
        }
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    func initUIView() {
        view.backgroundColor = .black
        view.addSubview(switchCameraButton)
        switchCameraButton.addTarget(self, action: #selector(switchCamera(_:)), for: .touchUpInside)
        self.view.bringSubviewToFront(topUV)
        self.view.bringSubviewToFront(decoUV)
        self.view.bringSubviewToFront(captureUB)
        self.view.bringSubviewToFront(photoGuideUB)
        self.view.bringSubviewToFront(retakeUB)
    }
    
    func checkPermissions() {
        let cameraAuthStatus =  AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch cameraAuthStatus {
        case .authorized:
            return
        case .denied:
            abort()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler:
                                            { (authorized) in
                                                if(!authorized){
                                                    abort()
                                                }
                                            })
        case .restricted:
            abort()
        @unknown default:
            fatalError()
        }
    }
    
    func setupAndStartCaptureSession(){
        DispatchQueue.global(qos: .userInitiated).async{
            //init session
            self.captureSession = AVCaptureSession()
            //start configuration
            self.captureSession.beginConfiguration()
            
            //session specific configuration
            if self.captureSession.canSetSessionPreset(.photo) {
                self.captureSession.sessionPreset = .photo
            }
            self.captureSession.automaticallyConfiguresCaptureDeviceForWideColor = true
            
            //setup inputs
            self.setupInputs()
            
            DispatchQueue.main.async {
                //setup preview layer
                self.setupPreviewLayer()
            }
            
            //setup output
            self.setupOutput()
            
            //commit configuration
            self.captureSession.commitConfiguration()
            //start running it
            self.captureSession.startRunning()
        }
    }
    
    func setupInputs(){
        //get back camera
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            backCamera = device
        } else {
            return
            //handle this appropriately for production purposes
//            fatalError("no back camera")
        }
        
        //get front camera
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) {
            frontCamera = device
        } else {
            fatalError("no front camera")
        }
        
        //now we need to create an input objects from our devices
        guard let bInput = try? AVCaptureDeviceInput(device: backCamera) else {
            fatalError("could not create input device from back camera")
        }
        backInput = bInput
        if !captureSession.canAddInput(backInput) {
            fatalError("could not add back camera input to capture session")
        }
        
        guard let fInput = try? AVCaptureDeviceInput(device: frontCamera) else {
            fatalError("could not create input device from front camera")
        }
        frontInput = fInput
        if !captureSession.canAddInput(frontInput) {
            fatalError("could not add front camera input to capture session")
        }
        
        //connect back camera input to session
        captureSession.addInput(backInput)
    }
    
    func setupOutput(){
        videoOutput = AVCaptureVideoDataOutput()
        let videoQueue = DispatchQueue(label: "videoQueue", qos: .userInteractive)
        videoOutput.setSampleBufferDelegate(self, queue: videoQueue)
        
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        } else {
            fatalError("could not add video output")
        }
        
        videoOutput.connections.first?.videoOrientation = .portrait
    }
    
    func setupPreviewLayer(){
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.previewLayer?.connection?.videoOrientation = .portrait
        view.layer.insertSublayer(previewLayer, below: switchCameraButton.layer)
        previewLayer.frame = self.view.layer.frame
        print("self.view.layer.frame",self.view.layer.frame)
    }
    
    func switchCameraInput(){
        //don't let user spam the button, fun for the user, not fun for performance
        switchCameraButton.isUserInteractionEnabled = false
        
        //reconfigure the input
        captureSession.beginConfiguration()
        if backCameraOn {
            captureSession.removeInput(backInput)
            captureSession.addInput(frontInput)
            backCameraOn = false
        } else {
            captureSession.removeInput(frontInput)
            captureSession.addInput(backInput)
            backCameraOn = true
        }
        
        //deal with the connection again for portrait mode
        videoOutput.connections.first?.videoOrientation = .portrait
        
        //mirror the video stream for front camera
        videoOutput.connections.first?.isVideoMirrored = !backCameraOn
        
        //commit config
        captureSession.commitConfiguration()
        
        //acitvate the camera button again
        switchCameraButton.isUserInteractionEnabled = true
    }
    
    func handleRightBarItem() {
        if capturedImgArr.isEmpty {
            isEmptyCapturedImgArr = false
            rightActionUB.setTitle("Skip", for: .normal)
        } else {
            isEmptyCapturedImgArr = true
            rightActionUB.setTitle("Done", for: .normal)
        }
    }
    
    @objc func onTapCaptureUB() {
        takePicture = true
    }
    
    @objc func onTapRetakeUB() {
        if capturedImgArr.isEmpty {
            return
        }
        capturedImgArr.removeLast()
        handleRightBarItem()
    }
    
    @objc func switchCamera(_ sender: UIButton?){
        switchCameraInput()
    }
    
    @objc func onTapPhotoGuideUB() {
        let vc = UIStoryboard(name: "Schedule", bundle: nil).instantiateViewController(withIdentifier: "GradingPhotoGuideVC") as! GradingPhotoGuideVC
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func onTapBackUB(_ sender: Any) {
        self.delegate?.didTapBackUB()
    }
    
    @IBAction func onTapRightBarItem(_ sender: Any) {
        if !isEmptyCapturedImgArr {
            self.delegate?.didTapSkipUB()
        } else {
            self.takePicture = false
            let vc = UIStoryboard(name: "Schedule", bundle: nil).instantiateViewController(withIdentifier: "GradingPhotosVC") as! GradingPhotosVC
            vc.capturedImages = self.capturedImgArr
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
            DispatchQueue.main.async {
                self.isAlreadyOn = true
                self.checkPermissions()
                self.setupAndStartCaptureSession()
            }
        }
    }
}

extension GradingMaterialCaptureVC: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if !takePicture {
            return //we have nothing to do with the image buffer
        }
        
        //try and get a CVImageBuffer out of the sample buffer
        guard let cvBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        //get a CIImage out of the CVImageBuffer
        let ciImage = CIImage(cvImageBuffer: cvBuffer)
        
        //get UIImage out of CIImage
        let uiImage = UIImage(ciImage: ciImage)
        DispatchQueue.main.async {
            self.capturedImgArr.append(uiImage)
            self.handleRightBarItem()
            self.takePicture = false
        }
    }
    
}

extension GradingMaterialCaptureVC: GradingPhotosVCDelegate {
    func didTapDoneUB() {
        self.delegate?.didCompleteCapture()
    }
}
