public with sharing class GooglePlacesAPI {
  public GooglePlacesAPI() {
  }

  public static void getPlaceDetails(String placeId) {
    Http http = new Http();

    HttpRequest request = new HttpRequest();
    request.setEndpoint(
      'https://places.googleapis.com/v1/places/' +
        placeId +
        '?fields=displayName,formattedAddress,regularOpeningHours&key=' +
        GoogleSecretKey.key
    );
    request.setMethod('GET');

    HttpResponse response = http.send(request);
    System.debug(response.getBody());

    Map<String, Object> resMap = (Map<String, Object>) JSON.deserializeUntyped(
      response.getBody()
    );
    Map<String, Object> displayName = (Map<String, Object>) resMap.get(
      'displayName'
    );
    System.debug('Business Name: ' + displayName.get('text'));
  }

  public static void searchPlaceDetails(String searchStr) {
    Http http = new Http();

    HttpRequest request = new HttpRequest();
    request.setEndpoint('https://places.googleapis.com/v1/places:searchText');
    request.setMethod('POST');
    request.setBody('{"textQuery" : "' + searchStr + '"}');
    request.setHeader('Content-Type', 'application/json');
    request.setHeader('X-Goog-Api-Key', GoogleSecretKey.key);
    request.setHeader(
      'X-Goog-FieldMask',
      'places.id,places.displayName,places.formattedAddress,places.regularOpeningHours'
    );

    HttpResponse response = http.send(request);
    System.debug(response.getBody());
  }
}
