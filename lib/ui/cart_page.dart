import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission_resto/data/model/arguments/restoArguments.dart';
import 'package:submission_resto/data/model/transaction/order_model.dart';
import 'package:submission_resto/provider/cart_provider.dart';
import 'package:submission_resto/widget/item_cart_widget.dart';
import 'package:submission_resto/widget/order_dialog.dart';

class CartPage extends StatefulWidget {
  static const routeName = '/cart-page';

  final RestoArguments args;

  const CartPage({required this.args, Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CartProvider>(context, listen: false)
          .hitungPesanan(widget.args.order);
    });
  }

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
              _itemCartWidget(textTheme, widget.args.order),
              _opsiPengiriman(textTheme),
              _ringkasanBayar(textTheme),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _bayarPesanan(context),
    );
  }

  Widget _bayarPesanan(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(12),
        ),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) =>
                  OrderDialog(idResto: widget.args.idResto));
        },
        icon: const Icon(Icons.monetization_on),
        label: const Text('Bayar Pesanan'),
      ),
    );
  }

  Widget _ringkasanBayar(TextTheme textTheme) {
    return Consumer<CartProvider>(builder: (context, state, _) {
      return Padding(
        padding: const EdgeInsets.only(top: 28.0, bottom: 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ringkasan Pembayaran',
              style: textTheme.titleMedium,
            ),
            const SizedBox(
              height: 12,
            ),
            ListTile(
              visualDensity: const VisualDensity(vertical: -4),
              contentPadding: EdgeInsets.zero,
              minLeadingWidth: 0,
              title: const Text('Harga'),
              trailing: Text(
                'Rp ${state.harga}',
                style: textTheme.bodyLarge,
              ),
            ),
            ListTile(
              visualDensity: const VisualDensity(vertical: -4),
              contentPadding: EdgeInsets.zero,
              minLeadingWidth: 0,
              title: const Text('Ongkir'),
              trailing: Text(
                'Rp ${state.ongkir}',
                style: textTheme.bodyLarge,
              ),
            ),
            ListTile(
              visualDensity: const VisualDensity(vertical: -4),
              contentPadding: EdgeInsets.zero,
              minLeadingWidth: 0,
              title: const Text('Biaya Layanan'),
              trailing: Text(
                'Rp ${state.biayaLayanan}',
                style: textTheme.bodyLarge,
              ),
            ),
            ListTile(
              visualDensity: const VisualDensity(vertical: -4),
              contentPadding: EdgeInsets.zero,
              minLeadingWidth: 0,
              title: const Text('Total'),
              trailing: Text(
                // 'Rp ${state.hitungPesanan(widget.orders)}',
                'Rp ${state.totalPesanan}',
                style: textTheme.bodyLarge,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _opsiPengiriman(TextTheme textTheme) {
    return Consumer<CartProvider>(builder: (context, state, _) {
      return Padding(
        padding: const EdgeInsets.only(top: 28.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Opsi Pengiriman',
              style: textTheme.titleMedium,
            ),
            const SizedBox(
              height: 12,
            ),
            InkWell(
              onTap: () {
                state.isOngkirReg = true;
                state.ongkir = state.ongkirReg;
                state.hitungPesanan(widget.args.order);
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: ListTile(
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
                      groupValue: state.isOngkirReg,
                      onChanged: (bool? value) {
                        state.isOngkirReg = value!;
                        state.ongkir = state.ongkirReg;
                        state.hitungPesanan(widget.args.order);
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
            ),
            InkWell(
              onTap: () {
                state.isOngkirReg = false;
                state.ongkir = state.ongkirHemat;
                state.hitungPesanan(widget.args.order);
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: ListTile(
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
                      groupValue: state.isOngkirReg,
                      onChanged: (bool? value) {
                        state.isOngkirReg = value!;
                        state.ongkir = state.ongkirHemat;
                        state.hitungPesanan(widget.args.order);
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
            ),
          ],
        ),
      );
    });
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
}
