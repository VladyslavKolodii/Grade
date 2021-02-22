//
//  LoginVC.swift
//  Grading
//


import UIKit
import GoogleSignIn
import FirebaseUI
import FirebaseAuth
import FirebaseUI

class LoginVC: UIViewController {
    
    //@IBOutlet weak var loginGoogleButton: GIDSignInButton!
    @IBOutlet weak var loginGmailButton: UIButton!
    @IBOutlet weak var loginEmailButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    func configureView() {
        
        // Google sign in setup
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
        
        loginGmailButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        loginGmailButton.layer.shadowColor = UIColor.gray.cgColor
        loginGmailButton.layer.shadowOpacity = 1
        loginGmailButton.layer.shadowRadius = 3
        loginGmailButton.layer.masksToBounds = false
        
        loginEmailButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        loginEmailButton.layer.shadowColor = UIColor.gray.cgColor
        loginEmailButton.layer.shadowOpacity = 1
        loginEmailButton.layer.shadowRadius = 3
        loginEmailButton.layer.masksToBounds = false
    }
    
    func loginSuccess() {
        
        if let controller = OnboardVC.storyboardInstance() {
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    //MARK: - USER INTERACTION
    
    @IBAction func googleSignIn(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
//        loginSuccess()
    }
    
    @IBAction func emailTap(_ sender: Any) {
        let authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        let providers: [FUIAuthProvider] = [FUIEmailAuth()]
        authUI?.providers = providers
        let authVC = authUI!.authViewController()
        self.present(authVC, animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
}

extension LoginVC: GIDSignInDelegate {
    
    // GIDSignInDelegate
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            print("Error: \(error.localizedDescription)")
            return
        }
        
        guard let authentication = user.authentication else { return }
        
        let firstName = user.profile.givenName ?? ""
        let lastName = user.profile.familyName ?? ""
        let email = user.profile.email ?? ""
        var fullName = ""
        if firstName != "" && lastName != "" {
            fullName = "\(firstName) \(lastName)"
        }
        print("\(user.userID ?? "?") - \(fullName) - \(email)")
        print(authentication.accessToken ?? "-")
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential, completion: {(authResult, err) in
            if let err = err {
                print(err.localizedDescription)
                return
            }
            self.loginSuccess()
        })
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
        print("disconnect: \(error.localizedDescription)")
    }
}

extension LoginVC: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        if error == nil {
            print("success")
            loginSuccess()
        } else {
            print(error.debugDescription)
        }
    }
}
