import 'package:flutter/material.dart';

// ------------------------
// Model Product
// ------------------------
class Product {
  final String name;
  final double price;
  final String image; // chemin d'asset
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

// ------------------------
// Page liste des produits
// ------------------------
class ProductListPageM6 extends StatefulWidget {
  const ProductListPageM6({super.key});

  @override
  State<ProductListPageM6> createState() => _ProductListPageM6State();
}

class _ProductListPageM6State extends State<ProductListPageM6> {
  final List<Product> products = const [
    Product(
      'iPhone 15',
      999.0,
      'assets/iphone-15.jpg',
      isNew: true,
      rating: 4.5,
      description:
          'Découvrez le iPhone 15, un produit haute performance conçu pour répondre à tous vos besoins. Design élégant et fonctionnalités avancées.',
      specifications: {
        'Écran': '6.1 pouces Super Retina XDR',
        'Processeur': 'A16 Bionic',
        'Mémoire': '128 GB',
        'Batterie': 'Jusqu\'à 20h de vidéo',
      },
    ),
    Product(
      'Samsung Galaxy',
      799.0,
      'assets/samsung.jpg',
      isNew: false,
      rating: 4.2,
      description:
          'Samsung Galaxy: performance et polyvalence. Idéal pour la photo et le multitâche.',
      specifications: {
        'Écran': '6.4 pouces AMOLED',
        'Processeur': 'Exynos / Snapdragon',
        'Mémoire': '128 GB',
        'Batterie': 'Jusqu\'à 22h',
      },
    ),
    Product(
      'Google Pixel',
      699.0,
      'assets/google.jpg',
      isNew: true,
      rating: 4.7,
      description:
          'Google Pixel: Android pur, appareil photo de haute qualité et mises à jour rapides.',
      specifications: {
        'Écran': '6.1 pouces OLED',
        'Processeur': 'Google Tensor',
        'Mémoire': '128 GB',
        'Batterie': 'Jusqu\'à 18h',
      },
    ),
  ];

  // Panier: map product -> quantity
  final Map<Product, int> cart = {};

  // Gérer quel index est développé (pour animer la flèche)
  int? expandedIndex;

  void addToCart(Product product) {
    setState(() {
      cart.update(product, (q) => q + 1, ifAbsent: () => 1);
    });

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} ajouté au panier'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  int get totalItems =>
      cart.values.fold(0, (previousValue, element) => previousValue + element);

