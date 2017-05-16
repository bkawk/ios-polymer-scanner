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
    var urlString: String = ""
    var baseURL: String = ""
    var isProduction = false
    
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
        result.delegate =  self
        self.navigationController?.pushViewController(result, animated: true)
        
    }
    
    func scanPicker(scan: ScannerViewController, didScan: String) {
        if (didScan.isEmpty == false) {
            let resultString = didScan.urlEncode() ?? ""
            redirectToScanResult(result: resultString)
        }
    }
    
    func scanPicker(scan: ScannerViewController, didScanFetchFailed error: NSError) {
        redirectToScanError()
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
        redirectToScanError()
    }
    
    func contactPicker(_: ContactsPicker, didSelectContact contact: Contact)
    {
        let first =  contact.phoneNumbers.first
        let phoneNumber = (first?.phoneNumber ?? "").urlEncode() ?? ""
        let name =  contact.displayName.urlEncode() ?? ""
        redirectToContactPage(name: name, phoneNumber: phoneNumber)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.dismiss(animated: true)
        }
    }
    
    func contactPicker(_: ContactsPicker, didCancel error: NSError)
    {
        print("User canceled the selection");
        dismiss(animated: true)
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
        print("TYPE: ",navigationType)
        let path = request.url?.absoluteString ?? ""
        print("URL Request: ", path)
        if path.contains("squirrel://contacts/") {
            urlString = path.replacingOccurrences(of: "squirrel://contacts/", with: "")
            urlString = urlString.replacingOccurrences(of: "/", with: "")
            // call concontacts
            loadContacts()
            return false
        }
        
        if path.contains("squirrel://scan/send") {
            urlString = path.replacingOccurrences(of: "squirrel://scan/", with: "")
            urlString = urlString.replacingOccurrences(of: "/", with: "")
            // call concontacts
            loadScanView()
            return false
        }
        
        
        return true
    }
}

extension ViewController {
    
    func loadPage() {
        baseURL =  getBaseURL()
        let url = NSURL (string: baseURL)
        loadSpecificURL(urlEncode: url)
    }
    
    func redirectToContactPage(name: String, phoneNumber: String) {
        let urlEncode = "\(baseURL)\(urlString)/\(name)/\(phoneNumber)/"
        let url = NSURL (string: urlEncode)
        print("URL redirect to", urlEncode)
        loadSpecificURL(urlEncode: url)
    }
    
    func redirectContactError() {
        let url = NSURL (string: "\(baseURL)\(urlString)/error")
        loadSpecificURL(urlEncode: url)
    }
    
    // MARK: Scan
    func redirectToScanResult(result: String) {
        let urlEncode = "\(baseURL)\(urlString)/\(result)/"
        let url = NSURL (string: urlEncode)
        print("redirectToScanResult", urlEncode)
        loadSpecificURL(urlEncode: url)
    }
    
    func redirectToScanError() {
        let url = NSURL (string: "\(baseURL)\(urlString)/error")
        loadSpecificURL(urlEncode: url)
    }
    
    private func loadSpecificURL(urlEncode: NSURL?) {
        let requestObj = URLRequest(url: urlEncode! as URL)
        webview.loadRequest(requestObj)
    }
    
    private func getBaseURL() -> String {
        
        if isProduction == false {
            let delegate = UIApplication.shared.delegate as! AppDelegate
            if delegate.webServer.serverURL != nil {
                let baseURLString =  delegate.webServer.serverURL.absoluteString
                if baseURLString.isEmpty {
                    return "https://localhost/" + "#!/"
                }
                
                return baseURLString + "#!/"
            }
            return "https://localhost/" + "#!/"
        }
        
        return "https://bkawk.com/"
    }
}

