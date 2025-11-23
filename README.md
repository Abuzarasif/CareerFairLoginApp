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

## How to Run the Code

### Option 1: Build via GitHub Actions (Recommended for Windows)

The project includes a GitHub Actions workflow that automatically builds the app when you push to GitHub.

1. **View Build Status**: Go to [Actions](https://github.com/Abuzarasif/CareerFairLoginApp/actions) to see build results
2. **Manually Trigger Build**: 
   - Go to Actions tab → "Build iOS App" → "Run workflow"
3. **Push Changes**: Any push to `main` or `master` branch will trigger a build

### Option 2: Run Locally on Mac with Xcode

1. **Install Xcode** from the Mac App Store
2. **Install XcodeGen** (for project.yml):
   ```bash
   brew install xcodegen
   ```
3. **Generate Xcode Project**:
   ```bash
   xcodegen generate
   ```
4. **Open in Xcode**:
   ```bash
   open CareerFairLoginApp.xcodeproj
   ```
5. **Run**: Select a simulator and press `Cmd + R`

### Option 3: Manual Xcode Setup

1. On a Mac, create a new **iOS App** in Xcode using **SwiftUI** and **Swift**.
2. Replace the generated `App` struct file content with `CareerFairLoginAppApp.swift`.
3. Add a new group called `Views` and create a `LoginView.swift` file, then paste in the contents of `Views/LoginView.swift`.
4. Build and run on a simulator or device.


