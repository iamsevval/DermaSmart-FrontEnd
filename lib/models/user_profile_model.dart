class UserProfileModel {
  String? name;
  String? email;
  String? token;
  int? userId;
  String? skinType;

  String? washFeeling;
  String? poreSize;
  String? shineLevel;
  String? flakiness;
  String? sensitivityResponse;

  String? ageRange;
  String? generalSensitivity;
  List<String> skinConcerns;
  String? unevenSkinTone;
  List<String> eyeConcerns;
  String? acneType;
  String? allergies;
  String? pregnancyStatus;
  List<String> activeIngredients;
  String? sunscreenUsage;
  String? makeupFrequency;
  String? makeupRemoval;
  String? waterIntake;
  String? climate;
  String? budget;

  UserProfileModel({
    this.name,
    this.email,
    this.token,
    this.userId,
    this.skinType,
    this.washFeeling,
    this.poreSize,
    this.shineLevel,
    this.flakiness,
    this.sensitivityResponse,
    this.ageRange,
    this.generalSensitivity,
    this.skinConcerns = const [],
    this.unevenSkinTone,
    this.eyeConcerns = const [],
    this.acneType,
    this.allergies,
    this.pregnancyStatus,
    this.activeIngredients = const [],
    this.sunscreenUsage,
    this.makeupFrequency,
    this.makeupRemoval,
    this.waterIntake,
    this.climate,
    this.budget,
  });

  static String? _capitalize(String? value) {
    if (value == null || value.isEmpty) return null;
    return value[0].toUpperCase() + value.substring(1);
  }

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      name: json['fullName'] ?? json['name'],
      email: json['email'],
      userId: json['userId'],
      skinType: _capitalize(json['skinType']),
      skinConcerns: json['concerns'] != null &&
              json['concerns'].toString().isNotEmpty
          ? json['concerns']
              .toString()
              .split(',')
              .map((e) => e.trim())
              .toList()
          : [],
      washFeeling: json['washFeeling'],
      poreSize: json['poreSize'],
      shineLevel: json['shineLevel'],
      flakiness: json['flakiness'],
      sensitivityResponse: json['sensitivityResponse'],
      ageRange: json['ageRange'],
      generalSensitivity: json['generalSensitivity'],
      unevenSkinTone: json['unevenSkinTone'],
      eyeConcerns: List<String>.from(json['eyeConcerns'] ?? []),
      acneType: json['acneType'],
      allergies: json['allergies'],
      pregnancyStatus: json['pregnancyStatus'],
      activeIngredients:
          List<String>.from(json['activeIngredients'] ?? []),
      sunscreenUsage: json['sunscreenUsage'],
      makeupFrequency: json['makeupFrequency'],
      makeupRemoval: json['makeupRemoval'],
      waterIntake: json['waterIntake'],
      climate: json['climate'],
      budget: json['budget'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'token': token,
      'userId': userId,
      'skinType': skinType,
      'washFeeling': washFeeling,
      'poreSize': poreSize,
      'shineLevel': shineLevel,
      'flakiness': flakiness,
      'sensitivityResponse': sensitivityResponse,
      'ageRange': ageRange,
      'generalSensitivity': generalSensitivity,
      'skinConcerns': skinConcerns,
      'unevenSkinTone': unevenSkinTone,
      'eyeConcerns': eyeConcerns,
      'acneType': acneType,
      'allergies': allergies,
      'pregnancyStatus': pregnancyStatus,
      'activeIngredients': activeIngredients,
      'sunscreenUsage': sunscreenUsage,
      'makeupFrequency': makeupFrequency,
      'makeupRemoval': makeupRemoval,
      'waterIntake': waterIntake,
      'climate': climate,
      'budget': budget,
    };
  }

  String calculateSkinType() {
    if (skinType != null && skinType!.isNotEmpty && skinType != 'Bilinmiyor') {
      return skinType!;
    }
    
    int oilyScore = 0;
    int dryScore = 0;
    int sensitiveScore = 0;

    // sq1
    if (washFeeling == "Gergin ve pul pul") dryScore += 2;
    if (washFeeling == "Sadece T bölgem parlıyor") { oilyScore++; }
    if (washFeeling == "Komple yağlı") oilyScore += 2;

    // sq2
    if (poreSize == "Neredeyse görünmez") dryScore++;
    if (poreSize == "Sadece burun ve çenemde belirgin") { oilyScore++; }
    if (poreSize == "Tüm yüzümde büyük ve belirgin") oilyScore += 2;

    // sq3
    if (shineLevel == "Hayır, genelde mat kalır") dryScore += 2;
    if (shineLevel == "Sadece öğleden sonra hafifçe parlar") { oilyScore++; }
    if (shineLevel == "Evet, çok çabuk ve her yerde parlar") oilyScore += 2;

    // sq4
    if (flakiness == "Evet, sık sık yaşarım") dryScore += 2;
    if (flakiness == "Sadece soğuk havalarda") dryScore++;
    if (flakiness == "Hayır, cildim genelde pürüzsüzdür") oilyScore++;

    // sq5
    if (sensitivityResponse == "Evet, hemen tepki verir ve kızarır") sensitiveScore += 3;
    if (sensitivityResponse == "Bazen içindeki asitlere göre değişir") sensitiveScore += 1;

    if (sensitiveScore >= 3) return "Hassas";
    if (oilyScore > dryScore + 2) return "Yağlı";
    if (dryScore > oilyScore + 2) return "Kuru";
    if (oilyScore > 0 && dryScore > 0) return "Karma";
    return "Normal";
  }
}