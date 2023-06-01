import 'package:flutter/material.dart';
import 'package:submission_resto/data/model/transaction/order_model.dart';
import 'package:submission_resto/ui/home_page.dart';
import 'package:submission_resto/widget/item_resto_widget.dart';

class CartPage extends StatefulWidget {
  static const routeName = '/cart-page';

  List<Order> orders;

  CartPage({required this.orders, Key? key}) : super(key: key);

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

  List<int> subTotal = [];
  List<int> hitungItem = [];
  int _itemHitung = 0;
  int _itemHarga = 0;

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
              _itemRestoWidget(textTheme, widget.orders),
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
      padding: const EdgeInsets.only(bottom: 80),
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
    return Column(
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
    );
  }

  Widget _itemRestoWidget(TextTheme textTheme, List<Order> order) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: order.length,
          itemBuilder: (context, index) {
            return ItemRestoWidget(
              textTheme: textTheme,
              order: order[index],
              tambahTransaksi: _tambahTransaksi,
            );
          },
        ),
      ],
    );
  }

  Widget _dialogOrder() {
    return AlertDialog(
      icon: Icon(Icons.check_circle),
      title: Center(child: Text('Order Berhasil')),
      content: Text(
          'Pesanan akan segera diproses oleh restoran, dan akan segera dikirim ke alamat anda oleh driver. '),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
            },
            child: Text('OK')),
      ],
    );
  }

  //callback for add order function
  void _tambahTransaksi(Order order) {
    hitungItem = [];
    _itemHitung = 0;

    subTotal = [];
    _itemHarga = 0;

    transaksi.add(order);

    for (var d in transaksi) {
      if (idSet.add(d.id)) {
        distinct.add(d);
      }
    }

    transaksi.clear();

    for (var d in distinct) {
      hitungItem.add(d.qty);
    }

    for (int e in hitungItem) {
      _itemHitung += e;
    }

    for (var j in distinct) {
      subTotal.add(j.qty * j.price);
    }

    for (int j in subTotal) {
      _itemHarga += j;
    }
  }
}
