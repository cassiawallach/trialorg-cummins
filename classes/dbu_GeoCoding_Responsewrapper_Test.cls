@isTest
public class dbu_GeoCoding_Responsewrapper_Test {

 static testMethod void unitTest() {
        String fullJson = '{'+
'   "plus_code" : {'+
'      "compound_code" : "4PJ5+2RV Lodi, CA, USA",'+
'      "global_code" : "84CW4PJ5+2RV"'+
'   },'+
'   "results" : ['+
'      {'+
'         "address_components" : ['+
'            {'+
'               "long_name" : "1400",'+
'               "short_name" : "1400",'+
'               "types" : [ "street_number" ]'+
'            },'+
'            {'+
'               "long_name" : "West Lodi Avenue",'+
'               "short_name" : "W Lodi Ave",'+
'               "types" : [ "route" ]'+
'            },'+
'            {'+
'               "long_name" : "Lodi",'+
'               "short_name" : "Lodi",'+
'               "types" : [ "locality", "political" ]'+
'            },'+
'            {'+
'               "long_name" : "San Joaquin County",'+
'               "short_name" : "San Joaquin County",'+
'               "types" : [ "administrative_area_level_2", "political" ]'+
'            },'+
'            {'+
'               "long_name" : "California",'+
'               "short_name" : "CA",'+
'               "types" : [ "administrative_area_level_1", "political" ]'+
'            },'+
'            {'+
'               "long_name" : "United States",'+
'               "short_name" : "US",'+
'               "types" : [ "country", "political" ]'+
'            },'+
'            {'+
'               "long_name" : "95242",'+
'               "short_name" : "95242",'+
'               "types" : [ "postal_code" ]'+
'            },'+
'            {'+
'               "long_name" : "3015",'+
'               "short_name" : "3015",'+
'               "types" : [ "postal_code_suffix" ]'+
'            }'+
'         ],'+
'         "formatted_address" : "1400 W Lodi Ave, Lodi, CA 95242, USA",'+
'         "geometry" : {'+
'            "bounds" : {'+
'               "northeast" : {'+
'                  "lat" : 38.1298009,'+
'                  "lng" : -121.2903291'+
'               },'+
'               "southwest" : {'+
'                  "lat" : 38.1296511,'+
'                  "lng" : -121.2905562'+
'               }'+
'            },'+
'            "location" : {'+
'               "lat" : 38.1297302,'+
'               "lng" : -121.2904194'+
'            },'+
'            "location_type" : "ROOFTOP",'+
'            "viewport" : {'+
'               "northeast" : {'+
'                  "lat" : 38.1310749802915,'+
'                  "lng" : -121.2890936697085'+
'               },'+
'               "southwest" : {'+
'                  "lat" : 38.1283770197085,'+
'                  "lng" : -121.2917916302915'+
'               }'+
'            }'+
'         },'+
'         "place_id" : "ChIJ8xHmOmqgmoARV12jUppgeW8",'+
'         "types" : [ "premise" ]'+
'      },'+
'      {'+
'         "address_components" : ['+
'            {'+
'               "long_name" : "1341",'+
'               "short_name" : "1341",'+
'               "types" : [ "street_number" ]'+
'            },'+
'            {'+
'               "long_name" : "West Lodi Avenue",'+
'               "short_name" : "W Lodi Ave",'+
'               "types" : [ "route" ]'+
'            },'+
'            {'+
'               "long_name" : "Lodi",'+
'               "short_name" : "Lodi",'+
'               "types" : [ "locality", "political" ]'+
'            },'+
'            {'+
'               "long_name" : "San Joaquin County",'+
'               "short_name" : "San Joaquin County",'+
'               "types" : [ "administrative_area_level_2", "political" ]'+
'            },'+
'            {'+
'               "long_name" : "California",'+
'               "short_name" : "CA",'+
'               "types" : [ "administrative_area_level_1", "political" ]'+
'            },'+
'            {'+
'               "long_name" : "United States",'+
'               "short_name" : "US",'+
'               "types" : [ "country", "political" ]'+
'            },'+
'            {'+
'               "long_name" : "95242",'+
'               "short_name" : "95242",'+
'               "types" : [ "postal_code" ]'+
'            },'+
'            {'+
'               "long_name" : "3036",'+
'               "short_name" : "3036",'+
'               "types" : [ "postal_code_suffix" ]'+
'            }'+
'         ],'+
'         "formatted_address" : "1341 W Lodi Ave, Lodi, CA 95242, USA",'+
'         "geometry" : {'+
'            "location" : {'+
'               "lat" : 38.1302607,'+
'               "lng" : -121.2899072'+
'            },'+
'            "location_type" : "ROOFTOP",'+
'            "viewport" : {'+
'               "northeast" : {'+
'                  "lat" : 38.1316096802915,'+
'                  "lng" : -121.2885582197085'+
'               },'+
'               "southwest" : {'+
'                  "lat" : 38.1289117197085,'+
'                  "lng" : -121.2912561802915'+
'               }'+
'            }'+
'         },'+
'         "place_id" : "ChIJCQRDO5GhmoARXkpp_uiNr5o",'+
'         "plus_code" : {'+
'            "compound_code" : "4PJ6+42 Lodi, CA, USA",'+
'            "global_code" : "84CW4PJ6+42"'+
'         },'+
'         "types" : [ "street_address" ]'+
'      },'+
'      {'+
'         "address_components" : ['+
'            {'+
'               "long_name" : "1401-1421",'+
'               "short_name" : "1401-1421",'+
'               "types" : [ "street_number" ]'+
'            },'+
'            {'+
'               "long_name" : "West Lodi Avenue",'+
'               "short_name" : "W Lodi Ave",'+
'               "types" : [ "route" ]'+
'            },'+
'            {'+
'               "long_name" : "Lodi",'+
'               "short_name" : "Lodi",'+
'               "types" : [ "locality", "political" ]'+
'            },'+
'            {'+
'               "long_name" : "San Joaquin County",'+
'               "short_name" : "San Joaquin County",'+
'               "types" : [ "administrative_area_level_2", "political" ]'+
'            },'+
'            {'+
'               "long_name" : "California",'+
'               "short_name" : "CA",'+
'               "types" : [ "administrative_area_level_1", "political" ]'+
'            },'+
'            {'+
'               "long_name" : "United States",'+
'               "short_name" : "US",'+
'               "types" : [ "country", "political" ]'+
'            },'+
'            {'+
'               "long_name" : "95242",'+
'               "short_name" : "95242",'+
'               "types" : [ "postal_code" ]'+
'            }'+
'         ],'+
'         "formatted_address" : "1401-1421 W Lodi Ave, Lodi, CA 95242, USA",'+
'         "geometry" : {'+
'            "bounds" : {'+
'               "northeast" : {'+
'                  "lat" : 38.130026,'+
'                  "lng" : -121.2902646'+
'               },'+
'               "southwest" : {'+
'                  "lat" : 38.1300245,'+
'                  "lng" : -121.2906329'+
'               }'+
'            },'+
'            "location" : {'+
'               "lat" : 38.1300253,'+
'               "lng" : -121.2904487'+
'            },'+
'            "location_type" : "GEOMETRIC_CENTER",'+
'            "viewport" : {'+
'               "northeast" : {'+
'                  "lat" : 38.1313742302915,'+
'                  "lng" : -121.2890997697085'+
'               },'+
'               "southwest" : {'+
'                  "lat" : 38.1286762697085,'+
'                  "lng" : -121.2917977302915'+
'               }'+
'            }'+
'         },'+
'         "place_id" : "ChIJiUHePGqgmoARTOCLHHpSZwQ",'+
'         "types" : [ "route" ]'+
'      },'+
'      {'+
'         "address_components" : ['+
'            {'+
'               "long_name" : "4PJ5+2R",'+
'               "short_name" : "4PJ5+2R",'+
'               "types" : [ "plus_code" ]'+
'            },'+
'            {'+
'               "long_name" : "Lodi",'+
'               "short_name" : "Lodi",'+
'               "types" : [ "locality", "political" ]'+
'            },'+
'            {'+
'               "long_name" : "San Joaquin County",'+
'               "short_name" : "San Joaquin County",'+
'               "types" : [ "administrative_area_level_2", "political" ]'+
'            },'+
'            {'+
'               "long_name" : "California",'+
'               "short_name" : "CA",'+
'               "types" : [ "administrative_area_level_1", "political" ]'+
'            },'+
'            {'+
'               "long_name" : "United States",'+
'               "short_name" : "US",'+
'               "types" : [ "country", "political" ]'+
'            }'+
'         ],'+
'         "formatted_address" : "4PJ5+2R Lodi, CA, USA",'+
'         "geometry" : {'+
'            "bounds" : {'+
'               "northeast" : {'+
'                  "lat" : 38.130125,'+
'                  "lng" : -121.290375'+
'               },'+
'               "southwest" : {'+
'                  "lat" : 38.13,'+
'                  "lng" : -121.2905'+
'               }'+
'            },'+
'            "location" : {'+
'               "lat" : 38.130123,'+
'               "lng" : -121.290443'+
'            },'+
'            "location_type" : "GEOMETRIC_CENTER",'+
'            "viewport" : {'+
'               "northeast" : {'+
'                  "lat" : 38.1314114802915,'+
'                  "lng" : -121.2890885197085'+
'               },'+
'               "southwest" : {'+
'                  "lat" : 38.1287135197085,'+
'                  "lng" : -121.2917864802915'+
'               }'+
'            }'+
'         },'+
'         "place_id" : "GhIJjLrW3qcQQ0ARipY8npZSXsA",'+
'         "plus_code" : {'+
'            "compound_code" : "4PJ5+2R Lodi, CA, USA",'+
'            "global_code" : "84CW4PJ5+2R"'+
'         },'+
'         "types" : [ "plus_code" ]'+
'      },'+
'      {'+
'         "address_components" : ['+
'            {'+
'               "long_name" : "Lodi",'+
'               "short_name" : "Lodi",'+
'               "types" : [ "locality", "political" ]'+
'            },'+
'            {'+
'               "long_name" : "San Joaquin County",'+
'               "short_name" : "San Joaquin County",'+
'               "types" : [ "administrative_area_level_2", "political" ]'+
'            },'+
'            {'+
'               "long_name" : "California",'+
'               "short_name" : "CA",'+
'               "types" : [ "administrative_area_level_1", "political" ]'+
'            },'+
'            {'+
'               "long_name" : "United States",'+
'               "short_name" : "US",'+
'               "types" : [ "country", "political" ]'+
'            }'+
'         ],'+
'         "formatted_address" : "Lodi, CA, USA",'+
'         "geometry" : {'+
'            "bounds" : {'+
'               "northeast" : {'+
'                  "lat" : 38.154942,'+
'                  "lng" : -121.2413109'+
'               },'+
'               "southwest" : {'+
'                  "lat" : 38.082454,'+
'                  "lng" : -121.40527'+
'               }'+
'            },'+
'            "location" : {'+
'               "lat" : 38.1341477,'+
'               "lng" : -121.2722194'+
'            },'+
'            "location_type" : "APPROXIMATE",'+
'            "viewport" : {'+
'               "northeast" : {'+
'                  "lat" : 38.154942,'+
'                  "lng" : -121.2413109'+
'               },'+
'               "southwest" : {'+
'                  "lat" : 38.082454,'+
'                  "lng" : -121.40527'+
'               }'+
'            }'+
'         },'+
'         "place_id" : "ChIJNTjFJtmhmoARRuhsu5jkrY4",'+
'         "types" : [ "locality", "political" ]'+
'      },'+
'      {'+
'         "address_components" : ['+
'            {'+
'               "long_name" : "95242",'+
'               "short_name" : "95242",'+
'               "types" : [ "postal_code" ]'+
'            },'+
'            {'+
'               "long_name" : "Lodi",'+
'               "short_name" : "Lodi",'+
'               "types" : [ "locality", "political" ]'+
'            },'+
'            {'+
'               "long_name" : "San Joaquin County",'+
'               "short_name" : "San Joaquin County",'+
'               "types" : [ "administrative_area_level_2", "political" ]'+
'            },'+
'            {'+
'               "long_name" : "California",'+
'               "short_name" : "CA",'+
'               "types" : [ "administrative_area_level_1", "political" ]'+
'            },'+
'            {'+
'               "long_name" : "United States",'+
'               "short_name" : "US",'+
'               "types" : [ "country", "political" ]'+
'            }'+
'         ],'+
'         "formatted_address" : "Lodi, CA 95242, USA",'+
'         "geometry" : {'+
'            "bounds" : {'+
'               "northeast" : {'+
'                  "lat" : 38.226152,'+
'                  "lng" : -121.274975'+
'               },'+
'               "southwest" : {'+
'                  "lat" : 38.0574559,'+
'                  "lng" : -121.586172'+
'               }'+
'            },'+
'            "location" : {'+
'               "lat" : 38.1304288,'+
'               "lng" : -121.422761'+
'            },'+
'            "location_type" : "APPROXIMATE",'+
'            "viewport" : {'+
'               "northeast" : {'+
'                  "lat" : 38.226152,'+
'                  "lng" : -121.274975'+
'               },'+
'               "southwest" : {'+
'                  "lat" : 38.0574559,'+
'                  "lng" : -121.586172'+
'               }'+
'            }'+
'         },'+
'         "place_id" : "ChIJY0jA6AimmoARUcQzt6-H5BQ",'+
'         "types" : [ "postal_code" ]'+
'      },'+
'      {'+
'         "address_components" : ['+
'            {'+
'               "long_name" : "San Joaquin County",'+
'               "short_name" : "San Joaquin County",'+
'               "types" : [ "administrative_area_level_2", "political" ]'+
'            },'+
'            {'+
'               "long_name" : "California",'+
'               "short_name" : "CA",'+
'               "types" : [ "administrative_area_level_1", "political" ]'+
'            },'+
'            {'+
'               "long_name" : "United States",'+
'               "short_name" : "US",'+
'               "types" : [ "country", "political" ]'+
'            }'+
'         ],'+
'         "formatted_address" : "San Joaquin County, CA, USA",'+
'         "geometry" : {'+
'            "bounds" : {'+
'               "northeast" : {'+
'                  "lat" : 38.2994709,'+
'                  "lng" : -120.920665'+
'               },'+
'               "southwest" : {'+
'                  "lat" : 37.4817831,'+
'                  "lng" : -121.585079'+
'               }'+
'            },'+
'            "location" : {'+
'               "lat" : 37.9175935,'+
'               "lng" : -121.1710389'+
'            },'+
'            "location_type" : "APPROXIMATE",'+
'            "viewport" : {'+
'               "northeast" : {'+
'                  "lat" : 38.2994709,'+
'                  "lng" : -120.920665'+
'               },'+
'               "southwest" : {'+
'                  "lat" : 37.4817831,'+
'                  "lng" : -121.585079'+
'               }'+
'            }'+
'         },'+
'         "place_id" : "ChIJ31ZZ5gY-kIAR0dtYpsEqJEc",'+
'         "types" : [ "administrative_area_level_2", "political" ]'+
'      },'+
'      {'+
'         "address_components" : ['+
'            {'+
'               "long_name" : "California",'+
'               "short_name" : "CA",'+
'               "types" : [ "administrative_area_level_1", "political" ]'+
'            },'+
'            {'+
'               "long_name" : "United States",'+
'               "short_name" : "US",'+
'               "types" : [ "country", "political" ]'+
'            }'+
'         ],'+
'         "formatted_address" : "California, USA",'+
'         "geometry" : {'+
'            "bounds" : {'+
'               "northeast" : {'+
'                  "lat" : 42.0095169,'+
'                  "lng" : -114.131211'+
'               },'+
'               "southwest" : {'+
'                  "lat" : 32.528832,'+
'                  "lng" : -124.482003'+
'               }'+
'            },'+
'            "location" : {'+
'               "lat" : 36.778261,'+
'               "lng" : -119.4179324'+
'            },'+
'            "location_type" : "APPROXIMATE",'+
'            "viewport" : {'+
'               "northeast" : {'+
'                  "lat" : 42.0095169,'+
'                  "lng" : -114.131211'+
'               },'+
'               "southwest" : {'+
'                  "lat" : 32.528832,'+
'                  "lng" : -124.482003'+
'               }'+
'            }'+
'         },'+
'         "place_id" : "ChIJPV4oX_65j4ARVW8IJ6IJUYs",'+
'         "types" : [ "administrative_area_level_1", "political" ]'+
'      },'+
'      {'+
'         "address_components" : ['+
'            {'+
'               "long_name" : "United States",'+
'               "short_name" : "US",'+
'               "types" : [ "country", "political" ]'+
'            }'+
'         ],'+
'         "formatted_address" : "United States",'+
'         "geometry" : {'+
'            "bounds" : {'+
'               "northeast" : {'+
'                  "lat" : 71.5388001,'+
'                  "lng" : -66.885417'+
'               },'+
'               "southwest" : {'+
'                  "lat" : 18.7763,'+
'                  "lng" : 170.5957'+
'               }'+
'            },'+
'            "location" : {'+
'               "lat" : 37.09024,'+
'               "lng" : -95.712891'+
'            },'+
'            "location_type" : "APPROXIMATE",'+
'            "viewport" : {'+
'               "northeast" : {'+
'                  "lat" : 71.5388001,'+
'                  "lng" : -66.885417'+
'               },'+
'               "southwest" : {'+
'                  "lat" : 18.7763,'+
'                  "lng" : 170.5957'+
'               }'+
'            }'+
'         },'+
'         "place_id" : "ChIJCzYy5IS16lQRQrfeQ5K5Oxw",'+
'         "types" : [ "country", "political" ]'+
'      }'+
'   ],'+
'   "status" : "OK"'+
'}';
		//dbu_GoogleMapApi_Responsewrapper.parse(fullJson);
        dbu_GeoCoding_Responsewrapper.parse(fullJson);
    }
    
}