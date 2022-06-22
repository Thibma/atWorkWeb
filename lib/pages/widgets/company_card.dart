import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:my_office_desktop/theme.dart';

import '../../models/company.dart';

class CompanyCard extends StatelessWidget {
  const CompanyCard({
    Key? key,
    required this.companies,
  }) : super(key: key);

  final Company companies;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, 'company/${companies.id}/units');
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(CustomTheme.colorTheme),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder(
              future: loadImage(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Image.network(
                    snapshot.data.toString(),
                    width: 120,
                    height: 120,
                  );
                } else {
                  return Icon(
                    Icons.domain,
                    size: 120,
                    color: Colors.white,
                  );
                }
              },
            ),
            Text(
              companies.name,
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }

  Future<String?> loadImage() async {
    if (companies.image == null) {
      return null;
    }
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("companiesImages/${companies.image!}");
    var url = await ref.getDownloadURL();
    return url;
  }
}
