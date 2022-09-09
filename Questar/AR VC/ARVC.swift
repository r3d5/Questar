//
//  ViewController.swift
//  Mementar
//
//  Created by d3pr3ss3r on 07.09.2022.
//

import UIKit
import RealityKit
import ARKit

class ARVC: UIViewController {
    
    @IBOutlet var arView: ARSCNView!
    var augmentedRealityConfiguration = ARImageTrackingConfiguration()
    var augmentedRealitySession = ARSession()
    var questData = [QuestStep]()
    var currentStep = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Load the "Box" scene from the "Experience" Reality File
//        let boxAnchor = try! Experience.loadBox()
        for quest in questData {
            loadDynamicImageReferences(quest: quest)
        }
        
        startARSession()
        // Add the box anchor to the scene
//        arView.scene.anchors.append(boxAnchor)
    }
    
    func startARSession(){
      
        arView.session = augmentedRealitySession
        arView.delegate = self

      augmentedRealitySession.run(augmentedRealityConfiguration, options: [.resetTracking, .removeExistingAnchors])
      
    }
    
    func loadDynamicImageReferences(quest: QuestStep){

        //1. Get The Image From The Folder
        guard let imageFromBundle = quest.stepImageTarget,
        //2. Convert It To A CIImage
        let imageToCIImage = CIImage(image: imageFromBundle),
        //3. Then Convert The CIImage To A CGImage
        let cgImage = convertCIImageToCGImage(inputImage: imageToCIImage)else { return }

        //4. Create An ARReference Image (Remembering Physical Width Is In Metres)
        let arImage = ARReferenceImage(cgImage, orientation: CGImagePropertyOrientation.up, physicalWidth: 1)

        //5. Name The Image
        arImage.name = "ImgForStep\(quest.sequenceNumber)"
        
        //5. Set The ARWorldTrackingConfiguration Detection Images
        augmentedRealityConfiguration.trackingImages.insert(arImage)
    }


    /// Converts A CIImage To A CGImage
    ///
    /// - Parameter inputImage: CIImage
    /// - Returns: CGImage
    func convertCIImageToCGImage(inputImage: CIImage) -> CGImage? {
        let context = CIContext(options: nil)
        if let cgImage = context.createCGImage(inputImage, from: inputImage.extent) {
         return cgImage
        }
        return nil
    }
}


 
extension ARVC: ARSCNViewDelegate {
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {

        //1. Enumerate Our Anchors To See If We Have Found Our Target Anchor
        for anchor in anchors{

            if let imageAnchor = anchor as? ARImageAnchor{

                //2. If The ImageAnchor Is No Longer Tracked Then Handle The Event
                if !imageAnchor.isTracked{

                }else{


                }
            }
        }
     }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        //1. If Out Target Image Has Been Detected Than Get The Corresponding Anchor
        guard let currentImageAnchor = anchor as? ARImageAnchor else { return }
        
//        let billboardConstraint = SCNBillboardConstraint()
//           billboardConstraint.freeAxes = SCNBillboardAxis.Y
        
        let x = currentImageAnchor.transform
        print(x.columns.3.x, x.columns.3.y , x.columns.3.z)
        
        //2. Get The Targets Name
        let name = currentImageAnchor.referenceImage.name!
        
        //3. Get The Targets Width & Height In Meters
        let width = currentImageAnchor.referenceImage.physicalSize.width
        let height = currentImageAnchor.referenceImage.physicalSize.height
        
        print("""
        Image Name = \(name)
        Image Width = \(width)
        Image Height = \(height)
        """)
       
        
        //4. Create A Plane Geometry To Cover The ARImageAnchor
        
        // SCN Text
        
        let uniqueImgs = augmentedRealityConfiguration.trackingImages.sorted(using: [
            KeyPathComparator(\.name, order: .forward),
            KeyPathComparator(\.name, order: .reverse),
        ])
       
        for img in augmentedRealityConfiguration.trackingImages {
            print(img.name)
        }
        
        print("Sorted")
        for img in uniqueImgs {
            print(img.name)
        }

        // 1 & 2 Define Sort Criteria and sort the array, using a trailing closure that sorts on a field/particular property you specify
        // Be aware: result is an array
        guard let currImg = uniqueImgs.firstIndex(where: {$0.name == name}) else {
         
            return }
        let foundImgIndex = uniqueImgs.distance(to: currImg)
      
