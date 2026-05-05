import '../models/question_model.dart';

class QuizData {
  static final QuestionModel entryQuestion = QuestionModel(
    id: "entry",
    questionText: "Cilt tipinizi biliyor musunuz?",
    type: QuestionType.branching,
    options: [
      QuizOption(text: "Evet, Biliyorum", subtitle: "Doğrudan cilt tipimi seçeceğim"),
      QuizOption(text: "Emin Değilim", subtitle: "Bana 5 soruluk test testini uygulayın"),
      QuizOption(text: "Kamera ile Analiz", subtitle: "Yapay zeka analiz etsin (Yakında eklenecek)"),
    ],
  );

  static final QuestionModel directSkinTypeQuestion = QuestionModel(
    id: "direct_skin_type",
    questionText: "Harika! Cilt tipiniz nedir?",
    type: QuestionType.single,
    options: [
      QuizOption(text: "Normal", subtitle: "Ne çok yağlı ne kurudur"),
      QuizOption(text: "Yağlı", subtitle: "Tüm yüzde parlama gözlemlenir"),
      QuizOption(text: "Kuru", subtitle: "Gergin ve nemsiz hisseder"),
      QuizOption(text: "Karma", subtitle: "Sadece T bölgesi (alın, burun, çene) yağlıdır"),
      QuizOption(text: "Hassas", subtitle: "Kızarmaya oldukça müsaittir"),
    ],
  );

  static final List<QuestionModel> skinTypeQuiz = [
    QuestionModel(id: "sq1", questionText: "Yüzünüzü yıkadıktan biraz sonra nasıl hissediyorsunuz?", options: [
      QuizOption(text: "Gergin ve pul pul", subtitle: "Neme ihtiyaç duyarım"),
      QuizOption(text: "Rahat", subtitle: "Bir sorun hissetmem"),
      QuizOption(text: "Sadece T bölgem parlıyor", subtitle: "Alın ve burun çevrem yağlanır"),
      QuizOption(text: "Komple yağlı", subtitle: "Cildim parlıyor"),
    ]),
    QuestionModel(id: "sq2", questionText: "Gözeneklerinizin boyutu ve durumu nedir?", options: [
      QuizOption(text: "Neredeyse görünmez"),
      QuizOption(text: "Sadece burun ve çenemde belirgin"),
      QuizOption(text: "Tüm yüzümde büyük ve belirgin"),
    ]),
    QuestionModel(id: "sq3", questionText: "Gün içinde cildinizde parlama olur mu?", options: [
      QuizOption(text: "Hayır, genelde mat kalır"),
      QuizOption(text: "Sadece öğleden sonra hafifçe parlar"),
      QuizOption(text: "Evet, çok çabuk ve her yerde parlar"),
    ]),
    QuestionModel(id: "sq4", questionText: "Cildinizde pul pul dökülme veya pürüzler olur mu?", options: [
      QuizOption(text: "Evet, sık sık yaşarım"),
      QuizOption(text: "Sadece soğuk havalarda"),
      QuizOption(text: "Hayır, cildim genelde pürüzsüzdür"),
    ]),
    QuestionModel(id: "sq5", questionText: "Farklı bir ürün değdiğinde cildinizde kızarıklık olur mu?", options: [
      QuizOption(text: "Evet, hemen tepki verir ve kızarır"),
      QuizOption(text: "Bazen içindeki asitlere göre değişir"),
      QuizOption(text: "Hayır, cildim dayanıklıdır"),
    ]),
  ];

