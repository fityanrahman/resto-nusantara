import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission_resto/common/const_api.dart';
import 'package:submission_resto/data/api/api_service.dart';
import 'package:submission_resto/provider/review_provider.dart';
import 'package:submission_resto/ui/home_page.dart';

class OrderDialog extends StatelessWidget {
  final String idResto;

  const OrderDialog({required this.idResto, super.key});

  @override
  Widget build(BuildContext context) {
    String review = '';
    String nama = '';

    return AlertDialog(
      icon: const Icon(Icons.check_circle),
      title: const Center(child: Text('Order Berhasil')),
      content: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Pesanan akan segera dikirim ke alamat anda oleh driver. Review resto ini juga yuk!',
            ),
            TextField(
              autofocus: true,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                hintText: 'Nama',
                labelText: 'Nama',
              ),
              onChanged: (String value) {
                nama = value;
              },
            ),
            const SizedBox(
              height: 4,
            ),
            TextField(
              autofocus: true,
              textInputAction: TextInputAction.next,
              maxLines: 2,
              decoration: const InputDecoration(
                hintText: 'Bisa sih ga review juga. Tapi, yakali ga review :(',
                labelText: 'Review',
              ),
              onChanged: (String value) {
                review = value;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (review.isEmpty) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const HomePage()));
            } else {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => ChangeNotifierProvider(
                        create: (_) => ReviewProvider(
                            apiService: ApiService(),
                            nama: nama,
                            review: review,
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
      if (state.state == ResultState.loading) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              Text('Mengirim ulasan... '),
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
