//Deklarasi function buat langkah 4//
//Function dgn parameter biasa (positional)
double hitungHargaSetelahDiskonBiasa(double harga, double persenDiskon) {
  return harga - (harga * persenDiskon);
}

//Function dgn named parameter & optional default value
double hitungHargaSetelahDiskon({
  required double harga,
  double persenDiskon = 0.0,
}) {
  return harga - (harga * persenDiskon);
}

//Arrow function
String formatRupiah(double harga) => "Rp ${harga.toStringAsFixed(0)}";

//Function hitung total
double hitungTotalBelanja(List<Product> keranjang) {
  double total = 0.0;
  for (var produk in keranjang) {
    total += produk.harga;
  }
  return total;
}

//Deklarasi class buat langkah 5//
class Product {
  String id;
  String nama;
  double harga;
  String kategori;
  int stok;

  String? description;

  Product({
    required this.id,
    required this.nama,
    required this.harga,
    required this.kategori,
    required this.stok,
    this.description,
  });

  String getStatusStok() {
    if (stok > 5) {
      return "Tersedia";
    } else if (stok > 0) {
      return "Stok Terbatas";
    } else {
      return "Habis";
    }
  }

  void cetakInfo() {
    print("[$id] $nama - Rp $harga | Stok: $stok (${getStatusStok()})");
    if (description != null) {
      print("Deskripsi: $description");
    } else {
      print("Deskripsi: (Tidak ada deskripsi)");
    }
  }
}

//Inheritance: DiscountedProduct
class DiscountedProduct extends Product {
  double discountPercent;

  DiscountedProduct({
    required String id,
    required String nama,
    required double harga,
    required String kategori,
    required int stok,
    String? description,
    required this.discountPercent,
  }) : super(
         id: id,
         nama: nama,
         harga: harga,
         kategori: kategori,
         stok: stok,
         description: description,
       ); // super() memanggil constructor dari class induk (Product)

  double hitungHargaFinal() {
    return harga - (harga * (discountPercent / 100));
  }
}

