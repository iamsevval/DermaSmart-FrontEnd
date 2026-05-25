import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../services/favorites_service.dart';
import '../../../services/custom_routine_service.dart';
import 'product_catalog_screen.dart'; // Product modelini buradan alıyoruz

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final FavoritesService _favoritesService = FavoritesService();
  bool _isFavorite = false;
  bool _isLoadingFavorite = true;

  bool _isInRoutine = false;
  bool _isLoadingRoutine = true;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
    _checkIfInRoutine();
  }

  Future<void> _checkIfInRoutine() async {
    final inRoutine = await CustomRoutineService.isProductInRoutine(widget.product.id);
    if (mounted) {
      setState(() {
        _isInRoutine = inRoutine;
        _isLoadingRoutine = false;
      });
    }
  }

  Future<void> _checkIfFavorite() async {
    try {
      final favorites = await _favoritesService.getFavorites();
      if (mounted) {
        setState(() {
          _isFavorite = favorites.any((p) => p.id == widget.product.id);
          _isLoadingFavorite = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingFavorite = false;
        });
      }
    }
  }

  Future<void> _toggleFavorite() async {
    setState(() => _isLoadingFavorite = true);
    bool success = false;
    
    if (_isFavorite) {
      success = await _favoritesService.removeFavorite(widget.product.id);
    } else {
      success = await _favoritesService.addFavorite(widget.product.id);
    }

    if (success && mounted) {
      setState(() {
        _isFavorite = !_isFavorite;
        _isLoadingFavorite = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isFavorite ? 'Favorilere eklendi.' : 'Favorilerden çıkarıldı.'),
          duration: const Duration(seconds: 2),
        ),
      );
    } else if (mounted) {
      setState(() => _isLoadingFavorite = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('İşlem başarısız oldu.')),
      );
    }
  }

  Future<void> _toggleRoutine() async {
    setState(() => _isLoadingRoutine = true);
    
    if (_isInRoutine) {
      await CustomRoutineService.removeProduct(widget.product.id);
    } else {
      await CustomRoutineService.addProduct(widget.product);
    }

    if (mounted) {
      setState(() {
        _isInRoutine = !_isInRoutine;
        _isLoadingRoutine = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isInRoutine ? 'Rutine eklendi.' : 'Rutinden çıkarıldı.'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F2),
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: _buildBody(context),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 320,
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8),
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.92),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF1A2332),
              size: 18,
            ),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.92),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: _isLoadingFavorite 
                ? const SizedBox(
                    width: 20, 
                    height: 20, 
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary)
                  )
                : Icon(
                    _isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
              onPressed: _isLoadingFavorite ? null : _toggleFavorite,
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              widget.product.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: AppColors.surfaceVariant,
                child: const Center(
                  child: Icon(Icons.spa_outlined,
                      size: 64, color: AppColors.textHint),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 80,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      const Color(0xFFF8F5F2).withOpacity(0.9),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProductHeader(context),
          const SizedBox(height: 20),
          _buildSkinTypeBadge(),
          const SizedBox(height: 24),
          _buildDivider(),
          const SizedBox(height: 24),
          _buildPurposeSection(context),
          const SizedBox(height: 24),
          _buildDivider(),
          const SizedBox(height: 24),
          _buildIngredientsSection(context),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildProductHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.product.brand.toUpperCase(),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          widget.product.name,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                letterSpacing: -0.5,
                height: 1.15,
              ),
        ),
        const SizedBox(height: 12),
        Text(
          '₺${widget.product.price.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w900,
            color: AppColors.primary,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildSkinTypeBadge() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: AppColors.success),
          const SizedBox(width: 10),
          Text(
            '${widget.product.skinType} için uygun',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF2E7D32),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(height: 1, color: const Color(0xFFE8EEF4));
  }

  Widget _buildPurposeSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context,
            icon: Icons.spa_outlined, label: 'Kullanım Amacı'),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1A2332).withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Text(
            widget.product.purpose,
            style: const TextStyle(
              fontSize: 14.5,
              color: AppColors.textSecondary,
              height: 1.7,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIngredientsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context,
            icon: Icons.science_outlined, label: 'Aktif Bileşenler'),
        const SizedBox(height: 14),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: widget.product.ingredients
              .asMap()
              .entries
              .map((e) => _buildIngredientChip(e.value, e.key))
              .toList(),
        ),
        const SizedBox(height: 16),
        _buildAllergyNote(),
      ],
    );
  }

  Widget _buildIngredientChip(String ingredient, int index) {
    const colors = [
      AppColors.primary,
      Color(0xFF4A7C59),
      Color(0xFFC1666B),
      Color(0xFFF4A261),
      Color(0xFF7C4DFF),
      Color(0xFF00897B),
    ];
    final color = colors[index % colors.length];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.25), width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            ingredient,
            style: TextStyle(
                fontSize: 13, fontWeight: FontWeight.w600, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildAllergyNote() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: const Color(0xFFF4A261).withOpacity(0.3), width: 1),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, size: 16, color: Color(0xFFF4A261)),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Bileşenlere karşı alerjiniz varsa kullanmadan önce dermatoloğunuza danışmanızı öneririz.',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF9C7040),
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context,
      {required IconData icon, required String label}) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(label, style: Theme.of(context).textTheme.titleLarge),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          24, 16, 24, MediaQuery.of(context).padding.bottom + 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A2332).withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _isLoadingRoutine ? null : _toggleRoutine,
                icon: _isLoadingRoutine 
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : Icon(_isInRoutine ? Icons.remove_circle_outline : Icons.add, color: Colors.white),
                label: Text(
                  _isInRoutine ? 'Rutinden Çıkar' : 'Rutine Ekle',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isInRoutine ? Colors.red.shade400 : AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
