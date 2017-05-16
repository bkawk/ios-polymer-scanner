//
//  ViewController.swift
//  Squirrel
//
//  Created by Duc Nguyen on 5/15/17.
//  Copyright © 2017 Squirrel. All rights reserved.
//

import UIKit
import WebKit
import ContactsUI
import JFContactsPicker

class ViewController: UIViewController {

    @IBOutlet weak var webview: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load static html page
        loadPage()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: ScanPickerDelegate {
    
    func loadScanView() {
        let result =  self.storyboard?.instantiateViewController(withIdentifier: "ScannerViewController") as! ScannerViewController

        self.navigationController?.pushViewController(result, animated: true)
    
    }
    
    func scanPicker(scan: ScannerViewController, didScan: String) {
        scan.dismiss(animated: true)
        if (didScan.isEmpty == false) {
            let resultString = didScan.urlEncode() ?? ""
            redirectToScanResult(result: resultString)
        }
    }
    
    func scanPicker(scan: ScannerViewController, didScanFetchFailed error: NSError) {
        scan.dismiss(animated: true)
        redirectToError()
    }
}

extension ViewController: ContactsPickerDelegate {
    
    func loadContacts() {
        let contactPickerScene = ContactsPicker(delegate: self, multiSelection: false, subtitleCellType: SubtitleCellValue.phoneNumber)
        let navigationController = UINavigationController(rootViewController: contactPickerScene)
        self.present(navigationController, animated: true, completion: nil)
        
    }
    
    //MARK: EPContactsPicker delegates
    func contactPicker(contact: ContactsPicker, didContactFetchFailed error: NSError)
    {
        print("Failed with error \(error.description)")
        contact.dismiss(animated: true)
        redirectToError()
    }
    
    func contactPicker(_: ContactsPicker, didSelectContact contact: Contact)
    {
        print("Contact \(contact.displayName) has been selected")
        print("Contact \(contact.phoneNumbers.first) has been selected")
        let first =  contact.phoneNumbers.first
        let phoneNumber = (first?.phoneNumber ?? "").urlEncode() ?? ""
        let name =  contact.displayName.urlEncode() ?? ""
        redirectToContactPage(name: name, phoneNumber: phoneNumber)
        
        dismiss(animated: true)
    }
    
    func contactPicker(_: ContactsPicker, didCancel error: NSError)
    {
        print("User canceled the selection");
    }
    
    func contactPicker(_: ContactsPicker, didSelectMultipleContacts contacts: [Contact]) {
        print("The following contacts are selected")
        for contact in contacts {
            print("\(contact.displayName)")
        }
    }
}

extension ViewController: UIWebViewDelegate {
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        let path = request.url?.absoluteString ?? ""
        print("URL Request: ", path)
        if path.contains("/contacts/picker") {
            // call concontacts
            loadScanView()
            return false
        }
        
        
        return true
    }
}

extension ViewController {

    func loadPage() {
        let url = NSURL (string: "http://localhost:8080/")
       loadSpecificURL(urlEncode: url)
    }
    
    func redirectToContactPage(name: String, phoneNumber: String) {
        let urlEncode = "http://localhost:8080/something/\(name)/\(phoneNumber)"
        let url = NSURL (string: urlEncode)
        print(urlEncode)
        loadSpecificURL(urlEncode: url)
    }
    
    func redirectToScanResult(result: String) {
        let urlEncode = "http://localhost:8080/scanresult/\(result))"
        let url = NSURL (string: urlEncode)
        print(urlEncode)
        loadSpecificURL(urlEncode: url)
    }

    
    func redirectToError() {
        let url = NSURL (string: "http://localhost:8080/error/something")
        loadSpecificURL(urlEncode: url)
    }
    
    private func loadSpecificURL(urlEncode: NSURL?) {
        let requestObj = URLRequest(url: urlEncode! as URL)
        webview.loadRequest(requestObj)
    }
}

