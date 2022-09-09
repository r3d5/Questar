//
//  CreateQuestVC.swift
//  Mementar
//
//  Created by d3pr3ss3r on 09.09.2022.
//

import UIKit
import CropViewController

class CreateQuestVC: UIViewController {
    
    @IBOutlet var collection: UICollectionView!
    var questData = [QuestStep]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collection.delegate = self
        collection.dataSource = self
        self.collection.register(UINib(nibName: "QuestStepCell", bundle: nil), forCellWithReuseIdentifier: "testcell")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func addQuestStep() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = false
        vc.showsCameraControls = true
        vc.delegate = self
        present(vc, animated: true)
     
//        let newStep = QuestStep(sequenceNumber: questData.count + 1, stepDescription: "Find paprica pringles in our room <3", stepImageTarget: UIImage(named: "testTarget"))
//        questData.append(newStep)
//        let indexPath = IndexPath(row: questData.count - 1, section: 0)
//        collection.insertItems(at: [indexPath])
//        collection.reloadData()
    }
    
    @IBAction func goAR() {
        let arVC = ARVC.storyboardVC()
        arVC.questData = questData
        navigationController?.pushViewController(arVC, animated: true)
    }
    
}

extension CreateQuestVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (collection.frame.size.width - space) / 2.0
        return CGSize(width: size, height: size)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return questData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "testcell", for: indexPath) as! QuestStepCell
        cell.customize(with: questData[indexPath.row])
        return cell
    }
}

extension CreateQuestVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate  {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.originalImage] as? UIImage else {
            print("No image found")
            return
        }

        // print out the image size as a test
        print(image.size)
        presentCropViewController(img: image)
        
    }
    
    func presentCropViewController(img:UIImage) {
      let image: UIImage = img //Load an image
      
      let cropViewController = CropViewController(image: image)
      cropViewController.delegate = self
      present(cropViewController, animated: true, completion: nil)
    }
    

}


extension CreateQuestVC: CropViewControllerDelegate {
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: false)
        // create the actual alert controller view that will be the pop-up
        let alertController = UIAlertController(title: "Step \(questData.count+1)", message: "Enter the hint to find next item", preferredStyle: .alert)

        alertController.addTextField { (textField) in
            // configure the properties of the text field
            textField.placeholder = "Hint"
        }
        // add the buttons/actions to the view controller
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            alertController.dismiss(animated: true)
            cropViewController.dismiss(animated: true)
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in

            // this code runs when the user hits the "save" button
            let inputName = alertController.textFields![0].text
            print(inputName)
            print(image.size)
            let questStep = QuestStep(sequenceNumber: self.questData.count+1, stepDescription: inputName!, stepImageTarget: image)
            self.questData.append(questStep)
            let indexPath = IndexPath(row: self.questData.count - 1, section: 0)
            self.collection.insertItems(at: [indexPath])
                   
        }

        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)

        present(alertController, animated: true, completion: nil)
        
    }
}
