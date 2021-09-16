import java.util.regex.Pattern;
import java.util.regex.Matcher;

/**
  * A static class which parses JSONs directly from an input JSON String which
  * allows for faster retrieval of values from keys. The parser uses a mixture
  * of Regex and String operations to retrieve the values.
  * ----------------------------------------------------------------------------
  *
  * Maintained by Lexes Mantiquilla
  */
static class JSONParser {

  /**
    * Returns the Integer value from the JSON from the key passed. Returns the
    * default value if the key was not found.
    */
  static int getInt(String key, int defaultValue, String jsonObject) {
    String pattern = "\"" + key + "\":\\s(\\d+),?";
    Matcher matcher = Pattern.compile(pattern).matcher(jsonObject);
    int value = defaultValue;
    while (matcher.find()) {
      value = Integer.parseInt(matcher.group(1).trim());
    }
    return value;
  }

  /**
    * Returns the String value from the JSON from the key passed. Returns the
    * default value if the key was not found.
    */
  static String getString(String key, String defaultValue, String jsonObject) {
    String jsonKey = "\"" + key + "\": ";
    int keyIndex = jsonObject.indexOf(jsonKey);
    if (keyIndex != -1) {
      int startIndex =  keyIndex + jsonKey.length() + 1;
      String value = null;
      for (int i = startIndex; i < jsonObject.length(); i++) {
        if (jsonObject.charAt(i - 1) != '\\' && jsonObject.charAt(i) == '\"') {
          value = jsonObject.substring(startIndex, i);
          return value;
        }
      }
    }
    return defaultValue;
  }

  /**
    * Returns the Integer array value from the JSON from the key passed. Returns
    * the default value if the key was not found.
    */
  static int[] getIntArray(String key, int[] defaultValue, String jsonObject) {
    String pattern = "\"" + key + "\":\\s\\[(.*?)\\],?";
    Matcher matcher = Pattern.compile(pattern).matcher(jsonObject);
    if (matcher.find()) {
        String[] arrayString = matcher.group(1).split(",\\s");
        int[] arrayInt = new int[arrayString.length];
        for (int i = 0; i < arrayInt.length; i++) {
          arrayInt[i] = Integer.parseInt(arrayString[i].trim());
        }
        return arrayInt;
    }
    return defaultValue;
  }

  /**
    * Returns the Integer array value from the JSON in a String format from the
    * key passed. Returns the default value if the key was not found.
    */
  static String getIntArrayAsString(String key, String defaultValue, String jsonObject) {
    String pattern = "\"" + key + "\":\\s\\[(.*?)\\],?";
    Matcher matcher = Pattern.compile(pattern).matcher(jsonObject);
    if (matcher.find()) {
      return matcher.group(1).trim();
    }
    return defaultValue;
  }

  /**
    * Returns the Boolean value from the JSON from the key passed. Returns
    * the default value if the key was not found.
    */
  static boolean getBoolean(String key, boolean defaultValue, String jsonObject) {
    String pattern = "\"" + key + "\":\\s(\\w{4,5}),?";
    Matcher matcher = Pattern.compile(pattern).matcher(jsonObject);
    if (matcher.find()) {
      return Boolean.parseBoolean(matcher.group(1).trim());
    }
    return defaultValue;
  }
}
