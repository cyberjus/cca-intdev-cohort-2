public with sharing class GooglePlacesAPI {
  public GooglePlacesAPI() {
  }

  public static GooglePlacesPlace getPlaceDetails(String placeId) {
    String res = sendRequest(
      '/places/' + placeId,
      'GET',
      'displayName,formattedAddress,regularOpeningHours',
      null
    );

    System.debug(res);

    GooglePlacesPlace place = (GooglePlacesPlace) JSON.deserialize(
      res,
      GooglePlacesPlace.class
    );

    System.debug('Place: ' + place);

    System.debug('+++++ Business Name: ' + place.displayName.text);

    return place;
  }

  public static GooglePlacesPlace searchPlaceDetails(String searchStr) {
    GooglePlacesPlaceSearch placeSearch = new GooglePlacesPlaceSearch();
    placeSearch.textQuery = searchStr;

    String res = sendRequest(
      '/places:searchText',
      'POST',
      'places.id,places.displayName,places.formattedAddress,places.regularOpeningHours',
      placeSearch
    );

    System.debug(res);

    PlaceSearchResponse searchRes = (PlaceSearchResponse) JSON.deserialize(
      res,
      PlaceSearchResponse.class
    );
    if (searchRes.places.isEmpty()) {
      return null;
    } else {
      return searchRes.places.get(0);
    }
  }

  private static String sendRequest(
    String endpoint,
    String method,
    String fields,
    Object body
  ) {
    try {
      Http http = new Http();

      HttpRequest request = new HttpRequest();
      request.setEndpoint('callout:GooglePlaces' + endpoint);
      request.setMethod(method);

      request.setHeader('X-Goog-FieldMask', fields);

      if (body != null)
        request.setBody(JSON.serialize(body));

      HttpResponse response = http.send(request);

      if (response.getStatusCode() != 200) {
        // Handle Error
        GooglePlacesError error = (GooglePlacesError) JSON.deserialize(
          response.getBody(),
          GooglePlacesError.class
        );

        throw new GooglePlacesException(error.error.message);
      } else {
        return response.getBody();
      }
    } catch (Exception e) {
      System.debug(e.getMessage());
      System.debug(e.getStackTraceString());
      throw new GooglePlacesException('Google Places Error: ' + e.getMessage());
    }
  }

  public class PlaceSearchResponse {
    public List<GooglePlacesPlace> places;
  }

  public class GooglePlacesError {
    public APIError error;
  }

  public class APIError {
    public String code;
    public String message;
  }

  public class GooglePlacesException extends Exception {
  }
}
