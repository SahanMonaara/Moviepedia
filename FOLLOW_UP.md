### Q) What libraries did you choose to use? (if any) What was the reason why?
    http: -> Used for call API requests
    provider: ^6.0.3 -> Used for State Management 
    shimmer: ^2.0.0 -> Used for Shimmer Placeholder
    flutter_spinkit: ^5.0.0 -> Used to custom loading widget
    shared_preferences: ^2.0.15 -> Used for local storage
    google_fonts: ^3.0.1 -> Used for fonts styling
    gradient_borders: ^0.2.0 -> Used for gradient border on searchbar and details page border
    cached_network_image: ^3.2.3 -> Used for network image loading

### Q) What's the command to start the application locally?
## Run Locally

Clone the project

```bash
  git clone https://github.com/SahanMonaara/Moviepedia.git
```

Install dependencies

```bash
  flutter clean
  
  flutter pub get
```

Start the application

```bash
  flutter run
```

# General:

### Q) Which parts did you spend the most time with? What did you find most difficult?
    I spent more time on developing the home page since it has so many functionalities. 
    The was a little bit difficult to develop the search function. 

### Q) How did you find the test overall? Did you have any issues or have difficulties completing?If you have any suggestions on how we can improve the test, we'd love to hear them.
    Overall, this test was a perfect technical task to get to know the developer's capabilities. 
    I have added the error message "Something went wrong" for API down scenario and for no internet connection scenario. 
    As well as when there is no search result for the searched keyword, I am displaying the empty message "There are no results for <searched keyword>".
    I really enjoyed implementing this project. 