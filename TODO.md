## TODO

So here is a list of features that **Amazing Weather** requires to become even more awesome!

#### Features
[x] last updated at timestamp (click on last updated triggers instant update)  
[x] related weather info: humidity, wind, temp range, etc  
[x] info about current location selected  
[ ] automatic location detection + notification about location change  
[ ] about window with reference to datasource API (credit according to usage rules)  
[ ] icon (ask Olesya to draw one)  
[x] automatic timer fire after wake up (lid close / lid open)  
[x] automatic timer fire after internet connection is established  
[ ] proper connection errors handling (fair timer reschedule algo?)  
[x] <del>allow to change precision of temp display in tray in settings</del> we don't need that, space in tray is more important  
[x] ability to select between different datasources  
[x] user preferences storage  
[ ] failover algorithm for datasource  
[ ] allow to select locations manually  

#### Refactoring
[ ] Extract getJSON method into `Protocol` out of `BaseWeatherDriver`  
[ ] Make `BaseWeatherDriver` properties `@protected`, remove `@sythisize` from inheritors

#### App store
[x] apply to Apple Developer Program  
[ ] post to app store :ship:
