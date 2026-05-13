import 'package:flutter/material.dart';
import '../../../models/user_profile_model.dart';
import 'quiz_flow_screen.dart';
import '../../../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeIn);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic));
    _animController.forward();
    _passwordCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    _animController.dispose();
    super.dispose();
  }

  String? _validateName(String? v) {
    if (v == null || v.trim().isEmpty) return 'İsim boş bırakılamaz';
    if (v.trim().length < 2) return 'İsim en az 2 karakter olmalı';
    if (!RegExp(r'^[a-zA-ZğüşöçıİĞÜŞÖÇ\s]+$').hasMatch(v.trim()))
      return 'İsim sadece harf içermeli';
    return null;
  }

  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'E-posta boş bırakılamaz';
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v.trim()))
      return 'Geçerli bir e-posta girin';
    return null;
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Şifre boş bırakılamaz';
    if (v.length < 6) return 'En az 6 karakter olmalı';
    if (!v.contains(RegExp(r'[0-9]'))) return 'En az 1 rakam içermeli';
    return null;
  }

  String? _validateConfirm(String? v) {
    if (v == null || v.isEmpty) return 'Şifre tekrarı boş bırakılamaz';
    if (v != _passwordCtrl.text) return 'Şifreler eşleşmiyor';
    return null;
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    // 1. Kayıt isteği
    final result = await AuthService.register(
      fullName: _nameCtrl.text.trim(), // AuthService'deki yeni parametre adı
      email: _emailCtrl.text.trim(),
      password: _passwordCtrl.text,
    );

    if (!mounted) return;

    if (result['success']) {
      // 2. Kayıt başarılıysa otomatik giriş yap
      final loginResult = await AuthService.login(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text,
      );

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (loginResult['success']) {
        // NOT: saveName hatasını çözmek için AuthService'e bu fonksiyonu eklemedik.
        // Onun yerine doğrudan loginResult içindeki ismi kullanıyoruz.

        final userProfile = UserProfileModel(
          name: loginResult['name'] ??
              _nameCtrl.text
                  .trim(), // Backend'den gelen veya Controller'daki isim
          email: _emailCtrl.text.trim(),
          token: loginResult['token'],
          userId: loginResult['userId'],
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => QuizFlowScreen(userProfile: userProfile),
          ),
        );
      }
    } else {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Bir hata oluştu.'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final password = _passwordCtrl.text;
    final hasLength = password.length >= 6;
    final hasNumber = password.contains(RegExp(r'[0-9]'));

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_ios, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnim,
        child: SlideTransition(
          position: _slideAnim,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Hesap Oluştur 🌿',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Colors.black87)),
                  const SizedBox(height: 6),
                  Text('Cilt profilini oluşturmak için kayıt ol.',
                      style:
                          TextStyle(fontSize: 15, color: Colors.grey.shade600)),
                  const SizedBox(height: 32),
                  _FieldLabel(text: 'Ad Soyad'),
                  TextFormField(
                    controller: _nameCtrl,
                    validator: _validateName,
                    textCapitalization: TextCapitalization.words,
                    decoration: _buildDecoration(
                        'Adınız ve soyadınız', Icons.person_outline),
                  ),
                  const SizedBox(height: 16),
                  _FieldLabel(text: 'E-posta'),
                  TextFormField(
                    controller: _emailCtrl,
                    validator: _validateEmail,
                    keyboardType: TextInputType.emailAddress,
                    decoration: _buildDecoration(
                        'ornek@email.com', Icons.email_outlined),
                  ),
                  const SizedBox(height: 16),
                  _FieldLabel(text: 'Şifre'),
                  TextFormField(
                    controller: _passwordCtrl,
                    validator: _validatePassword,
                    obscureText: _obscurePassword,
                    decoration: _buildDecoration(
                      'En az 6 karakter',
                      Icons.lock_outlined,
                      suffix: IconButton(
                        icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Colors.grey.shade400,
                            size: 20),
                        onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _CriteriaRow(met: hasLength, text: 'En az 6 karakter'),
                  const SizedBox(height: 4),
                  _CriteriaRow(met: hasNumber, text: 'En az 1 rakam'),
                  const SizedBox(height: 16),
                  _FieldLabel(text: 'Şifre Tekrar'),
                  TextFormField(
                    controller: _confirmCtrl,
                    validator: _validateConfirm,
                    obscureText: _obscureConfirm,
                    decoration: _buildDecoration(
                      'Şifrenizi tekrar girin',
                      Icons.lock_outlined,
                      suffix: IconButton(
                        icon: Icon(
                            _obscureConfirm
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Colors.grey.shade400,
                            size: 20),
                        onPressed: () =>
                            setState(() => _obscureConfirm = !_obscureConfirm),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        disabledBackgroundColor: Colors.grey.shade300,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2.5, color: Colors.white))
                          : const Text('Kayıt Ol & Teste Başla',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: RichText(
                        text: TextSpan(
                          text: 'Zaten hesabın var mı? ',
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 14),
                          children: const [
                            TextSpan(
                              text: 'Giriş Yap',
                              style: TextStyle(
                                  color: Colors.deepPurple,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _buildDecoration(String hint, IconData icon,
      {Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
      prefixIcon: Icon(icon, color: Colors.grey.shade400, size: 20),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text,
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87)),
    );
  }
}

class _CriteriaRow extends StatelessWidget {
  final bool met;
  final String text;
  const _CriteriaRow({required this.met, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Icon(
            met ? Icons.check_circle : Icons.radio_button_unchecked,
            key: ValueKey(met),
            size: 16,
            color: met ? Colors.green : Colors.grey.shade400,
          ),
        ),
        const SizedBox(width: 6),
        Text(text,
            style: TextStyle(
              fontSize: 12,
              color: met ? Colors.green.shade700 : Colors.grey.shade500,
              fontWeight: met ? FontWeight.w600 : FontWeight.normal,
            )),
      ],
    );
  }
}
