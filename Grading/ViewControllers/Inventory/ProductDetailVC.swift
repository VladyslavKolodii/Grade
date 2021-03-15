//
//  ProductDetailVC.swift
//  Grading
//


import UIKit
import Kingfisher
import SVProgressHUD

class ProductDetailVC: BaseVC {
    @IBOutlet weak var productId: UILabel!
    @IBOutlet weak var productType: UILabel!
    @IBOutlet weak var process: UILabel!
    @IBOutlet weak var enviro: UILabel!
    @IBOutlet weak var totoalGrade: UILabel!
    @IBOutlet weak var totalGram: UILabel!
    @IBOutlet weak var range: UILabel!
    @IBOutlet weak var appPrice: UILabel!
    @IBOutlet weak var listPrice: UILabel!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var supplier: UILabel!
    @IBOutlet weak var clvMain: UICollectionView!
    @IBOutlet weak var name: UILabel!
    
    
    var inventory: Inventory?
    var onDeletedInventory: ((Inventory) ->())?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setData()
        // Do any additional setup after loading the view.
    }
    
    func setData() {
        guard let inventory = inventory else {
            return
        }
        self.productId.text = inventory.lotId
        self.productType.text = inventory.productType
        self.process.text = inventory.processed
        self.enviro.text = inventory.environment
        self.totoalGrade.text = inventory.totalGrade.string
        self.totalGram.text = inventory.totalGrams.string
        self.range.text = "$\(inventory.appraisedRange.first?.string ?? "") - \(inventory.appraisedRange.last?.string ?? "")"
        self.appPrice.text = "\(inventory.appraisedPrice.string.dola()) / gram"
        self.listPrice.text = "\(inventory.listPrice.string.dola()) / gram"
        self.total.text = inventory.totalValue.string.dola()
        self.supplier.text = inventory.supplier?.name
        self.name.text = inventory.title
        self.clvMain.reloadData()
    }
    
    @IBAction func photoTap(_ sender: Any) {
        let vc = InventoryAddPhotoVC.instantiate(from: .inventory)
        vc.hidesBottomBarWhenPushed = true
        vc.modalPresentationStyle = .fullScreen
        vc.onTakedPicture = { image in
            if let image = image, let inventory = self.inventory {
                self.addInventoryPhoto(inventory: inventory, image: image) {
                    self.setData()
                }
            }
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func backTap(_ sender: Any) {
        navigationController?.popViewController()
    }

    @IBAction func deleteTap(_ sender: Any) {
        self.showAlertConfirm(title: Bundle.main.appName, message: "Do you want to delete \(inventory?.title ?? "") inventory?", buttonTitles: ["Yes","No"], highlightedButtonIndex: 1) { index in
            if index == 0 {
                if let inventory = self.inventory {
                    self.onDeletedInventory?(inventory)
                    self.navigationController?.popViewController()
                }
            }
        }
    }
}

extension ProductDetailVC : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    // MARK: -  collection View Delegate
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return inventory?.images.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "InventoryPhotoCell", for: indexPath) as? InventoryPhotoCell else{ return UICollectionViewCell() }
        let imageUrl = inventory?.images[indexPath.row]
        let url = URL(string: imageUrl ?? "")
        let processor = DownsamplingImageProcessor(size: cell.imgView.bounds.size)
                     |> RoundCornerImageProcessor(cornerRadius: 10)
        cell.imgView.kf.indicatorType = .activity
        cell.imgView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "ic_slide_document_empty"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        {
            result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
                cell.imgView.image = value.image
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
                cell.imgView.image = UIImage(named: "ic_slide_document_empty")
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        // splace between two cell horizonatally
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        // splace between two cell vertically
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        // give space top left bottom and right for cells
        return UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 85 , height: 85)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = PhotoDetailVC.instantiate(from: .inventory)
        vc.imagesArray = inventory?.images ?? []
        vc.index = indexPath.row
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: Webservice
extension ProductDetailVC {
    func addInventoryPhoto(inventory: Inventory,
                           image: UIImage,
                           completion: (() -> Void)? = nil) {
        let service = AppService()
        SVProgressHUD.show()
        service.addInventoryPhoto(id: inventory.id, image: image) { json in
            let statusCode = json["status"].intValue
            switch statusCode {
            case ResponseStatusCode.success.rawValue:
                self.getInventoryDetail(inventory: inventory) {
                    completion?()
                    SVProgressHUD.dismiss()
                }
            default:
                SVProgressHUD.dismiss()
                if let message = json["messages"].string{
                    self.showErrorAlert(message: message)
                } else {
                    self.showErrorAlert(message: "Something went wrong. Please try again.")
                }
            }
        }
    }
    func getInventoryDetail(inventory: Inventory, completion: (() -> Void)? = nil) {
        let service = AppService()
        SVProgressHUD.show()
        service.getInventoryDetail(id: inventory.id) { json in
            let statusCode = json["status"].intValue
            switch statusCode {
            case ResponseStatusCode.success.rawValue:
                let response = json["response"]
                inventory.mapInfoData(response)
                completion?()
            default:
                if let message = json["messages"].string{
                    self.showErrorAlert(message: message)
                } else {
                    self.showErrorAlert(message: "Something went wrong. Please try again.")
                }
            }
            SVProgressHUD.dismiss()
        }
    }
}


