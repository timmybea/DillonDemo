//
//  ViewController.swift
//  TimBealsDillon
//
//  Created by Tim Beals on 2018-12-04.
//  Copyright © 2018 Roobi Creative. All rights reserved.
//

import UIKit

//MARK: HomeViewController Properties
class HomeViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedIndexPath: IndexPath?
    
    var movieData = [HomeViewControllerViewModel]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
}

//MARK: HomeViewController Methods
extension HomeViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Movie.getNewMovies {
            guard let movies = $0 else { return }
            self.movieData = movies.map { HomeViewControllerViewModel(movie: $0) }
        }
        
        setupNavigationBar()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifiers.movieSelected.string {
            let sender = sender as! [String: Any]
            guard let movie = sender[SenderKeys.movie.rawValue] as? Movie else { return }
            guard let image = sender[SenderKeys.image.rawValue] as? UIImage else { return }
            
            guard let selectedMovieVC = segue.destination as? MovieSelectedViewController else { return }
            selectedMovieVC.movieSelectedViewModel = MovieSelectedViewModel(movie: movie, thumbnail: image)
        }
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.barStyle = .black
        self.title = "New Movies"
    }
    
}

//MARK: HomeViewController CollectionView Methods
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource  {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.reuseId, for: indexPath) as? MovieCollectionViewCell else { return MovieCollectionViewCell() }
        
        cell.configure(with: movieData[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        let movie = movieData[indexPath.item].returnMovie()
        
        guard let imageFromCache = UIImage.imageCache.object(forKey: movie.artKey as AnyObject) else { return }
        let sender: [String: Any] = [SenderKeys.movie.rawValue: movie, SenderKeys.image.rawValue: imageFromCache]

        self.performSegue(withIdentifier: SegueIdentifiers.movieSelected.string, sender: sender)
    }
}

//MARK: HomeViewController Scaling Protocol (Transition)
extension HomeViewController : Scaling {
    
    func scalingImageView(transition: ScaleTransitioningDelegate) -> UIImageView? {
        if let indexPath = selectedIndexPath {
            guard let cell = collectionView.cellForItem(at: indexPath) as? MovieCollectionViewCell else { return nil }
            return cell.cachedImageView
        }
        return nil
    }
    
}
