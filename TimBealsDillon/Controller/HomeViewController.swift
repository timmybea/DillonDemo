//
//  ViewController.swift
//  TimBealsDillon
//
//  Created by Tim Beals on 2018-12-04.
//  Copyright © 2018 Roobi Creative. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedIndexPath: IndexPath?
    
    var movieData = [Movie]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        APIService.fetchData(with: .topTitles) { (data, error) in
        
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }

            if let unwrappedData = data {
                do {
                    self.movieData = try JSONDecoder().decode([Movie].self, from: unwrappedData)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }

        setupNavigationBar()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "MovieSelected" {
            let sender = sender as! [String: Any]
            guard let movie = sender["movie"] as? Movie else { return }
            guard let image = sender["image"] as? UIImage else { return }
            
            guard let selectedMovieVC = segue.destination as? MovieSelectedViewController else {
                print("no vc!")
                return
            }
            
            selectedMovieVC.backgroundImage = image
            selectedMovieVC.movie = movie
        }
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.barStyle = .black
        self.title = "New Movies"
    }

}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.reuseId, for: indexPath) as? MovieCollectionViewCell else { fatalError("Could not create cell for collection view") }
        
        cell.configure(with: movieData[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        
        let movie = movieData[indexPath.item]
        guard  let imageFromCache = UIImage.imageCache.object(forKey: movie.artKey as AnyObject) as? UIImage else { return }
        let sender: [String: Any] = ["movie": movie, "image": imageFromCache]
        self.performSegue(withIdentifier: "MovieSelected", sender: sender)
    }
}

//MARK: Transitioning

extension HomeViewController : Scaling {
    
    func scalingImageView(transition: ScaleTransitioningDelegate) -> UIImageView? {
        if let indexPath = selectedIndexPath {
            guard let cell = collectionView.cellForItem(at: indexPath) as? MovieCollectionViewCell else { return nil }
            return cell.cachedImageView as? UIImageView
        }
        return nil
    }
    
}
