class Location {
  final String englishName;
  final String chineseName;
  final int utcOffset;

  Location({this.englishName, this.chineseName, this.utcOffset});

  Location.fromJson(Map<String, dynamic> json):
        englishName = json['englishName'],
        chineseName = json['chineseName'],
        utcOffset = json['utcOffset'];

  Map<String, dynamic> toJson() => {
    'englishName': englishName,
    'chineseName': chineseName,
    'utcOffset': utcOffset,
  };
}