void main() {
  const namaToko = "TokoKita";
  final waktuBuka = DateTime.now();
  var kasir = "Pandi";

  String namaProduk = "Laptop";
  double harga = 15000000.0;
  int stok = 10;
  bool statusTersedia = true;

  //Mencetak nilai
  print("=== INFO PRODUK ===");
  print("Toko: $namaToko | Kasir: $kasir");
  print("Produk: $namaProduk");
  print("Harga: Rp $harga");
  print("Stok: $stok unit");
  print("Status Tersedia: $statusTersedia\n");

  //List daftar kategori dan Map (data mentah produk)
  List<String> daftarKategori = ["Elektronik", "Fashion", "Makanan"];

  Map<String, dynamic> produkMentah = {
    "id": "L101",
    "nama": "Laptop",
    "harga": 15000000.0,
    "stok": 10,
    "Kategori": "Elektronik",
    "Status Tersedia": true,
  };

  print("=== DAFTAR KATEGORI & DATA MENTAH ===");
  print("Kategori Produk: $daftarKategori");
  print("Data Mentah Produk(Map): $produkMentah\n");

  //Langkah 2
  double hargaProduk1 = 15000000.0;
  int stokProduk1 = 10;
  double hargaProduk2 = 5000000.0;
  int stokProduk2 = 0;

  //Aritmatika
  int jumlahBeli = 3;
  double totalHarga = hargaProduk1 * jumlahBeli;
  int sisaStok = stokProduk1 - jumlahBeli;

  print("=== OPERATOR ARITMATIKA ===");
  print("Total harga ($jumlahBeli item): Rp $totalHarga");
  print("Sisa stok Produk 1: $sisaStok\n");

  //Perbandingan
  bool apakahLebihMahal = hargaProduk1 > hargaProduk2;
  print("=== OPERATOR PERBANDINGAN ===");
  print("Produk 1 lebih mahal dari Produk 2? $apakahLebihMahal\n");

  //Logika
  bool layakTampilProduk1 = (stokProduk1 > 0) && (hargaProduk1 > 0);
  print("=== OPERATOR LOGIKA ===");
  print("Produk 1 layak tampil: $layakTampilProduk1\n");

  //Langkah 3 Control Flow untuk Logika Toko
  //if-else
  int jumlahStok = 3;
  String statusStok;

  if (jumlahStok > 5) {
    statusStok = "Tersedia";
  } else if (jumlahStok > 0) {
    statusStok = "Stok Terbatas";
  } else {
    statusStok = "Habis";
  }

  print("=== CONTROL FLOW: IF-ELSE ===");
  print("Jumlah Stok: $jumlahStok | Status: $statusStok\n");

  //Perulangan For
  List<double> daftarHargaBelanja = [150000.0, 50000.0, 200000.0, 75000.0];
  double totalBelanja = 0;

  for (int i = 0; i < daftarHargaBelanja.length; i++) {
    totalBelanja += daftarHargaBelanja[i];
  }

  print("=== CONTROL FLOW: FOR LOOP ===");
  print("Daftar Harga Item: $daftarHargaBelanja");
  print("Total Belanja: Rp $totalBelanja\n");

  //Perulangan While
  int stokSimulasi = 3;
  print("=== CONTROL FLOW: WHILE LOOP ===");
  while (stokSimulasi > 0) {
    print("Item dibeli! Sisa stok: $stokSimulasi");
    stokSimulasi--;
  }
  print("Stok habis! Sisa stok: $stokSimulasi\n");

  //Switch-Case
  String kategori = "Elektronik";
  double persenDiskon;

  switch (kategori) {
    case "Elektronik":
      persenDiskon = 0.10;
      break;
    case "Fashion":
      persenDiskon = 0.15;
      break;
    case "Makanan":
      persenDiskon = 0.05;
      break;
    default:
      persenDiskon = 0.0;
  }

  print("=== CONTROL FLOW: SWITCH-CASE ===");
  print("Kategori: $kategori");
  print("Besaran Diskon: ${persenDiskon * 100}%");

  //Langkah 4 Function untuk Logika Produk & Diskon
  print("\n=== FUNCTION: LOGIKA PRODUK & DISKON ===");

  double hargaAwal = 200000.0;

  double hargaDiskon = hitungHargaSetelahDiskon(
    harga: hargaAwal,
    persenDiskon: 0.15,
  );

  double hargaNormal = hitungHargaSetelahDiskon(harga: hargaAwal);

  print("Harga Awal: ${formatRupiah(hargaAwal)}");
  print("Harga Diskon (15%): ${formatRupiah(hargaDiskon)}");
  print("Harga Tanpa Diskon: ${formatRupiah(hargaNormal)}");

  //Langkah 5 Class Product & Null Safety
  print("\n=== CLASS PRODUCT & NULL SAFETY ===");

  // Instance dari class Product
  Product produkReguler = Product(
    id: "K201",
    nama: "Kamera Nikon",
    harga: 18500000.0,
    kategori: "Elektronik",
    stok: 5,
    description: "Kamera yang cocok untuk pemandangan.",
  );

  // Instance dari class turunan DiscountedProduct
  DiscountedProduct produkDiskon = DiscountedProduct(
    id: "KH61",
    nama: "Kaos Hitam Oversize",
    harga: 150000.0,
    kategori: "Fashion",
    stok: 50,
    discountPercent: 20.0,
  );

  produkReguler.cetakInfo();
  print("-------------------------");

  produkDiskon.cetakInfo();
  print(
    "Harga Final (Diskon ${produkDiskon.discountPercent}%): Rp ${produkDiskon.hitungHargaFinal()}",
  );

  //List dummy dan total belanja
  print("\n=== DATA DUMMY PRODUK ===");
  List<Product> daftarProduk = [
    Product(
      id: "P003",
      nama: "PC",
      harga: 25000000.0,
      kategori: "Elektronik",
      stok: 17,
      description: "PC gaming.",
    ),
    Product(
      id: "S202",
      nama: "Smartphone",
      harga: 18000000.0,
      kategori: "Elektronik",
      stok: 5,
    ),
    Product(
      id: "L313",
      nama: "Laptop Gaming",
      harga: 7500000.0,
      kategori: "Elektronik",
      stok: 13,
      description: "Laptop performa tinggi",
    ),
    Product(
      id: "KJ04",
      nama: "Kemeja Polo",
      harga: 85000.0,
      kategori: "Fashion",
      stok: 51,
      description: "Cocok untuk cuaca panas.",
    ),
    Product(
      id: "JK56",
      nama: "Jaket Kulit",
      harga: 250000.0,
      kategori: "Fashion",
      stok: 0,
    ),
    Product(
      id: "SS92",
      nama: "Sepatu Coklat",
      harga: 450000.0,
      kategori: "Fashion",
      stok: 31,
    ),
    Product(
      id: "KP5",
      nama: "Kopi Dubai",
      harga: 65000.0,
      kategori: "Makanan",
      stok: 11,
      description: "Aroma kopi yang khas.",
    ),
    Product(
      id: "CT9",
      nama: "Cokelat Almond",
      harga: 45000.0,
      kategori: "Makanan",
      stok: 1,
    ),
  ];

  for (var p in daftarProduk) {
    p.cetakInfo();
  }

  print("\n=== TOTAL KERANJANG ===");
  List<Product> totalKeranjang = [
    daftarProduk[1],
    daftarProduk[4],
    daftarProduk[7],
  ];

  double total = hitungTotalBelanja(totalKeranjang);
  print("Total isi Keranjang: ${totalKeranjang.length} item");
  print("Total Harga Belanja: Rp $total");
}
