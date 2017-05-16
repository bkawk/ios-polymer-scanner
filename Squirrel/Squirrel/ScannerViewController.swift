//
//  ScannerViewController.swift
//  GEVME-Onsite-iOS
//
//  Created by Duc Nguyen on 2/22/16.
//  Copyright © 2016 Gevme. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

public protocol ScanPickerDelegate: class {
    func scanPicker(scan: ScannerViewController, didScanFetchFailed error: NSError)
    func scanPicker(scan: ScannerViewController, didScan: String)
}

open class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var captureSession: AVCaptureSession!
    var previewPlayer: AVCaptureVideoPreviewLayer!
    var highlightView   : UIView = UIView()
    weak var delegate: ScanPickerDelegate?
    
    @IBOutlet weak var cameraView: UIView!
    func setupOverlayScanned() {
        // Allow the view to resize freely
        self.highlightView.autoresizingMask =  [.flexibleTopMargin, .flexibleBottomMargin, .flexibleLeftMargin, .flexibleRightMargin]
        
        // Select the color you want for the completed scan reticle
        self.highlightView.layer.borderColor = UIColor.colorWithHexString(hex: "#328FF7").cgColor
        self.highlightView.layer.borderWidth = 3
        self.highlightView.layer.cornerRadius = 2
        
        // Add it to our controller's view as a subview.
        highlightView.backgroundColor = UIColor.clear
        // highlightView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        self.view.addSubview(self.highlightView)
        
    }
    
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        // setup overlay
        setupOverlayScanned()
        
        view.backgroundColor = UIColor.black
        
        //register orientation changes
        registernNotification()
        
        // setup scan
        self.perform(#selector(ScannerViewController.setupScan), with: nil, afterDelay: 0.5)
        
    }
    
    func setupScan() {
        captureSession = AVCaptureSession()
        
        let videoCaptureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput =  try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        // input
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        // out put
        let metadataOutput = AVCaptureMetadataOutput()
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes =  [AVMetadataObjectTypeQRCode, AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode, AVMetadataObjectTypeInterleaved2of5Code, AVMetadataObjectTypeITF14Code, AVMetadataObjectTypeDataMatrixCode]
        } else {
            failed()
            return
        }
        
        // set up preview layer to display in the screen
        previewPlayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewPlayer.frame =  view.layer.bounds
        previewPlayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.cameraView.layer.addSublayer(previewPlayer)
        
        // start running
        captureSession.startRunning()
    }
    
    public func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        var highlightViewRect = CGRect.zero
        
        if let metadataObject = metadataObjects.first {
            
            let readableObject = metadataObject as! AVMetadataMachineReadableCodeObject;
            let objCode = previewPlayer.transformedMetadataObject(for: readableObject)!
            highlightViewRect = objCode.bounds
            
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            
            self.captureSession.stopRunning()
            
            foundCode(code: readableObject.stringValue)
        
            self.highlightView.isHidden = false
            self.highlightView.frame = highlightViewRect
            self.view.bringSubview(toFront: self.highlightView)
        }
    }
    
    func flashlightPressed(sender: UIBarButtonItem) {
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        // if device is nil, return back
        guard device != nil else  {
            return
        }
        
        if let mydevice = device {
            if (mydevice.hasTorch) {
                do {
                    try mydevice.lockForConfiguration()
                    if (mydevice.torchMode == AVCaptureTorchMode.on) {
                        mydevice.torchMode = AVCaptureTorchMode.off
                        sender.image =  UIImage(named: "flashoff")
                    } else {
                        try mydevice.setTorchModeOnWithLevel(1.0)
                        sender.image =  UIImage(named: "flashon")
                    }
                    mydevice.unlockForConfiguration()
                } catch {
                    print(error)
                }
            }
        }
    }
    
    
    func failed() {
        
        self.delegate?.scanPicker(scan: self, didScanFetchFailed:NSError(domain: "Your device does not support scanning a code from an item. Please use a device with a camera.", code: 1001, userInfo: nil))
        
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true, completion: nil)
        captureSession = nil
        
        
    }
    
    @IBAction func closePressed(_ sender: AnyObject) {
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
            self.dismiss(animated: true)
    }
    
    @IBAction func photoPressed(_ sender: Any) {
        loadPhoto()
    }
}

extension ScannerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func loadPhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        self.navigationController?.pushViewController(imagePicker, animated: true)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        var  chosenImage = UIImage()
        chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        if let string = ScanStaticImage().scan(forQR: chosenImage) {
               print(string)
              delegate?.scanPicker(scan: self, didScan: string)
        } else {
            let ac = UIAlertController(title: "Scanning", message: "No barcode found", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.navigationController?.present(ac, animated: true, completion: nil)
            
            delegate?.scanPicker(scan: self, didScan: "")
        }
     
        dismiss(animated:true, completion: nil) //5
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        _ = picker.popViewController(animated: true)
    }

}


// MARK: Result
extension ScannerViewController {
    
    func restartScanning() {
        if (self.captureSession?.isRunning == false) {
            self.highlightView.isHidden = true
            self.captureSession.startRunning();
        }
    }
    
    func foundCode(code: String) {
        self.delegate?.scanPicker(scan: self, didScan: code)
    }
}

extension ScannerViewController {
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning();
        }
        
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning();
        }
    }
}

// fix orientation for landscape mode
extension ScannerViewController {
    
    // you have to register observing change orientation on viewDidload
    func registernNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(ScannerViewController.orientationChanged), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    // implement when the device rotates
    func orientationChanged() {
        
        // updaet preview player
        guard previewPlayer != nil else {
            return
        }
        
        switch (UIApplication.shared.statusBarOrientation) {
        case .portraitUpsideDown:
            previewPlayer.connection.videoOrientation = .portraitUpsideDown
        case .portrait:
            previewPlayer.connection.videoOrientation =  .portrait
        case .landscapeLeft:
            previewPlayer.connection.videoOrientation =  .landscapeLeft
        case .landscapeRight:
            previewPlayer.connection.videoOrientation =  .landscapeRight
        default:
            break
        }
        
        // update frame
        previewPlayer.frame =  view.layer.bounds
    }
}
