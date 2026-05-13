class UserProfileModel {
  String? name;
  String? email;
  String? token;
  int? userId;
  String? skinType;

  // Mini quiz details
  String? washFeeling;
  String? poreSize;
  String? shineLevel;
  String? flakiness;
  String? sensitivityResponse;

  // Main survey
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

  // Backend'den gelen veriyi modele çeviren kritik metod (SORUN 2 ve 3 ÇÖZÜMÜ İÇİN)
  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      // Backend'den 'fullName' veya 'name' olarak gelebilir, ikisini de kontrol ediyoruz
      name: json['fullName'] ?? json['name'],
      email: json['email'],
      userId: json['userId'],
      skinType: json['skinType'],
      skinConcerns: json['concerns'] != null &&
              json['concerns'].toString().isNotEmpty
          ? json['concerns'].toString().split(',').map((e) => e.trim()).toList()
          : [],
      washFeeling: json['washFeeling'],
      poreSize: json['poreSize'],
      shineLevel: json['shineLevel'],
      flakiness: json['flakiness'],
      sensitivityResponse: json['sensitivityResponse'],
      ageRange: json['ageRange'],
      generalSensitivity: json['generalSensitivity'],
      // Liste verilerini güvenli bir şekilde çekiyoruz
      unevenSkinTone: json['unevenSkinTone'],
      eyeConcerns: List<String>.from(json['eyeConcerns'] ?? []),
      acneType: json['acneType'],
      allergies: json['allergies'],
      pregnancyStatus: json['pregnancyStatus'],
      activeIngredients: List<String>.from(json['activeIngredients'] ?? []),
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
}
