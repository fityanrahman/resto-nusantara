import 'package:flutter/material.dart';
import 'package:submission_resto/data/model/transaction/order_model.dart';

class CartProvider extends ChangeNotifier {
  bool _isOngkirReg = true;
  final int _ongkirReg = 12000;
  final int _ongkirHemat = 5000;
  final int _biayaLayanan = 4000;

  int _harga = 0;
  int _ongkir = 12000;
  int _totalPesanan = 0;

  bool get isOngkirReg => _isOngkirReg;
  int get harga => _harga;
  int get ongkir => _ongkir;
  int get ongkirReg => _ongkirReg;
  int get ongkirHemat => _ongkirHemat;
  int get biayaLayanan => _biayaLayanan;
  int get totalPesanan => _totalPesanan;

  set isOngkirReg(bool isReg) {
    _isOngkirReg = isReg;
    notifyListeners();
  }

  set ongkir(int ongkir) {
    _ongkir = ongkir;
    notifyListeners();
  }

  void hitungPesanan(List<Order> pesanan) {
    _harga = pesanan.fold(0, (sum, item) => sum + item.price * item.qty);
    _totalPesanan = harga + ongkir + biayaLayanan;

    notifyListeners();
  }
}
