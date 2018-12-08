//
//  ShoppingListViewController.swift
//  ZopNowJsonParsingDemo
//
//  Created by Akash Gurnale on 30/10/18.
//  Copyright © 2018 Akash Gurnale. All rights reserved.
//

import UIKit

class ShoppingListViewController: UIViewController {
    
    
    // MARK: Constants
    
    let baseURL = "https://www.zopnow.com/index.json?medium=APP"
    var shoppingListDataModel: [ShoppingListModel]?
    
    // MARK: IBOutlets
    
    @IBOutlet weak var shoppingList: UITableView!
    
    // MARK: Life Cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fetch shopping list
        fetchShoppingList()
    }
    
    // MARK: Helper methods
    
    private func fetchShoppingList() {
        let session = URLSession.shared
        
        guard let url = URL(string: baseURL) else {
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if let networkError = error {
                // Alert network error
                self.showAlert(with: networkError.localizedDescription)
                print(networkError.localizedDescription)
                
                return
            }
            
            if let data = data {
                do {
                    let hotOffersIndex = 3
                    
                    guard let jsonObject = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? Array<Dictionary<String, Any>>,
                        let data = jsonObject[hotOffersIndex]["data"] as? Dictionary<String, Any>,
                        let products = data["products"] as? Array<Dictionary<String, Any>> else {
                            return
                    }
                    
                    self.shoppingListDataModel = [ShoppingListModel]()
                    
                    for product in products {
                        
                        guard let id = product["id"] as? String,
                            let name = product["name"] as? String,
                            let fullName = product["full_name"] as? String,
                            let brand = product["brand"] as? Dictionary<String, Any>,
                            let brandId = brand["id"] as? String,
                            let brandName = brand["name"] as? String,
                            let category = product["category"] as? Dictionary<String, Any>,
                            let productCount = category["products_count"] as? String,
                            let imageUrl = category["image_url"] as? String else {
                                return
                        }
                        
                        guard let variants = product["variants"] as? Array<Dictionary<String, Any>> else {
                            return
                        }
                        
                        var variantList = Array<ShoppingListVariants>()
                        
                        for variant in variants {
                            
                            guard let variantId = variant["id"] as? String,
                                let nameQuantity = variant["name"] as? String,
                                let fullName = variant["full_name"] as? String,
                                let status = variant["status"] as? String,
                                let currency = variant["currency"] as? String,
                                let mrp = variant["mrp"] as? Int,
                                let discount = variant["discount"] as? Double else {
                                    return
                            }
                            
                            
                            variantList.append(
                                ShoppingListVariants(
                                    variantId: variantId,
                                    nameQuantity: nameQuantity,
                                    variantFullName: fullName,
                                    status: status,
                                    currency: currency,
                                    mrp: mrp,
                                    discount: discount
                                )
                            )
                        }
                        
                        self.shoppingListDataModel?.append(
                            ShoppingListModel(
                                productId: id,
                                productName: name,
                                productFullName: fullName,
                                brandName: brandName,
                                brandId: brandId,
                                productCount: productCount,
                                imageUrl: imageUrl,
                                variants: variantList
                            )
                        )
                    }
                    
                    if let _ = self.shoppingListDataModel {
                        DispatchQueue.main.async {
                            self.shoppingList.delegate = self
                            self.shoppingList.dataSource = self
                            self.shoppingList.reloadData()
                        }
                    }
                    
                } catch let jsonError {
                    //Alert json parsing
                    self.showAlert(with: jsonError.localizedDescription)
                    print(jsonError.localizedDescription)
                }
            }
        }
        
        task.resume()
    }
    
    // Error alert
    func showAlert(with message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        
        present(alert, animated: true)
    }
    
    // Fetch Image
    func fetchImage(url: String, completion: @escaping (UIImage) -> Void) {
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: URL(string: url)!)
            DispatchQueue.main.async {
                let image = data != nil ? UIImage(data: data!) : UIImage(named: "Grocery")
                completion(image!)
            }
        }
    }
    
}


// MARK: Delegate

extension ShoppingListViewController: UITableViewDelegate {
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath) {
        
        if let shoppingListDataModel = shoppingListDataModel {
            let shoppingItemDetailsViewController: ShoppingItemDetailsViewController = self.storyboard?.instantiateViewController(withIdentifier: "ShoppingItemDetailsViewController") as! ShoppingItemDetailsViewController
            shoppingItemDetailsViewController.shoppingItemDetailsModel = shoppingListDataModel[indexPath.row]
            
            navigationController?.pushViewController(shoppingItemDetailsViewController, animated: true)
        }
        
    }
    
}

// MARK: Datasource

extension ShoppingListViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
        
        guard let shoppingList = shoppingListDataModel else {
            return 0
        }
        
        return shoppingList.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ShoppingItemCell = tableView.dequeueReusableCell(withIdentifier: "ShoppingItemCell") as! ShoppingItemCell
        
        if let shoppingListDataModel = shoppingListDataModel {
            let item = shoppingListDataModel[indexPath.row]
            cell.productName.text = item.productName
            
            let itemUrl = item.imageUrl
            let fullUrl = "https:" + itemUrl
            
            fetchImage(url: fullUrl) { (image) in
                cell.shoppingItemImage.image = image
            }
        }
        
        return cell
    }
    
}

