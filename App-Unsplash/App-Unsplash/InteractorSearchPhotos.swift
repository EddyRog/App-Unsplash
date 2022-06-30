//
// InteractorSearchPhotos.swift
// App-Unsplash
// Created in 2022
// Swift 5.0


import Foundation

protocol InteractorSearchPhotos {
    func fetchPhotos(with request: String, completionFetcher: @escaping (Response) -> Void )
}
class InteractorSearchPhotosImpl: InteractorSearchPhotos {
    var fetcher: FetcherSearchPhotos?

    func fetchPhotos(with request: String, completionFetcher: @escaping (Response) -> Void) {
        // fetcher.fetch
        fetcher?.fetch(with: request, completion: { (photos: [Photo]) in
			var responseToReturn = Response(value: [])
            // parse array fo photos
            photos.forEach { photo in
                let picture = photo.picture
                let description = photo.description
                // hydrate data with response
                let photoHydrated = Photo(description: description, picture: picture)
                // Add it to response objc
                responseToReturn.value.append(photoHydrated)
            }

            // send back response to presenter
            completionFetcher(responseToReturn)
        })

    }
}
