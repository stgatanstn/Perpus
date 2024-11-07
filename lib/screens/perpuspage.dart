import 'package:flutter/material.dart';
import 'package:perpus_flutter/Controllers/perpus_controller.dart.dart';
import 'package:perpus_flutter/models/perpus.dart';
import 'package:perpus_flutter/widgeds/bottomnav.dart';
import 'package:perpus_flutter/widgeds/models.dart';

class PerpusPage extends StatefulWidget {
  const PerpusPage({super.key});

  @override
  State<PerpusPage> createState() => _PerpusViewState();
}

class _PerpusViewState extends State<PerpusPage> {
  final PerpusController perpusController = PerpusController();
  final TextEditingController judulInput = TextEditingController();
  final TextEditingController deskripsiInput = TextEditingController();
  final TextEditingController stokInput = TextEditingController();
  final TextEditingController pengarangInput = TextEditingController();
  final TextEditingController penerbitInput = TextEditingController();
  final TextEditingController coverInput = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ModalWidget modal = ModalWidget();

  List<String> listAct = ["Ubah", "Hapus"];
  List<Perpus>? buku;
  int? buku_id;

  void getBuku() {
    setState(() {
      buku = perpusController.perpus;
    });
  }

  void addBuku(Perpus data) {
    buku!.add(data);
    getBuku();
  }

  @override
  void initState() {
    super.initState();
    getBuku();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Perpustakaan"),
        backgroundColor: Colors.greenAccent,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                buku_id = null;
              });
              judulInput.clear();
              deskripsiInput.clear();
              stokInput.clear();
              pengarangInput.clear();
              penerbitInput.clear();
              coverInput.clear();
              modal.showFullModal(context, fromTambah(null));
            },
            icon: const Icon(Icons.add_sharp),
          ),
        ],
      ),
      body: buku != null && buku!.isNotEmpty
          ? ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: buku!.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Placeholder for book cover image
                        Container(
                          width: 60,
                          height: 90,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              buku![index]
                                  .cover, // Assuming cover holds the asset path
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[300],
                                  child: const Icon(
                                    Icons.error,
                                    color: Colors.red,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                buku![index].judul,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Pengarang: ${buku![index].pengarang}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Stok: ${buku![index].stok}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuButton<String>(
                          icon: const Icon(
                            Icons.more_vert,
                            size: 30.0,
                          ),
                          itemBuilder: (BuildContext context) {
                            return listAct.map((String choice) {
                              return PopupMenuItem<String>(
                                value: choice,
                                child: Text(choice),
                                onTap: () {
                                  if (choice == "Ubah") {
                                    setState(() {
                                      buku_id = buku![index].id;
                                    });

                                    judulInput.text = buku![index].judul;
                                    deskripsiInput.text =
                                        buku![index].deskripsi;
                                    stokInput.text =
                                        buku![index].stok.toString();
                                    pengarangInput.text =
                                        buku![index].pengarang;
                                    penerbitInput.text = buku![index].penerbit;
                                    coverInput.text = buku![index].cover;
                                    modal.showFullModal(
                                        context, fromTambah(index));
                                  } else if (choice == "Hapus") {
                                    setState(() {
                                      buku!.removeWhere(
                                          (item) => item.id == buku![index].id);
                                    });
                                    getBuku();
                                  }
                                },
                              );
                            }).toList();
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : Center(
              child: Text(
                "Data Kosong",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
      bottomNavigationBar: BottomNav(1),
    );
  }

  Widget fromTambah(int? index) {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              index == null ? "Tambah Data Buku" : "Ubah Data Buku",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: judulInput,
              decoration: const InputDecoration(labelText: "Judul"),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Harus diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 12.0),
            TextFormField(
              controller: deskripsiInput,
              decoration: const InputDecoration(labelText: "Deskripsi"),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Harus diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 12.0),
            TextFormField(
              controller: stokInput,
              decoration: const InputDecoration(labelText: "Stok"),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Harus diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 12.0),
            TextFormField(
              controller: pengarangInput,
              decoration: const InputDecoration(labelText: "Pengarang"),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Harus diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 12.0),
            TextFormField(
              controller: penerbitInput,
              decoration: const InputDecoration(labelText: "Penerbit"),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Harus diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 12.0),
            TextFormField(
              controller: coverInput,
              decoration: const InputDecoration(labelText: "Cover"),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Harus diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  if (index != null) {
                    // Update existing book
                    buku![index].judul = judulInput.text;
                    buku![index].deskripsi = deskripsiInput.text;
                    buku![index].stok = int.parse(stokInput.text);
                    buku![index].pengarang = pengarangInput.text;
                    buku![index].penerbit = penerbitInput.text;
                    buku![index].cover = coverInput.text;
                  } else {
                    // Add new book
                    buku_id = (buku?.length ?? 0) + 1;
                    Perpus data = Perpus(
                      id: buku_id!,
                      judul: judulInput.text,
                      deskripsi: deskripsiInput.text,
                      stok: int.parse(stokInput.text),
                      pengarang: pengarangInput.text,
                      penerbit: penerbitInput.text,
                      cover: coverInput.text,
                    );
                    addBuku(data);
                  }
                  Navigator.pop(context);
                  // Clear inputs after saving
                  judulInput.clear();
                  deskripsiInput.clear();
                  stokInput.clear();
                  pengarangInput.clear();
                  penerbitInput.clear();
                }
              },
              child: Text(index == null ? "Simpan" : "Update"),
            ),
          ],
        ),
      ),
    );
  }
}
