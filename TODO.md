## TODO

So here is a list of features that **Amazing Weather** requires to become even more awesome!

#### Features
[x] last updated at timestamp (click on last updated triggers instant update)  
[x] related weather info: humidity, wind, temp range, etc  
[x] info about current location selected  
[x] automatic location detection + <del>notification about location change</del>  
[x] about window with reference to datasource API (credit according to usage rules)  
[ ] icon (ask Olesya to draw one)  
[x] automatic timer fire after wake up (lid close / lid open)  
[x] automatic timer fire after internet connection is established  
[ ] proper connection errors handling (fair timer reschedule algo?)  
[x] <del>allow to change precision of temp display in tray in settings</del> we don't need that, space in tray is more important  
[x] <del>ability to select between different datasources</del> - only one datasource, no datasource change anymore. See v0.3.  
[x] user preferences storage  
[ ] <del>failover algorithm for datasource</del>  
[ ] allow to select locations manually  
[ ] do not request location data too often (keep last_updated ts)  

#### Refactoring
[x] Extract getJSON method into <del>Protocol</del>`Category` out of `BaseWeatherDriver`  
[ ] <del>Make `BaseWeatherDriver` properties `@protected`, remove `@sythisize` from inheritors</del>  

#### App store
[x] apply to Apple Developer Program  
[ ] post to app store :ship:
