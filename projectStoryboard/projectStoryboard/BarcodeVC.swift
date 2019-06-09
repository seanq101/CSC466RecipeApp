//
//  BarcodeVC.swift
//  projectStoryboard
//
//  Created by Andrew Puleo on 6/8/19.
//  Copyright © 2019 Sean Quinn. All rights reserved.
//

import UIKit
import AVFoundation

class BarcodeVC: UIViewController {
    
    var foodItem: FoodItem?
    var upcSearchService: UpcSearchService?
    @IBOutlet weak var messageLabel: UILabel!
    
    var captureSession = AVCaptureSession()
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    
    private let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                                      AVMetadataObject.ObjectType.code39,
                                      AVMetadataObject.ObjectType.code39Mod43,
                                      AVMetadataObject.ObjectType.code93,
                                      AVMetadataObject.ObjectType.code128,
                                      AVMetadataObject.ObjectType.ean8,
                                      AVMetadataObject.ObjectType.ean13,
                                      AVMetadataObject.ObjectType.aztec,
                                      AVMetadataObject.ObjectType.pdf417,
                                      AVMetadataObject.ObjectType.itf14,
                                      AVMetadataObject.ObjectType.dataMatrix,
                                      AVMetadataObject.ObjectType.interleaved2of5,
                                      AVMetadataObject.ObjectType.qr]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the back-facing camera for capturing videos
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)
        
        guard let captureDevice = deviceDiscoverySession.devices.first else {
            print("Failed to get the camera device")
            return
        }
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Set the input device on the capture session.
            captureSession.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            //            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        
        // Start video capture.
        captureSession.startRunning()
        
        // Move the message label and top bar to the front
        view.bringSubview(toFront: messageLabel)
        
        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()
        
        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            view.bringSubview(toFront: qrCodeFrameView)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helper methods
    
    func launchApp(title: String?) {
        
        if presentedViewController != nil {
            return
        }
        
        if let foodName = title {
            let alertPrompt = UIAlertController(title: "Add to pantry", message: "You're going add \(foodName) to your pantry", preferredStyle: .actionSheet)
            let confirmAction = UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default, handler: {
                    (action) -> Void in
                
                let currentDate = Date()
                var dateComponent = DateComponents()
                
                dateComponent.day = 14
                
                let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)
                
                self.foodItem = FoodItem.init(properName: self.upcSearchService!.title, apiName: "", quantity: 1, unit: "pinch", expiry: futureDate!)
                self.performSegue(withIdentifier: "sendFoodItemFromBarcode", sender: self)
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
            
            alertPrompt.addAction(confirmAction)
            alertPrompt.addAction(cancelAction)
            
            present(alertPrompt, animated: true, completion: nil)
        }
    }
    
}

extension BarcodeVC: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            messageLabel.text = "No BARCODE code is detected"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            // If the found metadata is equal to the QR code metadata (or barcode) then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                var spoonacularUpcUrl = "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/food/products/upc/" + metadataObj.stringValue!.dropFirst()
                
                print("PATH")
                print(spoonacularUpcUrl)
                
                let session = URLSession(configuration: URLSessionConfiguration.default)
                
                
                var spoonRequest = URLRequest(url: URL(string: spoonacularUpcUrl)!)
                spoonRequest.setValue("282dc9c01amsh58247426577f9a7p1776a9jsn132cf0e412e0", forHTTPHeaderField: "X-RapidAPI-Key")
                //X-RapidAPI-Host", "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com"
                spoonRequest.setValue("spoonacular-recipe-food-nutrition-v1.p.rapidapi.com", forHTTPHeaderField: "X-RapidAPI-Host")
                let spoonTask: URLSessionDataTask = session.dataTask(with: spoonRequest)
                { [unowned self] (receivedData, response, error) -> Void in
                    if let data = receivedData {
                        do {
                            let decoder = JSONDecoder() // get a decoder
                            // decode based on the structure [RecipeSearchService]
                            // change RecipeSearchService as needed to shapeof response
                            self.upcSearchService = try decoder.decode(UpcSearchService.self, from: data)
                            
                            print("PRINT DATA")
                            print(self.upcSearchService)
//                            print(type(of: self.recipeSearchService))
                        }
                        catch {
                            print("Exception on Decode: \(error)")
                        }
                        
                    }
//                    DispatchQueue.main.async{
//                    }
                }
                
                spoonTask.resume()
                print("HERE I AM")
                print(upcSearchService)
                
                launchApp(title: upcSearchService?.title)
                messageLabel.text = upcSearchService?.title
            }
        }
    }
    
}


//This code enables you to set a corner radius from the interface builder
//with help from stackoverflow: https://stackoverflow.com/questions/26961274/how-can-i-make-a-button-have-a-rounded-border-in-swift
@IBDesignable extension UIButton {
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}
