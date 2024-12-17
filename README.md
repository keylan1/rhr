
# dRHR App: Daily Resting Heart Rate Tracker for Apple Watch

## Video Demo: [URL to be added]

## Description

dRHR App is a watchOS application designed to track and analyze daily resting heart rate (RHR) using Apple Watch Series 9 or later. This app was developed as a final project for CS50, showcasing the integration of health monitoring capabilities with user-friendly interface design.

## Features

- Continuous RHR monitoring using HealthKit
- Daily RHR analysis
- Personalized notifications for significant RHR changes
- SwiftUI-based user interface

## Requirements

- watchOS 11.0+
- Apple Watch Series 9 or later
- Xcode 16

## Project Structure

- `AppCoordinator.swift`: Main view controller, manages the app's primary interface.
- `HealthModel.swift`: Handles all HealthStore interactions including authorization for RHR data retrieval and contains functions for analyzing RHR data and detecting patterns.
- `NotificationManager.swift`: Manages requesting authorization for notificaitons, the creation, and delivery of user notifications.
- `MockHealth.swift`: Mock version of HealthStore for testing purposes, using predetermined values and mocking authorization for health and notifications.
- `RHR_Unit_Tests.swift`: Unit tests for core app functionalities.
- `AppCoordinator_UI.swift`: UI tests to ensure smooth user experience.

## Implementation Details

### SwiftUI
The app's user interface is built entirely with SwiftUI, providing a modern and responsive design. SwiftUI's declarative syntax allowed for rapid development of complex UI elements, particularly useful for creating the interactive charts and settings screens.

### HealthKit Integration
HealthKit is central to the app's functionality, providing secure access to the user's heart rate data. The `HealthModel` class encapsulates all HealthKit-related operations, ensuring clean separation of concerns and easier testing.

### UserNotifications
The app uses the UserNotifications framework to deliver timely alerts about changes in RHR.

### Testing Strategy
A comprehensive testing suite is implemented using XCTest. This includes:
- Unit tests for the RHR analysis algorithms and HealthKit data processing.
- UI tests to verify the app's interface and user interactions.
- Testing on a physical watch and in the simulator.
- Mock objects (e.g., `MockHealthKitManager`) to facilitate testing without relying on actual HealthKit data.


## Design Decisions

### RHR Analysis Algorithm
The custom RHR analysis algorithm (compare function) in `HealthModel.swift` was developed to provide personalized insights. 

### Privacy-First Approach
Given the sensitive nature of health data, the app is designed with a strong focus on user privacy:
- No data storage on the device, only using what HealthStore provides.
- Clear communication about data usage and HealthKit access and notifications.

## Challenges and Learnings

Developing dRHR App presented several challenges:
1. Simulation and testing, pariticularly of local notifications -> requires a physical watch.
2. Simulation of 'ill' notifications with real data.
3. The methods for data collection from HealthStore, depending on the size of the data and the data set.
4. Swift, SwiftUI HealthKit queries, etc.
5. Comparatively little watchOS development in comparison to e.g. React and thus greater complexity.

These challenges led to significant learnings in watchOS app optimization, health data visualization, and user-centric design in the context of personal health applications.

## Conclusion

dRHR App represents the culmination of skills and knowledge acquired through and beyond CS50, applied to create a practical tool for personal health monitoring. It demonstrates the potential of wearable technology in providing actionable health insights and showcases the implementation of various iOS development concepts in a real-world application.

## Acknowledgements


I acknowledge the use of the following AI tools in the development of this project:

- Canva AI (https://www.canva.com): Used for text-to-image generation for the app icon.
- CS50 AI: Used for learning, testing, and assisting with project development.
- ChatGPT (https://chat.openai.com): Used for learning, troubleshooting, and assisting with code development.
- Perplexity AI (https://www.perplexity.ai): Used for learning, troubleshooting, and assisting with code development.

The output from these tools was adapted and modified to fit the project's requirements.

## License


© [Sarah Keller] [2024]. All rights reserved.

This project is licensed for non-commercial use only. You may not use, modify, distribute, or sell this project or any part of it for commercial purposes without explicit written permission from the author.

For inquiries regarding commercial use or collaboration, please contact me at [sarah29.84@gmail.com].
