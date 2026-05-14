import 'package:flutter/material.dart';
import '../../../data/quiz_data.dart';
import '../../../models/question_model.dart';
import '../../../models/user_profile_model.dart';
import '../../../shared/widgets/single_choice_card.dart';
import '../../../shared/widgets/multi_choice_card.dart';
import 'result_screen.dart';
import '../../../services/auth_service.dart';

class QuizFlowScreen extends StatefulWidget {
  final UserProfileModel userProfile;
  const QuizFlowScreen({super.key, required this.userProfile});

  @override
  State<QuizFlowScreen> createState() => _QuizFlowScreenState();
}

class _QuizFlowScreenState extends State<QuizFlowScreen> {
  final PageController _pageController = PageController();
  late UserProfileModel _userProfile;

  List<QuestionModel> _activeQuestions = [QuizData.entryQuestion];
  int _currentIndex = 0;

  String? _selectedSingleOption;
  final List<String> _selectedMultiOptions = [];
  bool _isQuizStarted = false;

  void _goBack() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _selectedSingleOption = null;
        _selectedMultiOptions.clear();
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    _userProfile = widget.userProfile;
  }

  void _nextPage() async {
    if (_currentIndex < _activeQuestions.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      String formattedAge = _userProfile.ageRange ?? "18-24";
      formattedAge = formattedAge.replaceAll(' ', ''); 

      await AuthService.saveSkinProfile(
        token: _userProfile.token!,
        skinType: _userProfile.skinType ?? "Normal",
        concerns: _userProfile.skinConcerns ?? [],
        ageRange: formattedAge,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(userProfile: _userProfile),
        ),
      );
    }
  }

  void _handleAnswer() {
    final currentQuestion = _activeQuestions[_currentIndex];

    if (currentQuestion.id == "entry") {
      if (_selectedSingleOption == QuizData.entryQuestion.options[0].text) {
        setState(() {
          _activeQuestions = [
            QuizData.directSkinTypeQuestion,
            ...QuizData.mainSurvey
          ];
          _isQuizStarted = true;
          _currentIndex = 0;
          _selectedSingleOption = null;
          _selectedMultiOptions.clear();
        });
        _pageController.jumpToPage(0);
        return;
      } else if (_selectedSingleOption ==
          QuizData.entryQuestion.options[1].text) {
        setState(() {
          _activeQuestions = [...QuizData.skinTypeQuiz, ...QuizData.mainSurvey];
          _isQuizStarted = true;
          _currentIndex = 0;
          _selectedSingleOption = null;
          _selectedMultiOptions.clear();
        });
        _pageController.jumpToPage(0);
        return;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Yapay zeka kamera analizi çok yakında eklenecektir!',
                style: TextStyle(fontWeight: FontWeight.bold)),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.deepPurple,
            duration: Duration(seconds: 3),
          ),
        );
        setState(() => _selectedSingleOption = null);
        return;
      }
    } else {
      String qId = currentQuestion.id;
      if (qId == "direct_skin_type")
        _userProfile.skinType = _selectedSingleOption;
      if (qId == "sq1") _userProfile.washFeeling = _selectedSingleOption;
      if (qId == "sq2") _userProfile.poreSize = _selectedSingleOption;
      if (qId == "sq3") _userProfile.shineLevel = _selectedSingleOption;
      if (qId == "sq4") _userProfile.flakiness = _selectedSingleOption;
      if (qId == "sq5")
        _userProfile.sensitivityResponse = _selectedSingleOption;
      if (qId == "m1") _userProfile.ageRange = _selectedSingleOption;
      if (qId == "m2") _userProfile.generalSensitivity = _selectedSingleOption;
      if (qId == "m3")
        _userProfile.skinConcerns = List.from(_selectedMultiOptions);
      if (qId == "m4") _userProfile.unevenSkinTone = _selectedSingleOption;
      if (qId == "m5")
        _userProfile.eyeConcerns = List.from(_selectedMultiOptions);
      if (qId == "m6") _userProfile.acneType = _selectedSingleOption;
      if (qId == "m7") _userProfile.allergies = _selectedSingleOption;
      if (qId == "m8") _userProfile.pregnancyStatus = _selectedSingleOption;
      if (qId == "m9")
        _userProfile.activeIngredients = List.from(_selectedMultiOptions);
      if (qId == "m10") _userProfile.sunscreenUsage = _selectedSingleOption;
      if (qId == "m11") _userProfile.makeupFrequency = _selectedSingleOption;
      if (qId == "m12") _userProfile.makeupRemoval = _selectedSingleOption;
      if (qId == "m13") _userProfile.waterIntake = _selectedSingleOption;
      if (qId == "m14") _userProfile.climate = _selectedSingleOption;
      if (qId == "m15") _userProfile.budget = _selectedSingleOption;

      setState(() {
        _selectedSingleOption = null;
        _selectedMultiOptions.clear();
      });
      _nextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isLastPage = _currentIndex == _activeQuestions.length - 1;
    String buttonText =
        (_isQuizStarted && isLastPage) ? 'Analizi Bitir' : 'Devam Et';
    bool hasAnswer =
        _selectedSingleOption != null || _selectedMultiOptions.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Cilt Analizi',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
          onPressed: _goBack,
        ),
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: (_currentIndex + 1) / _activeQuestions.length,
            backgroundColor: Colors.grey.shade200,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.deepPurple),
            minHeight: 6,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                  _selectedSingleOption = null;
                  _selectedMultiOptions.clear();
                });
              },
              itemCount: _activeQuestions.length,
              itemBuilder: (context, index) {
                final question = _activeQuestions[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Text(
                        question.questionText,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: Colors.black87,
                          height: 1.3,
                        ),
                      ),
                      if (question.type == QuestionType.multi) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Birden fazla seçebilirsiniz',
                          style: TextStyle(
                              fontSize: 13, color: Colors.grey.shade500),
                        ),
                      ],
                      const SizedBox(height: 32),
                      Expanded(
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: question.options.length,
                          itemBuilder: (context, optionIndex) {
                            final option = question.options[optionIndex];
                            if (question.type == QuestionType.multi) {
                              return MultiChoiceCard(
                                text: option.text,
                                subtitle: option.subtitle,
                                isSelected:
                                    _selectedMultiOptions.contains(option.text),
                                onTap: () {
                                  setState(() {
                                    if (_selectedMultiOptions
                                        .contains(option.text)) {
                                      _selectedMultiOptions.remove(option.text);
                                    } else {
                                      // 🔥 GENEL FİLTRE: "Sıfırlayıcı/Nötr" şıklardan biri seçildiyse her şeyi temizle
                                      if (option.text == "Hiçbiri" || 
                                          option.text == "Sorunum yok" || 
                                          option.text == "Hayır, yok") {
                                        _selectedMultiOptions.clear();
                                        _selectedMultiOptions.add(option.text);
                                      } else {
                                        // 🔥 Eğer normal bir şikayet seçildiyse, listesindeki nötr şıkları kaldır
                                        _selectedMultiOptions.remove("Hiçbiri");
                                        _selectedMultiOptions.remove("Sorunum yok");
                                        _selectedMultiOptions.remove("Hayır, yok");
                                        _selectedMultiOptions.add(option.text);
                                      }
                                    }
                                  });
                                },
                              );
                            } else {
                              return SingleChoiceCard(
                                text: option.text,
                                subtitle: option.subtitle,
                                isSelected:
                                    _selectedSingleOption == option.text,
                                onTap: () {
                                  setState(() =>
                                      _selectedSingleOption = option.text);
                                },
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              children: [
                if (_currentIndex > 0) ...[
                  SizedBox(
                    width: 56,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _goBack,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade200,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Icon(Icons.arrow_back_ios,
                          size: 18, color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: hasAnswer ? _handleAnswer : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        disabledBackgroundColor: Colors.grey.shade300,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        buttonText,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color:
                              hasAnswer ? Colors.white : Colors.grey.shade500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}