import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'product_detail_screen.dart';

// ── Mock Data ──────────────────────────────────────────────────────────────

class Product {
  final String id;
  final String name;
  final String brand;
  final String imageUrl;
  final String skinType;
  final double price;
  final List<String> ingredients;
  final String purpose;

  const Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.imageUrl,
    required this.skinType,
    required this.price,
    required this.ingredients,
    required this.purpose,
  });
}

final List<Product> mockProducts = [
  Product(
    id: '1',
    name: 'Hydra Boost Serum',
    brand: 'ClearDerm',
    imageUrl: 'https://placehold.co/300x300/e8f4f8/2c7da0?text=Serum',
    skinType: 'Kuru Cilt',
    price: 249.90,
    ingredients: ['Hyaluronic Acid', 'Niacinamide', 'Ceramide NP', 'Panthenol'],
    purpose:
    'Derin nemlendirme sağlayan bu serum, kuru ve hassas ciltler için özel olarak formüle edilmiştir. Hyaluronic Acid içeriği ile cildin nem dengesini 24 saat boyunca korur.',
  ),
  Product(
    id: '2',
    name: 'Mattify Control Gel',
    brand: 'SkinLab',
    imageUrl: 'https://placehold.co/300x300/f0f4e8/4a7c59?text=Gel',
    skinType: 'Yağlı Cilt',
    price: 189.50,
    ingredients: ['Salicylic Acid %2', 'Zinc PCA', 'Niacinamide', 'Aloe Vera'],
    purpose:
    'Yağlı ve karma ciltler için tasarlanan bu nemlendirici jel, gözenekleri minimize ederken cildi mat ve dengeli tutar. Salisilik asit içeriği ile sivilce oluşumunu önler.',
  ),
  Product(
    id: '3',
    name: 'Calm & Repair Cream',
    brand: 'DermaPure',
    imageUrl: 'https://placehold.co/300x300/f8ece8/c1666b?text=Cream',
    skinType: 'Hassas Cilt',
    price: 312.00,
    ingredients: ['Centella Asiatica', 'Allantoin', 'Ceramide EOP', 'Bisabolol'],
    purpose:
    'Hassas ve reaktif ciltler için geliştirilen bu yatıştırıcı krem, kızarıklık ve tahrişi giderir. Centella Asiatica\'nın iyileştirici gücü ile cilt bariyerini güçlendirir.',
  ),
  Product(
    id: '4',
    name: 'Vitamin C Glow Drops',
    brand: 'LumiSkin',
    imageUrl: 'https://placehold.co/300x300/fff8e1/f4a261?text=Drops',
    skinType: 'Normal Cilt',
    price: 275.00,
    ingredients: ['Ascorbic Acid %15', 'Vitamin E', 'Ferulic Acid', 'Rosehip Oil'],
    purpose:
    'Normal ve karma ciltlere parlaklık kazandıran bu serum, melanin sentezini baskılayarak cilt tonunu eşitler. Antioksidan formülü ile çevresel hasara karşı koruma sağlar.',
  ),
  Product(
    id: '5',
    name: 'AHA/BHA Exfoliant Toner',
    brand: 'SkinLab',
    imageUrl: 'https://placehold.co/300x300/ede7f6/7c4dff?text=Toner',
    skinType: 'Karma Cilt',
    price: 198.00,
    ingredients: ['Glycolic Acid %7', 'Salicylic Acid %1', 'Lactic Acid', 'Witch Hazel'],
    purpose:
    'Karma ciltler için ideal olan bu peeling toner, hem yağlı bölgeleri hem de kuru alanları dengeler. Ölü deri hücrelerini arındırarak pürüzsüz ve aydınlık bir cilt görünümü sunar.',
  ),
  Product(
    id: '6',
    name: 'Moisture Barrier Balm',
    brand: 'ClearDerm',
    imageUrl: 'https://placehold.co/300x300/e8f5e9/388e3c?text=Balm',
    skinType: 'Kuru Cilt',
    price: 220.00,
    ingredients: ['Shea Butter', 'Squalane', 'Ceramide AP', 'Cholesterol'],
    purpose:
    'Çok kuru ve hassas ciltlerin nem bariyerini onarır. Zengin ve besleyici formülü ile cildi dış etkenlerden korurken yoğun bir nem hissi bırakır.',
  ),
  Product(
    id: '7',
    name: 'Pore Minimizer Essence',
    brand: 'DermaPure',
    imageUrl: 'https://placehold.co/300x300/fce4ec/e91e63?text=Essence',
    skinType: 'Yağlı Cilt',
    price: 165.90,
    ingredients: ['Niacinamide %10', 'Zinc %1', 'Tranexamic Acid', 'Green Tea Extract'],
    purpose:
    'Genişlemiş gözenekleri sıkılaştıran ve cilt dokusunu düzenleyen bu esas, yağlı ciltlerde sebum üretimini dengeler. Düzenli kullanımda gözenek görünümünü belirgin şekilde azaltır.',
  ),
  Product(
    id: '8',
    name: 'Collagen Boost Night Cream',
    brand: 'LumiSkin',
    imageUrl: 'https://placehold.co/300x300/e3f2fd/1565c0?text=Night',
    skinType: 'Normal Cilt',
    price: 389.00,
    ingredients: ['Retinol %0.5', 'Peptides Complex', 'Hyaluronic Acid', 'Bakuchiol'],
    purpose:
    'Gece boyunca çalışan bu anti-aging krem, uyku sırasında cildin yenilenme sürecini destekler. Retinol ve peptid kompleksi ile kırışıklıkları azaltır ve cilt elastikiyetini artırır.',
  ),
];

