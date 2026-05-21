class RoutineLogic {
  // ── ÇAKIŞMA KURALLARI ──────────────────────────────────────────
  static const List<Map<String, dynamic>> _conflictRules = [
    {
      'ingredients': ['C Vitamini Serumu', 'Niasinamid'],
      'message': '⚠️ C Vitamini + Niasinamid: Aynı anda kullanmayın. C Vitamini sabah, Niasinamid akşam rutinine alındı.',
      'severity': 'warning',
    },
    {
      'ingredients': ['Retinol Serumu', 'Glikolik Asit Toniği'],
      'message': '🚫 Retinol + AHA Asit: Aynı gece kullanılamaz! Cilt bariyerinizi korumak için farklı gecelere bölündü.',
      'severity': 'critical',
    },
    {
      'ingredients': ['Retinol Serumu', 'AHA/BHA Asit Serumu'],
      'message': '🚫 Retinol + AHA/BHA: Aynı gece kullanılamaz! Farklı akşamlara bölündü.',
      'severity': 'critical',
    },
    {
      'ingredients': ['C Vitamini Serumu', 'Retinol Serumu'],
      'message': '⚠️ C Vitamini + Retinol: C Vitamini sabah, Retinol akşam kullanılmalı. Rutininiz buna göre düzenlendi.',
      'severity': 'warning',
    },
    {
      'ingredients': ['Benzoil Peroksit', 'Retinol Serumu'],
      'message': '🚫 Benzoil Peroksit + Retinol: Birbirini etkisiz kılar. Farklı gecelere ayrıldı.',
      'severity': 'critical',
    },
  ];

  // ── CİLT TİPİNE GÖRE SABAH RUTİNİ ────────────────────────────
  static List<Map<String, String>> getMorningRoutine({
    required String skinType,
    required List<String> skinConcerns,
  }) {
    final steps = <Map<String, String>>[];
    final type = skinType.toLowerCase();

    // 1. Temizleyici
    if (type.contains('yağlı') || type.contains('karma')) {
      steps.add({
        'stepName': 'Jel Yüz Temizleyici',
        'description': 'Köpürtüp 60 sn. uygula, T bölgesine odaklan',
        'warning': '',
      });
    } else if (type.contains('kuru') || type.contains('hassas')) {
      steps.add({
        'stepName': 'Kremsi Yüz Temizleyici',
        'description': 'Nazikçe masaj yap, ılık suyla durula',
        'warning': '',
      });
    } else {
      steps.add({
        'stepName': 'Yüz Temizleyici',
        'description': 'Nazikçe 60 sn. uygula',
        'warning': '',
      });
    }

    // 2. Tonik
    if (type.contains('hassas')) {
      steps.add({
        'stepName': 'Sakinleştirici Tonik',
        'description': 'Pamukla silerek uygula, alkol içermez',
        'warning': '',
      });
    } else if (type.contains('yağlı') || type.contains('karma')) {
      steps.add({
        'stepName': 'Gözenek Sıkılaştırıcı Tonik',
        'description': 'T bölgesine ekstra uygula',
        'warning': '',
      });
    } else {
      steps.add({
        'stepName': 'Nemlendirici Tonik',
        'description': 'Pamukla silerek uygula',
        'warning': '',
      });
    }

    // 3. Serum (endişeye göre)
    if (skinConcerns.contains('Koyu Lekeler') ||
        skinConcerns.contains('Akne ve Sivilceler')) {
      steps.add({
        'stepName': 'C Vitamini Serumu',
        'description': 'Sabahları kullan, leke açıcı etki',
        'warning': 'Niasinamid ile aynı anda kullanmayın',
      });
    } else if (skinConcerns.contains('İnce Çizgiler / Kırışıklık')) {
      steps.add({
        'stepName': 'Peptit Serumu',
        'description': 'Sabah kullanımına uygundur',
        'warning': '',
      });
    } else if (skinConcerns.contains('Kızarıklık / Rozasea') ||
        type.contains('hassas')) {
      steps.add({
        'stepName': 'Centella / Niasinamid Serumu',
        'description': 'Sakinleştirici etki, sabah kullanımı',
        'warning': '',
      });
    }

    // 4. Nemlendirici
    if (type.contains('yağlı')) {
      steps.add({
        'stepName': 'Hafif Jel Nemlendirici',
        'description': 'Yağsız formül, hafif vur vuruşla uygula',
        'warning': '',
      });
    } else if (type.contains('kuru')) {
      steps.add({
        'stepName': 'Yoğun Nemlendirici Krem',
        'description': 'Daireler çizerek uygula',
        'warning': '',
      });
    } else {
      steps.add({
        'stepName': 'Nemlendirici',
        'description': 'Hafif vur vuruşla uygula',
        'warning': '',
      });
    }

    // 5. SPF — HER ZAMAN SON ADIM
    steps.add({
      'stepName': 'SPF 50+ Güneş Kremi',
      'description': 'Son adım — ZORUNLU, her gün kullan',
      'warning': '',
    });

    return steps;
  }

  // ── CİLT TİPİNE GÖRE AKŞAM RUTİNİ ────────────────────────────
  static List<Map<String, String>> getEveningRoutine({
    required String skinType,
    required List<String> skinConcerns,
  }) {
    final steps = <Map<String, String>>[];
    final type = skinType.toLowerCase();

    // 1. Makyaj temizleme (makyaj yapıyorsa)
    steps.add({
      'stepName': 'Makyaj Temizleyici Yağ',
      'description': 'Çift temizleme - 1. adım, 60 sn. uygula',
      'warning': '',
    });

    // 2. Temizleyici
    if (type.contains('yağlı') || type.contains('karma')) {
      steps.add({
        'stepName': 'Jel Yüz Temizleyici',
        'description': 'Köpürtüp durulayın',
        'warning': '',
      });
    } else {
      steps.add({
        'stepName': 'Kremsi Yüz Temizleyici',
        'description': 'Nazikçe durulayın',
        'warning': '',
      });
    }

    // 3. Tonik
    if (skinConcerns.contains('Akne ve Sivilceler') ||
        skinConcerns.contains('Siyah Noktalar')) {
      steps.add({
        'stepName': 'Glikolik Asit Toniği',
        'description': 'Haftada 2-3x kullan, retinol kullandığın gece atlat',
        'warning': 'Retinol ile aynı gece kullanmayın',
      });
    } else {
      steps.add({
        'stepName': 'Nemlendirici Tonik',
        'description': '30 sn. bekleyin',
        'warning': '',
      });
    }

    // 4. Aktif serum
    if (skinConcerns.contains('İnce Çizgiler / Kırışıklık') ||
        skinConcerns.contains('Koyu Lekeler')) {
      steps.add({
        'stepName': 'Retinol Serumu',
        'description': 'Haftada 2-3x kullan, yavaş başla',
        'warning': 'AHA/BHA asitler ve C Vitamini ile aynı gece kullanmayın',
      });
    } else if (skinConcerns.contains('Akne ve Sivilceler')) {
      steps.add({
        'stepName': 'AHA/BHA Asit Serumu',
        'description': 'Haftada 2x kullan, retinol kullandığın gece atlat',
        'warning': 'Retinol ile aynı gece kullanmayın',
      });
    } else if (skinConcerns.contains('Kızarıklık / Rozasea') ||
        type.contains('hassas')) {
      steps.add({
        'stepName': 'Centella Asiatica Serumu',
        'description': 'Her akşam güvenle kullanabilirsin',
        'warning': '',
      });
    } else {
      steps.add({
        'stepName': 'Niasinamid Serumu',
        'description': 'Gözenek küçültücü, her akşam kullanılabilir',
        'warning': '',
      });
    }

    // 5. Göz kremi (göz endişesi varsa)
    if (skinConcerns.contains('Morluklar / Koyu Halkalar') ||
        skinConcerns.contains('Kaz Ayakları / Çizgiler') ||
        skinConcerns.contains('Torbalanma')) {
      steps.add({
        'stepName': 'Göz Çevresi Kremi',
        'description': 'Yüzük parmağıyla nazikçe uygula',
        'warning': '',
      });
    }

    // 6. Nemlendirici
    if (type.contains('kuru')) {
      steps.add({
        'stepName': 'Yoğun Gece Kremi',
        'description': 'Uyumadan önce bolca uygula',
        'warning': '',
      });
    } else {
      steps.add({
        'stepName': 'Ağır Nemlendirici',
        'description': 'Gece kremi, onarıcı etki',
        'warning': '',
      });
    }

    return steps;
  }

  // ── ÇAKIŞMA KONTROLÜ ──────────────────────────────────────────
  static List<Map<String, dynamic>> checkConflicts({
    required List<Map<String, String>> morningSteps,
    required List<Map<String, String>> eveningSteps,
  }) {
    final allStepNames = [
      ...morningSteps.map((s) => s['stepName'] ?? ''),
      ...eveningSteps.map((s) => s['stepName'] ?? ''),
    ];

    final detectedConflicts = <Map<String, dynamic>>[];

    for (final rule in _conflictRules) {
      final ingredients = rule['ingredients'] as List<String>;
      final allPresent = ingredients.every((ing) =>
          allStepNames.any((name) =>
              name.toLowerCase().contains(ing.toLowerCase())));
      if (allPresent) {
        detectedConflicts.add({
          'message': rule['message'],
          'severity': rule['severity'],
        });
      }
    }

    return detectedConflicts;
  }
}