  static final List<QuestionModel> mainSurvey = [
    QuestionModel(id: "m1", questionText: "Yaş aralığınız nedir?", options: [
      QuizOption(text: "18 - 24"), QuizOption(text: "25 - 34"), QuizOption(text: "35 - 44"), QuizOption(text: "45 ve üzeri")
    ]),
    QuestionModel(id: "m2", questionText: "Genel Cilt Hassasiyetiniz:", options: [
      QuizOption(text: "Düşük", subtitle: "Ürünler kolayca reaksiyon yapmaz"),
      QuizOption(text: "Orta", subtitle: "Bazı aktif bileşenler dokunabilir"),
      QuizOption(text: "Yüksek", subtitle: "Çok çabuk kızarır ve yanar"),
    ]),
    QuestionModel(id: "m3", type: QuestionType.multi, questionText: "En büyük cilt endişeleriniz neler? (Birden fazla seçilebilir)", options: [
      QuizOption(text: "Akne ve Sivilceler"), QuizOption(text: "Siyah Noktalar"), QuizOption(text: "Koyu Lekeler"),
      QuizOption(text: "İnce Çizgiler / Kırışıklık"), QuizOption(text: "Kızarıklık / Rozasea"), QuizOption(text: "Matlık")
    ]),
    QuestionModel(id: "m4", questionText: "Cilt renginizde eşitsizlik (bölgesel kararmalar vb) var mı?", options: [
      QuizOption(text: "Evet, sıklıkla"), QuizOption(text: "Sadece sivilce izlerinde"), QuizOption(text: "Hayır")
    ]),
    QuestionModel(id: "m5", type: QuestionType.multi, questionText: "Göz çevresi endişeleriniz? (Birden fazla seçilebilir)", options: [
      QuizOption(text: "Morluklar / Koyu Halkalar"), QuizOption(text: "Kaz Ayakları / Çizgiler"), 
      QuizOption(text: "Torbalanma"), QuizOption(text: "Göz altı kuruluğu"), QuizOption(text: "Sorunum yok")
    ]),
    QuestionModel(id: "m6", questionText: "Sivilce (Akne) probleminizin ağırlığı nedir?", options: [
      QuizOption(text: "Aktif, kırmızı iltihaplı"), QuizOption(text: "Deri altında pütürler (Komedon)"), 
      QuizOption(text: "Sadece regl dönemlerinde"), QuizOption(text: "Hiç çıkmaz")
    ]),
    QuestionModel(id: "m7", questionText: "Bilinen bir içerik alerjiniz var mı?", options: [
      QuizOption(text: "Hayır, yok"), QuizOption(text: "Evet (Gluten, Parfüm vb.)")
    ]),
    QuestionModel(id: "m8", questionText: "Hamilelik veya emzirme durumunuz var mı?", options: [
      QuizOption(text: "Hayır"), QuizOption(text: "Evet")
    ]),
    QuestionModel(id: "m9", type: QuestionType.multi, questionText: "Şu an rutininizde hangi aktif içerikler var?", options: [
      QuizOption(text: "C Vitamini"), QuizOption(text: "Retinol / Retinoid"), QuizOption(text: "AHA/BHA (Asitler)"), 
      QuizOption(text: "Peptitler / Bariyer Güçlendirici"), QuizOption(text: "Hiçbiri")
    ]),
    QuestionModel(id: "m10", questionText: "Güneş kremi kullanma alışkanlığınız nedir?", options: [
      QuizOption(text: "Her gün ve düzenli sürerim"), QuizOption(text: "Sadece güneşi doğrudan gördüğümde"), QuizOption(text: "Kullanmıyorum")
    ]),
    QuestionModel(id: "m11", questionText: "Ne sıklıkla makyaj yaparsınız?", options: [
      QuizOption(text: "Her gün cilt makyajı (Fondöten vb)"), QuizOption(text: "Sadece göz/dudak veya özel günlerde"), QuizOption(text: "Hiç yapmam")
    ]),
    QuestionModel(id: "m12", questionText: "Cildinizi genellikle nasıl temizlersiniz?", options: [
      QuizOption(text: "Çift aşamalı (Yağ bazlı + Su bazlı jeller)"), QuizOption(text: "Misel su veya makyaj mendili ile"), QuizOption(text: "Sadece yüz yıkama jeliyle")
    ]),
    QuestionModel(id: "m13", questionText: "Günlük su tüketiminiz ortalama nasıldır?", options: [
      QuizOption(text: "1 Litreden az"), QuizOption(text: "1-2 Litre arası"), QuizOption(text: "2 Litreden fazla")
    ]),
    QuestionModel(id: "m14", questionText: "Ağırlıklı olarak bulunduğunuz iklim/ortam nasıl?", options: [
      QuizOption(text: "Klimalı / Isıtıcılı (Nemsiz)"), QuizOption(text: "Sıcak ve Nemli"), QuizOption(text: "Normal/Dengeli")
    ]),
    QuestionModel(id: "m15", questionText: "Ürün önerileri için bütçe tercihiniz?", options: [
      QuizOption(text: "Ekonomik"), QuizOption(text: "Fiyat / Performans"), QuizOption(text: "Lüks (High-end)")
    ]),
  ];
}
