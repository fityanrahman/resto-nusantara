import 'package:flutter/material.dart';
import 'package:submission_resto/ui/home_page.dart';

class CartPage extends StatefulWidget {
  static const routeName = '/cart-page';

  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  var menu = 0;
  var fav = false;

  // String? pengiriman;
  bool? regular = true;

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
              _itemRestoWidget(textTheme),
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
      padding: const EdgeInsets.only(top: 28),
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
      padding: const EdgeInsets.only(top: 28),
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

  Widget _itemRestoWidget(TextTheme textTheme) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: const BoxDecoration(
            border: Border.symmetric(
              horizontal: BorderSide(
                color: Color(0xffd9d9d9),
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8),
                  ),
                  child: Image.network(
                    'https://restaurant-api.dicoding.dev/images/medium/14',
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, error, _) =>
                        const Center(child: Icon(Icons.error)),
                  ),
                ),
                title: const Text('Kari kacang dan telur'),
                subtitle: const Text('Rp 10.000'),
              ),
              Padding(
                padding: EdgeInsets.only(left: menu == 0 ? 16 : 0, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    menu == 0
                        ? ElevatedButton(
                            onPressed: () {
                              setState(() {
                                menu++;
                                print('menu : $menu');
                              });
                            },
                            child: Text(
                              'Tambah',
                              style: textTheme.labelSmall,
                            ),
                          )
                        : Row(
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  minimumSize: Size.zero,
                                  fixedSize: const Size(24, 24),
                                  padding: EdgeInsets.zero,
                                ),
                                onPressed: () {
                                  setState(() {
                                    menu--;
                                    print('menu : $menu');
                                  });
                                },
                                child: const Icon(
                                  Icons.remove,
                                  size: 16,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Text(menu.toString()),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  minimumSize: Size.zero,
                                  fixedSize: const Size(24, 24),
                                  padding: EdgeInsets.zero,
                                ),
                                onPressed: () {
                                  setState(() {
                                    menu++;
                                    print('menu : $menu');
                                  });
                                },
                                child: const Icon(
                                  Icons.add,
                                  size: 16,
                                ),
                              ),
                            ],
                          ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          fav = !fav;
                          print(fav);
                        });
                      },
                      icon: Icon(
                        fav ? Icons.star : Icons.star_outline,
                        color: Colors.orangeAccent,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _dialogOrder() {
    return AlertDialog(
      icon: Icon(Icons.check_circle),
      title: Center(child: Text('Order Berhasil')),
      content: Text('Pesanan akan segera diproses oleh restoran, dan akan segera dikirim ke alamat anda oleh driver. '),
      actions: [
        TextButton(onPressed: () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => HomePage()));
        }, child: Text('OK')),
      ],
    );
  }
}
