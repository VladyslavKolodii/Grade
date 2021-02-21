//
//  GradingPhotosVC.swift
//  Grading
//
//  Created by Aira on 22.02.2021.
//

import UIKit
import AlignedCollectionViewFlowLayout

protocol GradingPhotosVCDelegate {
    func didTapDoneUB()
}

class GradingPhotosVC: UIViewController {
    
    @IBOutlet weak var collectionUV: UICollectionView!
    
    let numberOfItemsPerRow: CGFloat = 2.0
    let leftAndRightPadding: CGFloat = 10.0
    
    var delegate: GradingPhotosVCDelegate?
    var capturedImages: [UIImage]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let alignedFlowLayout = collectionUV.collectionViewLayout as? AlignedCollectionViewFlowLayout
        alignedFlowLayout?.horizontalAlignment = .left
        
        collectionUV.dataSource = self
        collectionUV.delegate = self
        let tapCollectionVVGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture))
        collectionUV.addGestureRecognizer(tapCollectionVVGesture)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @objc func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            guard let targetIndexPath = collectionUV.indexPathForItem(at: gesture.location(in: collectionUV)) else {
                return
            }
            collectionUV.beginInteractiveMovementForItem(at: targetIndexPath)
        case .changed:
            collectionUV.updateInteractiveMovementTargetPosition(gesture.location(in: collectionUV))
        case .ended:
            collectionUV.endInteractiveMovement()
        default:
            collectionUV.cancelInteractiveMovement()
        }
    }
    
    @IBAction func onTapBackUB(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTapDoneUB(_ sender: Any) {
        self.dismiss(animated: true) {
            self.delegate?.didTapDoneUB()
        }
    }
}

extension GradingPhotosVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Schedule", bundle: nil).instantiateViewController(withIdentifier: "PhotoPreviewVC") as! PhotoPreviewVC
        vc.image = capturedImages![indexPath.row]
        self.present(vc, animated: true, completion: nil)
    }
}

extension GradingPhotosVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return capturedImages!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GradingPhotoCell", for: indexPath) as! GradingPhotoCell
        cell.capturedImage.image = capturedImages![indexPath.row]
        cell.indexLB.text = "\(indexPath.row + 1)"
        cell.indexPath = indexPath.row
        cell.delegate = self
        return cell
    }
}

extension GradingPhotosVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalSpcing = (numberOfItemsPerRow + 1) * leftAndRightPadding
        if let collection = self.collectionUV {
            let width = (collection.bounds.width - totalSpcing) / numberOfItemsPerRow
            return CGSize(width: width, height: width * 115 / 168)
        } else {
            return CGSize(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        }
    //Re-order
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = capturedImages?.remove(at: sourceIndexPath.row)
        capturedImages!.insert(item!, at: destinationIndexPath.row)
        collectionView.reloadData()
    }
}

extension GradingPhotosVC: GradingPhotoCellDelegate {
    func didTapCloseUB(indexPath: Int) {
        capturedImages?.remove(at: indexPath)
        collectionUV.reloadData()
    }
}


