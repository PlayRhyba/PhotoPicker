# PhotoPicker

The project implements a simple image picker. An image can be selected either from Camera/Photo library or Instagram. The ImagePicker can be extended by adding additional image sources that conform to `ImageSourceProtocol`:
```swift
protocol ImageSourceProtocol {
    
    typealias Completion = (_ imageUrl: URL?,
        _ context: Any?,
        _ error: ICError?) -> Void
    
    var presentingScreen: ScreenNavigatable? { get set }
    
    func pickImage(completion: Completion?)
    
}
```
The InstagramClient uses the Instagram Basic Display API. It can be configured in `Environment`:
```swift
struct Environment {
    
    static let instagramAppId = ""
    static let instagramAppSecret = ""
    static let instagramRedirectUri = ""
    
}
```
The project uses `Alamofire` for networking, `Swinject` as DI framework and `SnapKit` as Auto Layout helper. The most of asynchronious code is wrapped into `Combine` publishers.
