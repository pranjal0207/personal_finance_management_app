import 'package:cloud_firestore/cloud_firestore.dart';
import 'transaction.dart';

class OFirestoreService {
    FirebaseFirestore _db = FirebaseFirestore.instance; 

    //Get Entries
    /*Stream<List<OTransaction>> getEntries(){
      return _db
        .collection('entries')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => OTransaction.fromMap(doc.data()))
        .toList());
    }*/

    getData() async{
      // ignore: deprecated_member_use
      return await _db.collection('records').orderBy('date', descending : true).getDocuments();
    }

    getFilter(int f, int l, String date) async{

      // ignore: deprecated_member_use
     /* if (f >=0 && l<=100000 && date == "")
        return await _db.collection('records').where('amount', isGreaterThanOrEqualTo: f).where('amount', isLessThanOrEqualTo: l).getDocuments();
      
      else
        return await _db.collection('records').where('date', isEqualTo: date).getDocuments();*/

      // ignore: deprecated_member_use
      var a = await _db.collection('records').where('amount', isGreaterThanOrEqualTo: f).where('amount', isLessThanOrEqualTo: l).getDocuments();
      // ignore: deprecated_member_use
      
      // ignore: deprecated_member_use
      var b = await _db.collection('records').where('date', isEqualTo: date).getDocuments();

      if (date == "")
        return a;

      else
        return b;      
    }

    deletedata(id){
      _db.collection('records').doc(id).delete();
    }

    updatedata(selected, newv){
      _db.collection('records').doc(selected).update(newv);
    }

    //Upsert
    Future<void> setEntry(OTransaction entry){
      var options = SetOptions(merge:true);

      return _db
        .collection('entries')
        .doc(entry.fid)
        .set(entry.toMap(),options);
    }

    //Delete

}