  // Pour afficher la flèche animée selon l'état d'expansion
  Widget buildTrailing(int index, Product product) {
    final isExpanded = expandedIndex == index;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // bouton Ajouter au panier (icône)
        IconButton(
          onPressed: () => addToCart(product),
          icon: const Icon(Icons.add_shopping_cart),
          tooltip: 'Ajouter au panier',
        ),
        // icône flèche (manuelle)
        IconButton(
          onPressed: () {
            setState(() {
              expandedIndex = isExpanded ? null : index;
            });
          },
          icon: AnimatedRotation(
            turns: isExpanded ? 0.5 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: const Icon(Icons.expand_more),
          ),
          tooltip: isExpanded ? 'Réduire' : 'Développer',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nos Produits'),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        actions: [
          // icône panier avec badge
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CartPage(cart: cart),
                      ),
                    ).then((_) {
                      // pour rafraîchir le badge du panier au retour
                      setState(() {});
                    });
                  },
                  tooltip: 'Voir le panier',
                ),
                if (totalItems > 0)
                  Positioned(
                    right: 6,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        totalItems.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          final isExpanded = expandedIndex == index;

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                // Header (image + infos + actions)
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      // Image + badge NEW
                      Stack(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.grey[200],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                product.image,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[300],
                                    child: Icon(Icons.phone_android,
                                        size: 40, color: Colors.grey.shade600),
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
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'NEW',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      // Nom + note + prix
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.amber.shade600,
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                Text(product.rating.toString()),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${product.price.toStringAsFixed(1)} DT',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.primary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      // Actions: ajouter au panier + flèche
                      buildTrailing(index, product),
                    ],
                  ),
                ),

                // Partie expandable : description + specifications
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 200),
                  crossFadeState: isExpanded
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  firstChild: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(),
                        const SizedBox(height: 8),
                        const Text(
                          'Description',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 6),
                        Text(product.description),
                        const SizedBox(height: 12),
                        const Text(
                          'Spécifications',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 6),
                        ...product.specifications.entries.map((e) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      e.key,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Expanded(flex: 5, child: Text(e.value)),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                  secondChild: const SizedBox.shrink(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ------------------------
// Page Panier
// ------------------------
class CartPage extends StatefulWidget {
  final Map<Product, int> cart;

  const CartPage({super.key, required this.cart});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cardController = TextEditingController();

  static const double _shippingFee = 8.0; // Frais de livraison
  static const double _taxRate = 0.19; // 19 %

  double get subTotal {
    double total = 0;
    widget.cart.forEach((product, qty) {
      total += product.price * qty;
    });
    return total;
  }

  double get shipping => widget.cart.isEmpty ? 0 : _shippingFee;

  double get taxes => subTotal * _taxRate;

  double get grandTotal => subTotal + shipping + taxes;

  int get totalItems => widget.cart.values.fold(0, (a, b) => a + b);

  void increment(Product p) {
    setState(() {
      widget.cart.update(p, (q) => q + 1, ifAbsent: () => 1);
    });
  }

  void decrement(Product p) {
    setState(() {
      final current = widget.cart[p] ?? 0;
      if (current <= 1) {
        widget.cart.remove(p);
      } else {
        widget.cart[p] = current - 1;
      }
    });
  }

  void removeProduct(Product p) {
    setState(() {
      widget.cart.remove(p);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${p.name} supprimé du panier')),
    );
  }

  void clearCart() {
    setState(() {
      widget.cart.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Panier vidé')),
    );
  }

  void simulatePayment() {
    if (widget.cart.isEmpty) return;

    if (emailController.text.isEmpty || cardController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez remplir tous les champs'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Paiement simulé de ${grandTotal.toStringAsFixed(2)} DT effectué !'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );

    // Vider le panier après paiement
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        widget.cart.clear();
        emailController.clear();
        cardController.clear();
      });
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    cardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Récapitulatif du Panier'),
        actions: [
          if (widget.cart.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Vider le panier',
              onPressed: clearCart,
            ),
        ],
      ),
      body: widget.cart.isEmpty
          ? const _EmptyCartView()
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: widget.cart.entries.map((entry) {
                      final product = entry.key;
                      final qty = entry.value;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.grey[200],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.asset(
                                    product.image,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey[300],
                                        child: Icon(Icons.phone_android,
                                            size: 30, color: Colors.grey.shade600),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${product.price.toStringAsFixed(1)} DT',
                                      style: TextStyle(
                                        color: colorScheme.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.remove),
                                          onPressed: () => decrement(product),
                                          iconSize: 20,
                                          padding: EdgeInsets.zero,
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 4),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey.shade300),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            qty.toString(),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.add),
                                          onPressed: () => increment(product),
                                          iconSize: 20,
                                          padding: EdgeInsets.zero,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline,
                                        color: Colors.red),
                                    onPressed: () => removeProduct(product),
                                    tooltip: 'Supprimer',
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${(product.price * qty).toStringAsFixed(1)} DT',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                // Résumé + formulaire paiement
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 6,
                        offset: const Offset(0, -2),
                        color: Colors.black.withOpacity(0.05),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Résumé des prix
                      _buildSummaryRow('Sous-total', subTotal),
                      _buildSummaryRow('Frais de livraison', shipping),
                      _buildSummaryRow('Taxes (19%)', taxes),
                      const Divider(height: 16),
                      _buildSummaryRow(
                        'Total',
                        grandTotal,
                        isTotal: true,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      
                      // Formulaire de paiement
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.email_outlined),
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                          hintText: 'votre@email.com',
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: cardController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.credit_card),
                          labelText: 'Numéro de carte (simulation)',
                          border: OutlineInputBorder(),
                          hintText: '1234 5678 9012 3456',
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: simulatePayment,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Payer ${grandTotal.toStringAsFixed(2)} DT',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
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

  Widget _buildSummaryRow(String label, double amount,
      {bool isTotal = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal
                ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                : null,
          ),
          Text(
            '${amount.toStringAsFixed(2)} DT',
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 18 : 14,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------------
// Vue panier vide
// ------------------------
class _EmptyCartView extends StatelessWidget {
  const _EmptyCartView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Votre panier est vide',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ajoutez des produits pour commencer votre commande.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Retour aux produits'),
            ),
          ],
        ),
      ),
    );
  }
}