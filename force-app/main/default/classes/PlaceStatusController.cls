public with sharing class PlaceStatusController {
  @AuraEnabled
  public static PlaceResult findPlace(String accountId) {
    try {
      Account account = [
        SELECT
          Id,
          Google_Place_ID__c,
          Name,
          BillingAddress,
          Last_Google_Place_Update__c,
          Google_Place_Data__c
        FROM Account
        WHERE Id = :accountId
      ];

      PlaceResult result = new PlaceResult();

      GooglePlacesPlace place;
      if (account.Last_Google_Place_Update__c == null || account.Last_Google_Place_Update__c > Datetime.now().addHours(-1)) {
        place = GooglePlacesAPI.getPlaceDetails(account.Google_Place_ID__c);

        account.Last_Google_Place_Update__c = Datetime.now();
        account.Google_Place_Data__c = JSON.serialize(place);
        update account;
      } else {
        place = (GooglePlacesPlace) JSON.deserialize(
          account.Google_Place_Data__c,
          GooglePlacesPlace.class
        );
      }

      result.name = place.displayName.text;
      result.formattedAddress = place.formattedAddress;
      result.openNow = place.regularOpeningHours?.openNow;

      return result;
    } catch (Exception e) {
      System.debug(e.getMessage());
      System.debug(e.getStackTraceString());
      throw new AuraHandledException(e.getMessage());
    }
  }

  @AuraEnabled
  public static void savePlace(String accountId, String placeId) {
    try {
      Account account = new Account(
        Id = accountId,
        Google_Place_ID__c = placeId
      );
      update account;
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }

  public class PlaceResult {
    @AuraEnabled
    public String potentialPlaceId;

    @AuraEnabled
    public String name;

    @AuraEnabled
    public String formattedAddress;

    @AuraEnabled
    public Boolean openNow;
  }
}
