//
//  ViewController.swift
//  IMDB Api Project
//
//  Created by Atıl Samancıoğlu on 29/01/2017.
//  Copyright © 2017 Atıl Samancıoğlu. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var actorsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
    
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchForMovie(title: searchBar.text!)
        searchBar.text = ""
        
    }
    
    func searchForMovie(title: String) {
        
        if let movie = title.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
            
            let url = URL(string: "http://www.omdbapi.com/?t=\(movie)")
            
            let session = URLSession.shared
            
            let task = session.dataTask(with: url!, completionHandler: { (data, response, error) in
                
                if error != nil {
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    
                    if data != nil {
                        
                        do {
                            
                            let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String,String>
                            
                            DispatchQueue.main.async {
                                
                                self.titleLabel.text = jsonResult["Title"]
                                self.ratingLabel.text = jsonResult["imdbRating"]
                                self.directorLabel.text = jsonResult["Director"]
                                self.actorsLabel.text = jsonResult["Actors"]
                                
                                if let imageExists = jsonResult["Poster"] {
                                    
                                    let imageURL = URL(string: imageExists)
                                    
                                    if let imageData = try? Data(contentsOf: imageURL!) {
                                        self.imageView.image = UIImage(data: imageData)
                                    }
                                }
                                
                            }
                            
                        } catch {
                            
                        }
                        
                        
                    }
                    
                }
                
            })
            
            task.resume()
            
        }
        
        
        
    }
    

   }