// ── Skin Type Filters ──────────────────────────────────────────────────────

const List<String> skinTypeFilters = [
  'Tümü',
  'Yağlı Cilt',
  'Kuru Cilt',
  'Karma Cilt',
  'Normal Cilt',
  'Hassas Cilt',
];

// ── Screen ─────────────────────────────────────────────────────────────────

class ProductCatalogScreen extends StatefulWidget {
  const ProductCatalogScreen({super.key});

  @override
  State<ProductCatalogScreen> createState() => _ProductCatalogScreenState();
}

class _ProductCatalogScreenState extends State<ProductCatalogScreen> {
  String _selectedFilter = 'Tümü';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  List<Product> get _filteredProducts {
    return mockProducts.where((p) {
      final matchesSkin = _selectedFilter == 'Tümü' || p.skinType == _selectedFilter;
      final matchesSearch = _searchQuery.isEmpty ||
          p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.brand.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesSkin && matchesSearch;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F2),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildSearchBar(),
            _buildFilterChips(),
            _buildResultCount(),
            Expanded(child: _buildProductGrid()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'DermaSmart',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF7B8FA6),
              letterSpacing: 2.5,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Ürün Kataloğu',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A2332),
              letterSpacing: -0.5,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1A2332).withOpacity(0.07),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (val) => setState(() => _searchQuery = val),
          decoration: InputDecoration(
            hintText: 'Ürün veya marka ara...',
            hintStyle: const TextStyle(
              color: Color(0xFFB0BEC5),
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: Color(0xFF7B8FA6),
              size: 22,
            ),
            suffixIcon: _searchQuery.isNotEmpty
                ? GestureDetector(
              onTap: () {
                _searchController.clear();
                setState(() => _searchQuery = '');
              },
              child: const Icon(
                Icons.close_rounded,
                color: Color(0xFF7B8FA6),
                size: 20,
              ),
            )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          style: const TextStyle(
            fontSize: 15,
            color: Color(0xFF1A2332),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: skinTypeFilters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = skinTypeFilters[index];
          final isSelected = _selectedFilter == filter;
          return GestureDetector(
            onTap: () => setState(() => _selectedFilter = filter),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF2C7DA0) : Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: isSelected ? const Color(0xFF2C7DA0) : const Color(0xFFE0E8F0),
                  width: 1.5,
                ),
                boxShadow: isSelected
                    ? [
                  BoxShadow(
                    color: const Color(0xFF2C7DA0).withOpacity(0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
                    : [],
              ),
              child: Text(
                filter,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? Colors.white : const Color(0xFF5A7085),
                  letterSpacing: 0.2,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildResultCount() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Text(
        '${_filteredProducts.length} ürün bulundu',
        style: const TextStyle(
          fontSize: 13,
          color: Color(0xFF7B8FA6),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildProductGrid() {
    final products = _filteredProducts;

    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.search_off_rounded, size: 56, color: Color(0xFFB0BEC5)),
            SizedBox(height: 16),
            Text(
              'Ürün bulunamadı',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF7B8FA6),
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Farklı bir filtre veya arama terimi deneyin',
              style: TextStyle(fontSize: 13, color: Color(0xFFB0BEC5)),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.58,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return _ProductCard(
          product: product,
          onTap: () => context.push('/product/${product.id}', extra: product),
        );
      },
    );
  }
}

// ── Product Card (ayrı StatelessWidget — context sorunu yok) ───────────────

class _ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const _ProductCard({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1A2332).withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ürün resmi
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: const Color(0xFFF0F4F8),
                    child: const Center(
                      child: Icon(
                        Icons.image_outlined,
                        size: 40,
                        color: Color(0xFFB0BEC5),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Ürün bilgisi
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Cilt tipi badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F4F8),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        product.skinType,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2C7DA0),
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Marka
                    Text(
                      product.brand,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF7B8FA6),
                        letterSpacing: 0.5,
                      ),
                    ),

                    const SizedBox(height: 2),

                    // Ürün adı
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A2332),
                        height: 1.3,
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Fiyat
                    Text(
                      '₺${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF2C7DA0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}