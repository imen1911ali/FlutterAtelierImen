import 'package:flutter/material.dart';

// =============================================================
// 1. PRODUCT MODEL
// =============================================================
class Product {
  final String name;
  final double price;
  final String image;
  final bool isNew;
  final double rating;
  final String description;
  final Map<String, String> specifications;

  const Product(
    this.name,
    this.price,
    this.image, {
    this.isNew = false,
    this.rating = 0.0,
    required this.description,
    required this.specifications,
  });
}

// =============================================================
// 2. MAIN PRODUCT LIST PAGE
// =============================================================
class ProductListPageM3 extends StatefulWidget {
  const ProductListPageM3({Key? key}) : super(key: key);

  @override
  State<ProductListPageM3> createState() => _ProductListPageM3State();
}

class _ProductListPageM3State extends State<ProductListPageM3> {
  final List<Product> products = const [
    Product(
      'iPhone 15',
      999,
      'assets/images/iphone15.jpeg',
      isNew: true,
      rating: 4.9,
      description: 'Découvrez le iPhone 15, un produit haute performance conçu pour répondre à tous vos besoins. Design élégant et fonctionnalités avancées pour une expérience exceptionnelle.',
      specifications: {
        'Écran': '6.1 pouces Super Retina XDR',
        'Processeur': 'A16 Bionic',
        'Mémoire': '8 GB',
        'Batterie': 'Jusqu\'à 20h de vidéo',
      },
    ),
    Product(
      'Samsung Galaxy',
      799,
      'assets/images/samsung_galaxy.jpg',
      isNew: false,
      rating: 4.2,
      description: 'Le Samsung Galaxy allie performance et design pour une expérience mobile optimale avec une autonomie exceptionnelle.',
      specifications: {
        'Écran': '6.4 pouces Dynamic AMOLED',
        'Processeur': 'Snapdragon 8 Gen 2',
        'Mémoire': '12 GB',
        'Batterie': 'Jusqu\'à 22h de vidéo',
      },
    ),
    Product(
      'Google Pixel',
      699,
      'assets/images/google_pixel.jpg',
      isNew: true,
      rating: 4.7,
      description: 'Le Google Pixel offre une expérience Android pure avec des fonctionnalités innovantes et une sécurité renforcée.',
      specifications: {
        'Écran': '6.2 pouces OLED',
        'Processeur': 'Google Tensor',
        'Mémoire': '8 GB',
        'Batterie': 'Jusqu\'à 24h de vidéo',
      },
    ),
  ];

  int _cartCount = 0;
  double _cartTotal = 0;

  void _addToCart(Product product) {
    setState(() {
      _cartCount++;
      _cartTotal += product.price;
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('${product.name} ajouté au panier')));
  }

  // =============================================================
  // 3. SHOW CART SUMMARY (Modifié)
  // =============================================================
  void _showCartSummary() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              // 🔹 TITRE AU CENTRE
              Text(
                'Récapitulatif Panier',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // 🔹 LES DEUX LIGNES AU CENTRE
              Text(
                'Articles : $_cartCount',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Total : ${_cartTotal.toStringAsFixed(2)} €',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // 🔹 BOUTON À DROITE SEULEMENT
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple, 
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Fermer',
                      style: TextStyle(
                          fontSize: 13,),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nos Produits'),
        backgroundColor: colorScheme.surface, // ✅ Surface normale (blanc)
        foregroundColor: colorScheme.onSurface, // ✅ Texte noir
        elevation: 0,
        actions: [
          // ✅ SUPPRIMÉ le Container avec decoration et gardé seulement IconButton
          IconButton(
            onPressed: _showCartSummary,
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(Icons.shopping_cart, color: colorScheme.primary), // ✅ Icône violette directement
                if (_cartCount > 0)
                  Positioned(
                    right: -6,
                    top: -6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12)),
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: Text(
                        '$_cartCount',
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: products.length,
        itemBuilder: (_, index) => ProductCard(
          product: products[index],
          onAddToCart: _addToCart,
        ),
      ),
    );
  }
}

// =============================================================
// 4. PRODUCT CARD
// =============================================================
class ProductCard extends StatefulWidget {
  final Product product;
  final ValueChanged<Product>? onAddToCart;

  const ProductCard({Key? key, required this.product, this.onAddToCart}) : super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  void _toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
      _isExpanded ? _controller.forward() : _controller.reverse();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 6,
                              offset: const Offset(0, 2)),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          product.image, 
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[200],
                              child: const Icon(Icons.phone_android, color: Colors.grey),
                            );
                          },
                        ),
                      ),
                    ),
                    if (product.isNew)
                      Positioned(
                        top: 4,
                        left: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(6)),
                          child: const Text(
                            'NEW',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(product.rating.toString()),
                          const SizedBox(width: 12),
                          Text(
                            '${product.price.toStringAsFixed(0)} €',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => widget.onAddToCart?.call(product),
                  icon: Icon(Icons.shopping_cart, color: colorScheme.primary),
                ),
                IconButton(
                  onPressed: _toggle,
                  icon: Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: colorScheme.onSurface,
                  ),
                )
              ],
            ),
          ),
          SizeTransition(
            sizeFactor: _animation,
            axisAlignment: 1.0,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  const SizedBox(height: 12),
                  Text(
                    'Description',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(product.description,
                      style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 16),
                  Text(
                    'Spécifications',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...product.specifications.entries.map(
                    (entry) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          SizedBox(
                              width: 100,
                              child: Text(entry.key,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium)),
                          Expanded(
                            child: Text(
                              entry.value,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}