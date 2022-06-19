import 'package:flutter/material.dart';
import 'package:my_office_desktop/pages/widgets/textfield.dart';
import 'package:my_office_desktop/theme.dart';
import '../../models/company.dart';
import '../../services/network.dart';
import '../dashboard_admin_page.dart';

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
    required this.companies,
  }) : super(key: key);

  final List<Company> companies;
  final searchController = TextEditingController();

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
                  onPressed: () {},
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
                        controller: searchController)),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        GridView.builder(
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 150, crossAxisSpacing: 20),
          itemCount: companies.length,
          itemBuilder: (BuildContext ctx, index) {
            return CompanyCard(companies: companies[index]);
          },
        ),
      ],
    );
  }
}
