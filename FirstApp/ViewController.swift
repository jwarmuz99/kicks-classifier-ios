//
//  ViewController.swift
//  FirstApp
//
//  Created by Kuba Warmuz on 2/26/21.
//

import UIKit
import CoreML
import Vision


class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{

    @IBOutlet weak var selectImageButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var sneakerName: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        selectImageButton.layer.cornerRadius = 15;
        loadingIndicator.alpha = 0
        sneakerName.alpha = 0
    }

    @IBOutlet weak var chosenImage: UIImageView!
    
    // Function to select an image from the camera after tapping the button
    @IBAction func selectImageTapped(_ sender: UIButton) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerController.SourceType.camera
        image.allowsEditing = true
        
        self.present(image, animated: true)
        
    }
    
    // imagePickerController converts the image to CIImage format and uses detect function to classify the image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        if let userPickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            guard let convertedImage = CIImage(image: userPickedImage) else {
                fatalError("cannot convert to CIImage")
                }
            
            detect(image: convertedImage, sneakerName: sneakerName)
            chosenImage.image = userPickedImage
            
        }
            
        self.dismiss(animated: true, completion: nil)
        //loadingIndicator.alpha = 1
        //do {sleep(3)}
        //loadingIndicator.alpha = 0
        sneakerName.alpha = 1
    }
    
    // image classifier that takes an image as an input and output the prediction
    // it uses a neural network defined in ctzk.mlmodel file
    func detect(image: CIImage, sneakerName: UILabel) {
            
            // define the model
            guard let model = try? VNCoreMLModel(for: ctzk().model) else {
                fatalError("Can't load model")
            }
            // request the prediction
            let request = VNCoreMLRequest(model: model) { (request, error) in
                guard let result = request.results?.first as? VNClassificationObservation else {
                    fatalError("Could not complete classfication")
                }
                // show predicted label
                sneakerName.text = result.identifier.capitalized
                                
            }
            
            let handler = VNImageRequestHandler(ciImage: image)
            
            do {
                try handler.perform([request])
            }
            catch {
                print(error)
            }
            
        }

    
    

}

