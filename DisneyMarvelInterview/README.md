#  Disney Marvel Interview Assignment
## Christopher Truman 06/17/2022

### Instructions
Insert your API Key and Private Key in the *Credentials.swift* file in order to successfully fetch data from the Marvel Developer API.

### Overview
This example application does the following
- Connects to Marvel's Developer API
- Displays a comic issue's details when provided a comic ID
- Includes some UI/Unit Tests
- Additionally, it allows a user to add multiple comics to view (assuming they already know the ID of the issue)

### Explanation
I chose not to use any external libraries to demonstrate my understanind of basic iOS frameworks.  I easily could have replaced a lot of the networking code with something like Alamofire and could have used SnapKit/Masonry/Cartography to make my auto layout code much more succinct. I also could have implemented everything in SwiftUI and Combine, but wanted to leverage my experience with UIKit, and understanding of GCD and closures, while also using a little Combine/Publisher code in my *NetworkClient* class. I have also localized my text to demonstrate my focus on ensuring my work will be easily internationalizable and accesssible to all users. I have implemented a super basic MVVM pattern with *ComicTableViewModel* and opted to create a feature to add additional Comic IDs to demonstrate a more complicated ViewModel interaction.  Given more time, I would further abstract out functionality like image loading, display logic, etc. into ViewModels or service classes with mocks (using a library like Mockingbird) to ensure better test coverage.  I would also take some time to improve the design with better use of custom fonts, animations, layout, iPad Support etc. but unfortunately I am a horrible designer :P Thanks for considering me for this position and I really appreciate your time.

