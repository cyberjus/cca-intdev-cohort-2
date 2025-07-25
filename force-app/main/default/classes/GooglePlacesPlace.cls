public class GooglePlacesPlace {
  // https://developers.google.com/maps/documentation/places/web-service/reference/rest/v1/places#OpeningHours

  public String id;
  public String formattedAddress;
  public OperatingHours regularOpeningHours;
  public List<String> weekdayDescriptions;
  public DateTime nextCloseTime;
  public DateTime nextOpenTime;
  public LocalizedText displayName;

  public class OperatingHours {
    public Boolean openNow;
    public List<Period> periods;
  }

  public class Period {
    public Point open;
    public Point close;
  }

  public class Point {
    public Integer day;
    public Integer hour;
    public Integer minute;
  }

  public class LocalizedText {
    public String text;
    public String languageCode;
  }
}
