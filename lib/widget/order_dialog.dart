import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission_resto/common/const_api.dart';
import 'package:submission_resto/data/api/api_service.dart';
import 'package:submission_resto/provider/review_provider.dart';
import 'package:submission_resto/ui/home_page.dart';

class OrderDialog extends StatelessWidget {
  final String idResto;

  OrderDialog({required this.idResto, super.key});

  @override
  Widget build(BuildContext context) {
    String _review = '';
    String _nama = '';

    return AlertDialog(
      icon: const Icon(Icons.check_circle),
      title: const Center(child: Text('Order Berhasil')),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Pesanan akan segera dikirim ke alamat anda oleh driver. Review resto ini juga yuk!',
          ),
          TextField(
            autofocus: true,
            textInputAction: TextInputAction.next,
            minLines: 1,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Bisa sih ga review juga. Tapi, yakali ga review :(',
              labelText: 'Review',
            ),
            onChanged: (String value) {
              _review = value;
            },
          ),
          TextField(
            autofocus: true,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              hintText: 'Nama',
              labelText: 'Nama',
            ),
            onChanged: (String value) {
              _nama = value;
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (_review.isEmpty) {
              print('review kosong');
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const HomePage()));
              print('ini isi review: $_review');
            } else {
              print('ini isi review: $_review');
              showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      // _dialogReview(review: _review, nama: _nama));
                      ChangeNotifierProvider(
                        create: (_) => ReviewProvider(
                            apiService: ApiService(),
                            nama: _nama,
                            review: _review,
                            id: idResto),
                        child: _dialogReview(),
                      ));
            }
          },
          child: const Text('OK'),
        ),
      ],
    );
  }

  Widget _dialogReview() {
    return Consumer<ReviewProvider>(builder: (contextReview, state, _) {
      print('stateTerkini : ${state.state}');
      if (state.state == ResultState.loading) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              const Text('Mengirim ulasan... '),
            ],
          ),
        );
      } else if (state.state == ResultState.hasData) {
        return AlertDialog(
          icon: const Icon(Icons.check_circle),
          title: const Center(child: Text('Review Berhasil')),
          content: const Text('Terima kasih telah memberi resto ini ulasan!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(contextReview);
                Navigator.pushReplacement(contextReview,
                    MaterialPageRoute(builder: (context) => const HomePage()));
              },
              child: const Text('OK'),
            ),
          ],
        );
      } else if (state.state == ResultState.networkError) {
        return AlertDialog(
          icon: const Icon(Icons.network_check),
          title: const Center(child: Text('Kendala Koneksi Internet')),
          content: Text(state.message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(contextReview);
              },
              child: const Text('OK'),
            ),
          ],
        );
      } else {
        return AlertDialog(
          icon: const Icon(Icons.warning),
          title: const Center(child: Text('Gagal Mengirim Review')),
          content: Text(state.message),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(contextReview);
                },
                child: const Text('OK')),
          ],
        );
      }
    });
  }
}
