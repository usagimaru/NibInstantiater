# NibInstantiater

A collection of extensions useful for initialization from Nib and Storyboard.

- NibInstantiatable.swift
- StoryboardInstantiatable.swift

## Usage

```swift
// Class definition.
class MyCustomView: NSView, NibInstantiatable {
	//...
}

// File’s Owner: nil on the nib file.
let unownedCustomView = MyCustomView.loadUnownedNib()

// File’s Owner: `MyCustomView` on the nib file.
let ownedCustomView = MyCustomView(frame: .zero)
ownedCustomView.loadOwnedNib()
```


## License

See [LICENSE](./LICENSE) for details.
