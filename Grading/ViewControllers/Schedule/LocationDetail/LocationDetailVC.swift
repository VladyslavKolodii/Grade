//
//  LocationDetailController.swift
//  Demo
//
//

import UIKit
import MapKit
import SVProgressHUD
class LocationDetailVC: UIViewController {
    
    //MARK:- @IBOutlet Variables
    @IBOutlet weak var navigationBarView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topUV: UIView!
    
    var selectedID: Int?
    var appointLocation: AppointLocation = AppointLocation()
    
    let ContentArray = ["Odit neque nam quas aut voluptatem sequi. Ut sit qui alias.","Leborum delectus minus dicta fuga quam eveniet molestiae vitae et.","Mollitia nisi ad enim sit (15 - 36 - 09)."]
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    //MARK:- App lifeCycle:------
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initData()
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addLocationPhoto" {
            let destVC = segue.destination as! AddLocationPhotoVC
            destVC.selectedID = sender as? Int
        }
     }
    @IBAction func onTapBackUB(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onTapAddPhotoUB(_ sender: Any) {
        self.performSegue(withIdentifier: "addLocationPhoto", sender: selectedID)
    }
    
}
// MARK: -
extension LocationDetailVC : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    // MARK: -  collection View Delegate
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appointLocation.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "locationsCell", for: indexPath) as? LocationCell else{return UICollectionViewCell()}
        cell.cellImg.loadImage(url: RequestInfoFactory.rootURL + appointLocation.photos[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        // splace between two cell horizonatally
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        // splace between two cell vertically
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        // give space top left bottom and right for cells
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120 , height: 120)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "photoControlVC", sender: nil)
    }
    
}


//MARK:-UITableViewDelegate&UITableViewDataSource.
extension LocationDetailVC:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellForRowForOpenList(tableView, cellForRowAt: indexPath)
    }
    
    func cellForRowForOpenList(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationNotesCell", for: indexPath) as! LocationNotesCell
        cell.titleLbl.text  = appointLocation.note
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

extension LocationDetailVC {
    func initData() {
        SVProgressHUD.show()
        let service = AppService()
        service.getAppointmentLocationDetail(selectedID: selectedID!) { (json) in
            let statusCode = json["status"].intValue
            switch statusCode {
            case ResponseStatusCode.success.rawValue:
                self.appointLocation.initWithJSON(obj: json["response"])
                self.tableView.reloadData()
                self.collectionView.reloadData()
                self.handleMap()
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
    
    func handleMap() {
        mapView.setCenter(appointLocation.location, animated: true)
        let pin = MKPlacemark(coordinate: appointLocation.location)
        mapView.addAnnotation(pin)
    }
}
