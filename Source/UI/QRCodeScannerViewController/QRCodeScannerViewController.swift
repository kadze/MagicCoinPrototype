//
//  QRCodeScannerViewController.swift
//  HoloArts
//
//  Created by Oleh Korchytskyi on 03/07/2017.
//  Copyright © 2017 Gamayun. All rights reserved.
//

import UIKit
import AVFoundation

class QRCodeScannerViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate {
    
    
    @IBOutlet weak var kioskLabel: UILabel!
    @IBOutlet weak var kioskLabelBackgroundView: UIView!
    
    @IBOutlet weak var videoPreview: UIView!
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    
    @IBOutlet weak var qrCodeOutputData: UILabel!
    
    private var kioskAuthURL: URL?
    private var kioskName: String?
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modalTransitionStyle = .crossDissolve
        initializeVideoCapturingSession()
        qrCodeOutputData.text = ""
        disallowLoginIntoKiosk(animated: false)
    }
    
    // MARK: - Video Capturing
    func initializeVideoCapturingSession() {
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Initialize the captureSession object.
            captureSession = AVCaptureSession()
            
            // Set the input device on the capture session.
            captureSession?.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            videoPreview.layer.addSublayer(videoPreviewLayer!)
            
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubview(toFront: qrCodeFrameView)
            }
            
            // Start video capture.
            captureSession?.startRunning()
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
    }
    
    // MARK: - AVCaptureMetadataOutputObjectsDelegate
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        guard let metadataObjects = metadataObjects, metadataObjects.count > 0 else {
            qrCodeFrameView?.frame = CGRect.zero
            qrCodeOutputData.text = "QR Data: No QR code is detected"
            disallowLoginIntoKiosk()
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObjectTypeQRCode {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject?.bounds ?? .zero
            
            
            guard
                let stringValue = metadataObj.stringValue,
                let url = URL(string: stringValue),
                let kioskCode = stringValue.matches(for: "t=([0-9])").first else {
                    disallowLoginIntoKiosk()
                    return
            }
            
            kioskAuthURL = url
            kioskName = kioskCode.replacingOccurrences(of: "t=", with: "Kiosk #")
            kioskLabel.text = kioskName
            
            performSegue(withIdentifier: "confirm_kiosk_login", sender: nil)
            
            //            qrCodeOutputData.text = "QR Data: \(stringValue)"
            //            allowLoginIntoKiosk()
            
        }
    }
    
    // MARK: - Login
    func allowLoginIntoKiosk(animated: Bool = true) {
        if animated {
            let animator = UIViewPropertyAnimator(duration: 0.35, curve: .easeInOut) { [weak self] in
                self?.allowLoginIntoKiosk(animated: false)
            }
            animator.startAnimation()
        } else {
            kioskLabel.alpha = 1
            kioskLabelBackgroundView.alpha = 1
        }
    }
    
    func disallowLoginIntoKiosk(animated: Bool = true) {
        
        kioskAuthURL = nil
        kioskName = nil
        
        if animated {
            let animator = UIViewPropertyAnimator(duration: 0.35, curve: .easeInOut) { [weak self] in
                self?.disallowLoginIntoKiosk(animated: false)
            }
            animator.startAnimation()
        } else {
            kioskLabel.alpha = 0
            kioskLabelBackgroundView.alpha = 0
        }
    }
    
    // MARK: - Actions
    
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
