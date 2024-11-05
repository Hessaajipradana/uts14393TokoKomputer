import 'package:flutter/material.dart';
import '../models/item.dart';

class TokoKomputerScreen extends StatefulWidget {
  @override
  _TokoKomputerScreenState createState() => _TokoKomputerScreenState();
}

class _TokoKomputerScreenState extends State<TokoKomputerScreen> {
  final List<Item> items = [
    Item(nama: 'Laptop', harga: 25000000),
    Item(nama: 'Mouse', harga: 1250000),
    Item(nama: 'Keyboard', harga: 1500000),
    Item(nama: 'Monitor', harga: 5000000),
    Item(nama: 'Printer', harga: 2200000),
  ];

  final Map<String, int> kuantitas = {};
  final Map<String, TextEditingController> controllers = {}; // Tambah controller > setiap item
  int total = 0;
  bool showReceipt = false;

  @override
  void initState() {
    super.initState();
    resetKuantitas();
    for (var item in items) {
      controllers[item.nama] = TextEditingController(); // Inisialisasi controller > setiap item
    }
  }

  @override
  void dispose() {
    // Hapus controller ? memory leak
    for (var controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void resetKuantitas() {
    setState(() {
      total = 0;
      showReceipt = false;
      for (var item in items) {
        kuantitas[item.nama] = 0;
        controllers[item.nama]?.clear(); // Bersihkan nilai > setiap TextField
      }
    });
  }

  void hitungTotal() {
    setState(() {
      total = items.fold(
        0,
        (sum, item) => sum + (kuantitas[item.nama]! * item.harga),
      );
    });
  }

  Widget buildItemList() {
    return Column(
      children: items.map((item) {
        return ListTile(
          title: Text(item.nama),
          subtitle: Text('Rp ${item.harga}'),
          trailing: SizedBox(
            width: 50,
            child: TextField(
              controller: controllers[item.nama], // Gunakan controller
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  kuantitas[item.nama] = int.tryParse(value) ?? 0;
                  hitungTotal();
                });
              },
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: resetKuantitas,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
          child: Text('Reset'),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              showReceipt = true;
            });
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          child: Text('Cetak Struk'),
        ),
      ],
    );
  }

  Widget buildReceipt() {
    return Column(
      children: [
        Divider(),
        Text(
          'Struk Pembelian',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Column(
          children: items.where((item) => kuantitas[item.nama]! > 0).map((item) {
            int subtotal = kuantitas[item.nama]! * item.harga;
            return ListTile(
              leading: Icon(Icons.shopping_bag),
              title: Text(item.nama),
              subtitle: Text('Rp ${item.harga} x ${kuantitas[item.nama]}'),
              trailing: Text('Rp $subtotal'),
            );
          }).toList(),
        ),
        buildTotalDisplay(),
      ],
    );
  }

  Widget buildTotalDisplay() {
    return Container(
      color: Colors.blue[100],
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            'Rp $total',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Toko Komputer')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              buildItemList(),
              SizedBox(height: 10),
              buildButtons(),
              if (showReceipt) buildReceipt(),
            ],
          ),
        ),
      ),
    );
  }
}
