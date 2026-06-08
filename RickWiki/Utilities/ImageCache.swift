import UIKit

final class ImageCache {
    static let shared = ImageCache()

    private let cache: NSCache<NSString, UIImage>

    private init() {
        cache = NSCache<NSString, UIImage>()
        cache.countLimit = 100
        cache.totalCostLimit = 50 * 1024 * 1024
    }

    func image(for url: URL) -> UIImage? {
        cache.object(forKey: url.absoluteString as NSString)
    }

    func insert(_ image: UIImage?, for url: URL) {
        guard let image else { return }
        cache.setObject(image, forKey: url.absoluteString as NSString)
    }

    func remove(for url: URL) {
        cache.removeObject(forKey: url.absoluteString as NSString)
    }

    func clear() {
        cache.removeAllObjects()
    }
}