        if foundImgIndex <= currentStep {
            if(foundImgIndex == currentStep) {
                currentStep += 1
            }
            print(foundImgIndex)
            print(currentStep)
            
            let textNode = SCNNode.text(
                    withString: questData[foundImgIndex].stepDescription,
                    color: .red,
                    shouldLookAtNode: arView.pointOfView!, // ARKit sceneView, so facing toward the phones camera
                    addAboveExistingNode: nil) // Some object added into the scene

            let textParentNode = SCNNode()
            textParentNode.addChildNode(textNode)
            
            node.addChildNode(textParentNode)
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        //1. If Out Target Image Has Been Detected Than Get The Corresponding Anchor
        guard let currentImageAnchor = anchor as? ARImageAnchor else { return }
        
//        let billboardConstraint = SCNBillboardConstraint()
//           billboardConstraint.freeAxes = SCNBillboardAxis.Y
        
        let x = currentImageAnchor.transform
        print(x.columns.3.x, x.columns.3.y , x.columns.3.z)
        
        //2. Get The Targets Name
        let name = currentImageAnchor.referenceImage.name!
        
        //3. Get The Targets Width & Height In Meters
        let width = currentImageAnchor.referenceImage.physicalSize.width
        let height = currentImageAnchor.referenceImage.physicalSize.height
        
        print("""
        Image Name = \(name)
        Image Width = \(width)
        Image Height = \(height)
        """)
       
        
        //4. Create A Plane Geometry To Cover The ARImageAnchor
        
        // SCN Text
        
        let uniqueImgs = augmentedRealityConfiguration.trackingImages.sorted(using: [
            KeyPathComparator(\.name, order: .forward),
            KeyPathComparator(\.name, order: .reverse),
        ])
       
        for img in augmentedRealityConfiguration.trackingImages {
            print(img.name)
        }
        
        print("Sorted")
        for img in uniqueImgs {
            print(img.name)
        }

        // 1 & 2 Define Sort Criteria and sort the array, using a trailing closure that sorts on a field/particular property you specify
        // Be aware: result is an array
        guard let currImg = uniqueImgs.firstIndex(where: {$0.name == name}) else {
         
            return }
        let foundImgIndex = uniqueImgs.distance(to: currImg)
      
        if foundImgIndex <= currentStep {
            if(foundImgIndex == currentStep) {
                currentStep += 1
            }
            print(foundImgIndex)
            print(currentStep)
            
            let textNode = SCNNode.text(
                    withString: questData[foundImgIndex].stepDescription,
                    color: .red,
                    shouldLookAtNode: arView.pointOfView!, // ARKit sceneView, so facing toward the phones camera
                    addAboveExistingNode: nil) // Some object added into the scene

            let textParentNode = SCNNode()
            textParentNode.addChildNode(textNode)
            
            node.addChildNode(textParentNode)
        }
    }
}

extension Collection {
    func distance(to index: Index) -> Int { distance(from: startIndex, to: index) }
}


extension SCNNode {
  static func text(
    withString string: String,
    color: UIColor,
    fontSize: Float = 0.1,
    shouldLookAtNode lookAtNode: SCNNode? = nil,
    addAboveExistingNode existingNode: SCNNode? = nil) -> SCNNode {

    let text = SCNText(string: string, extrusionDepth: 0.1)
    text.font = UIFont.systemFont(ofSize: 1.0)
    text.flatness = 0.01
    text.firstMaterial?.diffuse.contents = color

    let textNode = SCNNode(geometry: text)
    textNode.scale = SCNVector3(fontSize, fontSize, fontSize)

    var pivotCorrection = SCNMatrix4Identity

    if let lookAtNode = lookAtNode {
      let constraint = SCNLookAtConstraint(target: lookAtNode)
      constraint.isGimbalLockEnabled = true
      textNode.constraints = [constraint]

      // Rotate the text 180 degrees around the Y axis so that it faces the lookAtNode
      pivotCorrection = SCNMatrix4Rotate(pivotCorrection, .pi, 0, 1, 0)
    }

    // Change the text node's pivot to be centred rather than bototm left
    let (min, max) = text.boundingBox
    pivotCorrection = SCNMatrix4Translate(pivotCorrection, (max.x - min.x) / 2, 0, 0)

    // Apply the pivot correction
    textNode.pivot = pivotCorrection

    if let existingNode = existingNode {
      // Add a 0.3m Y axis offset so the text floats above the node
      textNode.position = SCNVector3(0, 0.3, 0)

      //
      existingNode.addChildNode(textNode)
    }

    return textNode
  }
}
