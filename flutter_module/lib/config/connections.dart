//We can place the API and DB login data here.
//Usually it would be encrypted and called in a more secure manner
//But we will have it in plain text as this is a university project



class Connections{


//Api config
final WhisperApiUrl = "https://api.openai.com";
final WhisperApiKey = "{YOUR API KEY HERE}";

//CHANGE FIELDS AND CONNECTION TO MATCH YOUR OWN
final mainCollection = "SearchForSign";
final nameField = "name";
final tagField = "tags";
final gifField = "gif";
final categoryField ="category";









//Getters
String get getWhisperApiApiKey =>WhisperApiKey;
String get getWhisperApiApiUrl =>WhisperApiUrl;

String get getMainCollection => mainCollection;
String get getNameField => nameField;
String get getTagField => tagField;
String get getGifField => gifField;
String get getCategoryField  => categoryField ;
}