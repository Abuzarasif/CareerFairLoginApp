# CareerFairLoginApp

Simple SwiftUI iOS app containing a single login screen.

## Structure

- `CareerFairLoginAppApp.swift`  
  Main app entry point. Launches `LoginView` as the root view.

- `Views/LoginView.swift`  
  Login screen UI based on the provided design:
  - Hard-coded credentials:
    - Email: `21200130@life.hkbu.edu.hk`
    - Password: `Shadman12345`
  - Email and password text fields (pre-filled with the above values)
  - Top mail icon card
  - Small "Forgot Password?" text under the fields
  - Bottom black "Forgot Password?" button that validates the entered credentials and shows a simple alert.

## How to open in Xcode

1. On a Mac, create a new **iOS App** in Xcode using **SwiftUI** and **Swift**.
2. Replace the generated `App` struct file content with `CareerFairLoginAppApp.swift`.
3. Add a new group called `Views` and create a `LoginView.swift` file, then paste in the contents of `Views/LoginView.swift`.
4. Build and run on a simulator or device.


