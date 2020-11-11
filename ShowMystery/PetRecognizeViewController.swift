//
//  PetRecognizeViewController.swift
//  ShowMystery
//
//  Created by Vahe Toroyan on 10/26/20.
//

import UIKit
import SceneKit
import ARKit
import SwiftUI
import AVFoundation

// MARK: - ARViewIndicator
struct ARViewIndicator: UIViewControllerRepresentable {
   typealias UIViewControllerType = PetRecognizeViewController

   func makeUIViewController(context: Context) -> PetRecognizeViewController {
      return PetRecognizeViewController()
   }

   func updateUIViewController(_ uiViewController: ARViewIndicator.UIViewControllerType,
                               context: UIViewControllerRepresentableContext<ARViewIndicator>) { }
}

class PetRecognizeViewController: UIViewController, ARSCNViewDelegate {

    var arView: ARSCNView {
       return self.view as! ARSCNView
    }

    override func loadView() {
      self.view = ARSCNView(frame: .zero)
    }

    var timer: Timer?
    var audioPlayer : AVPlayer!
    
    var searchLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: UIScreen.main.bounds.width/2 - 100,
                                          y: UIScreen.main.bounds.height - 240,
                                          width: 200,
                                          height: 200))
            label.textAlignment = .center
            label.numberOfLines = 3
            label.text = ""
            label.font = UIFont(name: "BrandonGrotesque-Light",
                                size: 18)
            label.textColor = .purple
            return label
        }()

    lazy var myLabel: UILabel = {
            let label = UILabel(frame: CGRect(x: 3,
                                              y: 15,
                                              width: 195,
                                              height: 100))
            label.textAlignment = .center
            label.numberOfLines = 3
            label.text = ""
            label.font = UIFont(name: "BrandonGrotesque-Light",
                                size: 20)
            label.textColor = .purple
            return label
        }()

    override func viewDidLoad() {
       super.viewDidLoad()
       arView.delegate = self
       arView.scene = SCNScene()
       self.view.addSubview(searchLabel)
       self.searchLabel.transform = CGAffineTransform(rotationAngle: -.pi / 4)
       self.searchLabel.addTrailing(image: #imageLiteral(resourceName: "find_image"))
       self.searchLabel.addSubview(myLabel)
    }

    // MARK: - Functions for standard AR view handling
    override func viewDidAppear(_ animated: Bool) {
       super.viewDidAppear(animated)

       self.animate()
    }

    override func viewDidLayoutSubviews() {
       super.viewDidLayoutSubviews()
    }

    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       let configuration = ARWorldTrackingConfiguration()
       arView.session.run(configuration)
       arView.delegate = self

      timer = Timer.scheduledTimer(timeInterval: 3,
                                   target: self,
                                   selector: #selector(self.detectAnimal),
                                   userInfo: nil,
                                   repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       super.viewWillDisappear(animated)
       arView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    func sessionWasInterrupted(_ session: ARSession) {}
    func sessionInterruptionEnded(_ session: ARSession) {}
    func session(_ session: ARSession,
                 didFailWithError error: Error) {}
    func session(_ session: ARSession,
                 cameraDidChangeTrackingState camera: ARCamera) {}

    // MARK: - Animal Detection Part

    @objc func detectAnimal() {
        guard let currentFrameBuffer = self.arView
                                           .session
                                           .currentFrame?
                                           .capturedImage else { return }
        let image = CIImage(cvPixelBuffer: currentFrameBuffer)
        let detectAnimalRequest = VNRecognizeAnimalsRequest { (request, error) in
            DispatchQueue.main.async {
                if let result = request.results?.first as? VNRecognizedObjectObservation {

                    let cats = result.labels.filter({$0.identifier == "Cat"})
                    for _ in cats {
                        self.myLabel.text = "Wow! \nYou found a \nCAT"
                        self.playCatSound()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.8) {
                            self.myLabel.text = ""
                            self.audioPlayer.pause()
                        }
                    }

                    let dogs = result.labels.filter({$0.identifier == "Dog"})
                    for _ in dogs {
                        self.myLabel.text = "Wow! \nYou found a \nDOG"
                        self.playDogSound()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.8) {
                            self.myLabel.text = ""
                            self.audioPlayer.pause()
                        }
                    }
                }
            }
        }
        
        DispatchQueue.global().async {
            try? VNImageRequestHandler(ciImage: image).perform([detectAnimalRequest])
        }
    }

    func playCatSound() {
        guard let url = Bundle.main.url(forResource: "cat",
                                        withExtension: "mp3") else { return }
        audioPlayer = AVPlayer(url: url)
        audioPlayer?.play()
       }

    func playDogSound() {
        guard let url = Bundle.main.url(forResource: "dog",
                                        withExtension: "mp3") else { return
    }
        audioPlayer = AVPlayer(url: url)
        audioPlayer?.play()
   }

    func animate() {
        
        var transform = view.transform
        transform = transform.rotated(by: .pi/4)

        UIView.animate(withDuration: 1.25, animations: {
            self.searchLabel.transform = transform
        }) { (completed) in
            transform = CGAffineTransform.identity
            UIView.animate(withDuration: 1.25,
                           delay: 0,
                           options: [.autoreverse, .repeat],
                           animations: {
                self.searchLabel.transform = CGAffineTransform(rotationAngle: -.pi / 4)
            }, completion: nil)
        }
    }
}

extension UILabel {
    func addTrailing(image: UIImage) {
        let attachment = NSTextAttachment()
        attachment.image = image
        let attachmentString = NSAttributedString(attachment: attachment)
        let string = NSMutableAttributedString(string: self.text!,
                                               attributes: [:])
        string.append(attachmentString)
        self.attributedText = string
    }
}
