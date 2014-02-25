CLGeocoder *reverseGeocoder = [[CLGeocoder alloc] init];
    [reverseGeocoder reverseGeocodeLocation:location
                          completionHandler:^(NSArray *placemarks, NSError *error) {
         if (error){
             NSLog(@"location: geocode failed with error: %@", error);
             return;
         }
         
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         NSString *countryCode = placemark.ISOcountryCode;
         NSString *countryName = placemark.country;
         NSString *city1 = placemark.subLocality;
         NSString *city2 = placemark.locality;
         NSLog(@"location: country code: %@, country name: %@, city1: %@, city2: %@",
               countryCode, countryName,
               city1, city2);
     }];
