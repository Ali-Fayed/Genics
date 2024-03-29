![Git](https://user-images.githubusercontent.com/72504852/109747727-57270d80-7be0-11eb-8d6a-6a7d7b42faf8.png)

### Hi there, This is ***Genics*** - iOS Native App Written in [Swift 5.3][Swift 5.3] and based on [Github REST API][website] 👋



<img alt="Swift" src="https://img.shields.io/badge/swift-%23FA7343.svg?&style=for-the-badge&logo=swift&logoColor=white"/><img alt="IOS" src="https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=ios&logoColor=white"><img alt="Adobe XD" src="https://img.shields.io/badge/adobe%20xd%20-%23FF26BE.svg?&style=for-the-badge&logo=adobe%20xd&logoColor=white"/><img alt="Canva" src="https://img.shields.io/badge/Canva%20-%2300C4CC.svg?&style=for-the-badge&logo=Canva&logoColor=white"/><img alt="Git" src="https://img.shields.io/badge/git%20-%23F05033.svg?&style=for-the-badge&logo=git&logoColor=white"/><img alt="SQLite" src ="https://img.shields.io/badge/sqlite-%2307405e.svg?&style=for-the-badge&logo=sqlite&logoColor=white"/><img alt="GitHub" src="https://img.shields.io/badge/github%20-%23121011.svg?&style=for-the-badge&logo=github&logoColor=white"/><img alt="App Store" src="https://img.shields.io/badge/App_Store-0D96F6?style=for-the-badge&logo=app-store&logoColor=white" />


## App Features: 

- Explore all github features from Home View
- Explore your full Github profile with all informations and repositories
- Explore and search github users with infinite scrolling.
- Explore  user Profile and Repositories by touch the cells.
- Bookmark any User or Repository  to The Bookmarks View when you longpress the cell or Tap on the Bookmark Button.
- You can delete or Excute Bookmarks Menu or Search History. 
- Swipe to Delete search Records
- Open any User or Repository URL with Longpress menu.
- Explore and search for Public Repositories.
- Explore trending repos form Explore View ( beta )
- Supporting Dark Mode.
- Supporting Haptic Feedback when longpress a cell or important actions.
- Supporting Deep Linking in Settings and many options soon 
- Supporting Arabic Language 100%


## Some App Views Screenshots (There is more and updates every week):

![Untitled design-4](https://user-images.githubusercontent.com/72504852/114256789-13cc7580-99bc-11eb-990b-3c87dc989034.png)
![Untitled design-5](https://user-images.githubusercontent.com/72504852/114256800-2e065380-99bc-11eb-9e96-50dc2c2db8ce.png)
![Untitled design-6](https://user-images.githubusercontent.com/72504852/114256806-3bbbd900-99bc-11eb-9c49-6f188150915f.png)
![Untitled design-8](https://user-images.githubusercontent.com/72504852/114256870-a240f700-99bc-11eb-9221-d3cf4a2d956f.png)

 ## App Technologies:
 
* App Current Version: V1.3
* Supported IOS : IOS 13 or above
* Swift Frameworks : UIKit - SafariServices - AuthenticationWS 
* DataStorage : Sqlite
* Third party Libraries : [Alamofire][Alamofire] - [Kingfisher][Kingfisher] - [Lottie][Lottie] - [IQKeyboard][IQKeyboard] - [SkeletonView][SkeletonView] - [SwiftyJSON][SwiftyJSON] - [JGProgressHUD][JGProgressHUD]
* Pattern : MVVM
* Supported languages in App : English , Arabic ( not all titles translated it will be too soon!! )!

## Video Preview:

[![Githubgenics video preview-2](https://user-images.githubusercontent.com/72504852/109847204-9a709300-7c57-11eb-99cd-6972dfb60e6e.png)][preview]


## Important Notes:
  
- open your terminal type 'cd' and drag the project folder and type this line:
```
pod install
```
- Open Your Github account and  [Create New Github oAuth app][gitapp]
- Copy your "Client ID & Client secret" to
```
 Models > GitAuthentication > Token Manger > GitHubconstants
```
- put the Authorization call back url this line :
```
 githubgenicap://
```
- put the homepage url any valid url
```
 https://alifayed.me
```
- put the Authorization url in your URL Scheme if you want to make your own app
> if you don't do that choose try without github at the login View

- [using app ~~without authentication~~ reduce the API requests limit but with authentication you have 12500 request pre hour][githublink]

- If you face any issues report me

- **For development process client ID&Sercret are avaiable now you can try full version!**
*****************************************


[website]: https://docs.github.com/en/rest/guides
[gitapp]:  https://github.com/settings/applications/new
[githublink]:  https://docs.github.com/en/developers/apps/rate-limits-for-github-apps
[Alamofire]: https://cocoapods.org/pods/Alamofire
[Kingfisher]: https://cocoapods.org/pods/Kingfisher
[Lottie]: https://cocoapods.org/pods/lottie-ios
[IQKeyboard]: https://cocoapods.org/pods/IQKeyboardManagerSwift
[SkeletonView]: https://cocoapods.org/pods/SkeletonView
[SwiftyJSON]: https://cocoapods.org/pods/SwiftyJSON
[JGProgressHUD]: https://cocoapods.org/pods/JGProgressHUD
[Swift 5.3]: https://developer.apple.com/swift/
[preview]: https://www.youtube.com/watch?v=PP7s4XMVC20
[contact]: https://www.linkedin.com/in/ali-fayed-8682aa1a6/
[fb]: https://www.facebook.com/alifayed26/
[tw]: https://www.twitter.com/Aliifayed
[mail]: https://docs.google.com/document/d/1Oo4S9pl0yM4K4uewlOh7poLAmEKLbjnFelIYHxBQL7o/edit?usp=sharing



## Contact Me:

[<img alt="LinkedIn" src="https://img.shields.io/badge/linkedin%20-%230077B5.svg?&style=for-the-badge&logo=linkedin&logoColor=white"/>][contact]  [<img alt="Facebook" src="https://img.shields.io/badge/Facebook%20-%231877F2.svg?&style=for-the-badge&logo=Facebook&logoColor=white"/>][fb]  [<img alt="Twitter" src="https://img.shields.io/badge/Aliifayed%20-%231DA1F2.svg?&style=for-the-badge&logo=Twitter&logoColor=white"/>][tw]  [<img alt="Gmail" src="https://img.shields.io/badge/Gmail-D14836?style=for-the-badge&logo=gmail&logoColor=white" />][mail]
