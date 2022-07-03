import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_office_desktop/pages/dashboard_widgets/dialog_create_company.dart';
import 'package:my_office_desktop/pages/widgets/textfield.dart';
import 'package:my_office_desktop/theme.dart';
import '../../models/company.dart';
import '../../services/network.dart';
import 'package:my_office_desktop/pages/widgets/company_card.dart';

class CompaniesList extends StatelessWidget {
  const CompaniesList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Network().getAllCompany(),
      builder: (context, AsyncSnapshot<List<Company>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
              ),
            );
          default:
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              List<Company> companies = snapshot.requireData;
              return CompaniesListDone(companies: companies);
            }
        }
      },
    );
  }
}

class CompaniesListDone extends StatelessWidget {
  CompaniesListDone({
    Key? key,
    required List<Company> companies,
  })  : companiesList = RxList(companies),
        super(key: key);

  //List<Company> companies;
  RxList<Company> companiesList;
  final searchController = TextEditingController();
  RxList<Company> filteredList = RxList();

  void changed(String query) {
    filteredList.value = companiesList
        .where((element) =>
            element.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              flex: 1,
              child: SizedBox(
                width: 230,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    var reload = await showDialog(
                        context: context, builder: dialogCreateCompany);
                    if (reload != null) {
                      try {
                        final companiesReload = await Network().getAllCompany();
                        companiesList.value = companiesReload;
                      } catch (e) {
                        rethrow;
                      }
                    }
                  },
                  label: Text("Créer une entreprise"),
                  icon: Icon(Icons.add),
                  style:
                      ElevatedButton.styleFrom(primary: CustomTheme.colorTheme),
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: SizedBox(
                  child: TextFieldApp(
                    icon: Icons.search,
                    hint: "Rechercher",
                    controller: searchController,
                    changed: changed,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Obx(
          () => GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 180,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20),
            itemCount: filteredList.isEmpty && searchController.text.isEmpty
                ? companiesList.length
                : filteredList.length,
            itemBuilder: (BuildContext ctx, index) {
              return CompanyCard(
                  companies:
                      filteredList.isEmpty && searchController.text.isEmpty
                          ? companiesList[index]
                          : filteredList[index]);
            },
          ),
        ),
      ],
    );
  }
}
