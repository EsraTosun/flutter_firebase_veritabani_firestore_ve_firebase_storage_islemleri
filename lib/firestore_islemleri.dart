import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FirestoreIslemleri extends StatelessWidget {
  FirestoreIslemleri({Key? key}) : super(key: key);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StreamSubscription? _userSubscribe;
  @override
  Widget build(BuildContext context) {
    //IDLer
    //debugPrint(_firestore.collection('users').id);
    //debugPrint(_firestore.collection('users').doc().id);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firestore Islemleri'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => veriEklemeAdd(),
              child: const Text('Veri Ekle Add'),
            ),
            ElevatedButton(
              onPressed: () => veriEklemeSet(),
              style: ElevatedButton.styleFrom(primary: Colors.green),
              child: const Text('Veri Ekle Set'),
            ),
            ElevatedButton(
              onPressed: () => veriGuncelleme(),
              style: ElevatedButton.styleFrom(primary: Colors.yellow),
              child: const Text('Veri Güncelle'),
            ),
            ElevatedButton(
              onPressed: () => veriSil(),
              style: ElevatedButton.styleFrom(primary: Colors.red),
              child: const Text('Veri Sil'),
            ),
            ElevatedButton(
              onPressed: () => veriOkuOneTime(),
              style: ElevatedButton.styleFrom(primary: Colors.pink),
              child: const Text('Veri Oku One Time'),
            ),
            ElevatedButton(
              onPressed: () => veriOkuRealTime(),
              style: ElevatedButton.styleFrom(primary: Colors.purple),
              child: const Text('Veri Oku Real Time'),
            ),
            ElevatedButton(
              onPressed: () => streamDurdur(),
              style: ElevatedButton.styleFrom(primary: Colors.teal),
              child: const Text('Stream Durdur'),
            ),
            ElevatedButton(
              onPressed: () => batchKavrami(),
              style: ElevatedButton.styleFrom(primary: Colors.indigo),
              child: const Text('Batch Kavramı'),
            ),
            ElevatedButton(
              onPressed: () => transactionKavrami(),
              style: ElevatedButton.styleFrom(primary: Colors.brown),
              child: const Text('Transaction Kavramı'),
            ),
            ElevatedButton(
              onPressed: () => queryingData(),
              style: ElevatedButton.styleFrom(primary: Colors.cyan),
              child: const Text('Veri Sorgulama'),
            ),
            ElevatedButton(
              onPressed: () => kameraGaleriImageUpload(),
              style: ElevatedButton.styleFrom(primary: Colors.blue),
              child: const Text('Kamera Galeri Image Upload'),
            ),
          ],
        ),
      ),
    );
  }

  veriEklemeAdd() async {  //koleksiyon üzerinden
    Map<String, dynamic> _eklenecekUser = <String, dynamic>{};
    _eklenecekUser['isim'] = 'emre';
    _eklenecekUser['yas'] = 34;
    _eklenecekUser['ogrenciMi'] = false;
    _eklenecekUser['adres'] = {'il': 'ankara', 'ilce': 'yenimahalle'};
    _eklenecekUser['renkler'] = FieldValue.arrayUnion(['mavi', 'yeşil']);
    _eklenecekUser['createdAt'] = FieldValue.serverTimestamp();
    await _firestore.collection('users').add(_eklenecekUser);
  }

  veriEklemeSet() async {   //Verinin üstüne yazar dokuman üzerinde
    var _yeniDocID = _firestore.collection('users').doc().id;

    await _firestore
        .doc('users/$_yeniDocID')
        .set({'isim': 'emre', 'userID': _yeniDocID});

    await _firestore.doc('users/bCaUA4bnr8hrR9hGUP77').set(
        {'okul': 'Ege Üniversitesi', 'yas': FieldValue.increment(-5)},
        SetOptions(merge: true));   //Verdiğimiz verileri ekler.var olan verileri silmez
    //FieldValue.increment(-5) => var olan değeri 5 azaltır
  }

  veriGuncelleme() async {
    await _firestore
        .doc('users/bCaUA4bnr8hrR9hGUP77')
        .update({'adres.ilce': 'yeni ilçe'});
  }

  veriSil() async {
    await _firestore.doc('users/bCaUA4bnr8hrR9hGUP77').delete();
    //CRUD
    await _firestore
        .doc('users/bCaUA4bnr8hrR9hGUP77')
        .update({'okul': FieldValue.delete()});
  }

  veriOkuOneTime() async {
    var _usersDocuments = await _firestore.collection('users').get();
    debugPrint(_usersDocuments.size.toString());
    debugPrint(_usersDocuments.docs.length.toString());
    for (var eleman in _usersDocuments.docs) {
      debugPrint('Döküman id ${eleman.id}');
      Map userMap = eleman.data();
      debugPrint(userMap['isim']);
    }

    var _emreDoc = await _firestore.doc('users/lODl1rILhnEeqeiDjBbj').get();
    debugPrint(_emreDoc.data()!['adres']['ilce'].toString());
  }

  veriOkuRealTime() async {
    //var _userStream = await _firestore.collection('users').snapshots();
    var _userDocStream =
        _firestore.doc('users/lODl1rILhnEeqeiDjBbj').snapshots();
    _userSubscribe = _userDocStream.listen((event) {
      /*  event.docChanges.forEach((element) {
        debugPrint(element.doc.data().toString());
      }); */

      debugPrint(event.data().toString());
    });
  }

  streamDurdur() async {
    await _userSubscribe?.cancel();
  }

  batchKavrami() async {
    WriteBatch _batch = _firestore.batch();
    CollectionReference _counterColRef = _firestore.collection('counter');

/*
    for (int i = 0; i < 100; i++) {
      var _yeniDoc = _counterColRef.doc();
      _batch.set(_yeniDoc, {'sayac': ++i, 'id':_yeniDoc.id});
    }*/

/*
    var _counterDocs = await _counterColRef.get();
    _counterDocs.docs.forEach((element) {
      _batch.update(
          element.reference, {'createdAt': FieldValue.serverTimestamp()});
    });*/

    var _counterDocs = await _counterColRef.get();
    _counterDocs.docs.forEach((element) {
      _batch.delete(element.reference);
    });

    await _batch.commit();
  }

  transactionKavrami() async {
    _firestore.runTransaction((transaction) async {
      //1emrenin bakiyesini öğren
      //emreden 100 lira düş
      //hasana 100 lira ekle
      DocumentReference<Map<String, dynamic>> emreRef =
          _firestore.doc('users/lODl1rILhnEeqeiDjBbj');
      DocumentReference<Map<String, dynamic>> hasanRef =
          _firestore.doc('users/UdpwK3unAKMMciZWUjKc');

      var _emreSnapshot = await transaction.get(emreRef);
      var _emreBakiye = _emreSnapshot.data()!['para'];
      if (_emreBakiye > 100) {
        var _yeniBakiye = _emreSnapshot.data()!['para'] - 100;
        transaction.update(emreRef, {'para': _yeniBakiye});
        transaction.update(hasanRef, {'para': FieldValue.increment(100)});
      }
    });
  }

  queryingData() async {
    var _userRef = _firestore.collection('users').limit(5);

    var _sonuc = await _userRef.where('renkler', arrayContains: 'mavi').get();
/* 
    for (var user in _sonuc.docs) {
      debugPrint(user.data().toString());
    } */

    var _sirala = await _userRef.orderBy('yas', descending: false).get();
    /*  for (var user in _sirala.docs) {
      debugPrint(user.data().toString());
    } */

    var _stringSearch = await _userRef
        .orderBy('email')
        .startAt(['emre']).endAt(['emre' + '\uf8ff']).get();
    for (var user in _stringSearch.docs) {
      debugPrint(user.data().toString());
    }
  }

  kameraGaleriImageUpload() async {
    print('fonksiyon çalıstı');
    final ImagePicker _picker = ImagePicker();

    XFile? _file = await _picker.pickImage(source: ImageSource.gallery);
    print('image secildi ');
    if (_file == null) {
      print('image null ');
    }
    var _profileRef =
        FirebaseStorage.instance.ref('users/profil_resimleri/user_id');
    print(_file?.name.toString());
    var _task = _profileRef.putFile(File(_file!.path));
    debugPrint('yükleme başlatılacak');
    _task.whenComplete(() async {
      var _url = await _profileRef.getDownloadURL();
      debugPrint('yükleme bitti');
      _firestore
          .doc('users/QPoLlmM3wLok9WQTlKrs')
          .set({'profile_pic': _url.toString()}, SetOptions(merge: true));
      debugPrint(_url);
    });
  }
}
