import 'package:flutter/material.dart';
import 'package:submission_resto/data/model/transaction/order_model.dart';
import 'package:submission_resto/ui/home_page.dart';
import 'package:submission_resto/widget/item_cart_widget.dart';

class CartPage extends StatefulWidget {
  static const routeName = '/cart-page';

  final List<Order> orders;

  const CartPage({required this.orders, Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  var menu = 0;
  var fav = false;

  // String? pengiriman;
  bool? regular = true;

  //tambahTransaksi
  List<Order> transaksi = [];
  var idSet = <String>{};
  var distinct = <Order>[];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: const Text('Keranjang'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              _itemCartWidget(textTheme, widget.orders),
              _opsiPengiriman(textTheme),
              _ringkasanBayar(textTheme),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(12),
          ),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) => _dialogOrder());
          },
          icon: const Icon(Icons.monetization_on),
          label: const Text('Bayar Pesanan'),
        ),
      ),
    );
  }

  Widget _ringkasanBayar(TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.only(top: 28.0, bottom: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('RIngkasan Pembayaran'),
          const SizedBox(
            height: 12,
          ),
          ListTile(
            visualDensity: const VisualDensity(vertical: -4),
            contentPadding: EdgeInsets.zero,
            minLeadingWidth: 0,
            title: const Text('Harga'),
            trailing: Text(
              'Rp 30.000',
              style: textTheme.bodyLarge,
            ),
          ),
          ListTile(
            visualDensity: const VisualDensity(vertical: -4),
            contentPadding: EdgeInsets.zero,
            minLeadingWidth: 0,
            title: const Text('Ongkir'),
            trailing: Text(
              'Rp 12.000',
              style: textTheme.bodyLarge,
            ),
          ),
          ListTile(
            visualDensity: const VisualDensity(vertical: -4),
            contentPadding: EdgeInsets.zero,
            minLeadingWidth: 0,
            title: const Text('Biaya Layanan'),
            trailing: Text(
              'Rp 4.000',
              style: textTheme.bodyLarge,
            ),
          ),
          ListTile(
            visualDensity: const VisualDensity(vertical: -4),
            contentPadding: EdgeInsets.zero,
            minLeadingWidth: 0,
            title: const Text('Total'),
            trailing: Text(
              'Rp 46.000',
              style: textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }

  Widget _opsiPengiriman(TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.only(top: 28.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Opsi Pengiriman'),
          const SizedBox(
            height: 12,
          ),
          ListTile(
            visualDensity: const VisualDensity(vertical: -4),
            contentPadding: EdgeInsets.zero,
            minLeadingWidth: 0,
            leading: SizedBox(
              height: 16,
              width: 16,
              child: Transform.scale(
                scale: 0.8,
                child: Radio(
                  value: true,
                  groupValue: regular,
                  onChanged: (bool? value) {
                    setState(() {
                      regular = value;
                    });
                  },
                ),
              ),
            ),
            title: const Text('Reguler'),
            trailing: Text(
              'Rp 12.000',
              style: textTheme.bodyLarge,
            ),
          ),
          ListTile(
            visualDensity: const VisualDensity(vertical: -4),
            contentPadding: EdgeInsets.zero,
            minLeadingWidth: 0,
            leading: SizedBox(
              height: 16,
              width: 16,
              child: Transform.scale(
                scale: 0.8,
                child: Radio(
                  value: false,
                  groupValue: regular,
                  onChanged: (bool? value) {
                    setState(() {
                      regular = value;
                    });
                  },
                ),
              ),
            ),
            title: const Text('Hemat'),
            trailing: Text(
              'Rp 5.000',
              style: textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemCartWidget(TextTheme textTheme, List<Order> order) {
    return Column(
      children: [
        ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: order.length,
          itemBuilder: (context, index) {
            return ItemCartWidget(
              textTheme: textTheme,
              order: order[index],
            );
          },
        ),
      ],
    );
  }

  Widget _dialogOrder() {
    return AlertDialog(
      icon: const Icon(Icons.check_circle),
      title: const Center(child: Text('Order Berhasil')),
      content: const Text(
          'Pesanan akan segera diproses oleh restoran, dan akan segera dikirim ke alamat anda oleh driver. '),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => const HomePage()));
            },
            child: const Text('OK')),
      ],
    );
  }
}
