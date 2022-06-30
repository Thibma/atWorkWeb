import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_office_desktop/theme.dart';

import '../../models/ticket.dart';
import '../../services/network.dart';

class DemandesListWidget extends StatefulWidget {
  const DemandesListWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<DemandesListWidget> createState() => _DemandesListWidgetState();
}

class _DemandesListWidgetState extends State<DemandesListWidget> {
  late List<Ticket> tickets;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Network().getAllTickets(),
      builder: (context, AsyncSnapshot<List<Ticket>> snapshot) {
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
              List<Ticket> tickets = snapshot.requireData;
              return DemandesListDone(tickets: tickets);
            }
        }
      },
    );
  }
}

class DemandesListDone extends StatefulWidget {
  const DemandesListDone({
    Key? key,
    required this.tickets,
  }) : super(key: key);

  final List<Ticket> tickets;

  @override
  State<DemandesListDone> createState() => _DemandesListDoneState();
}

class _DemandesListDoneState extends State<DemandesListDone>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  late List<Ticket> tickets;

  RxList<Ticket> archivedTickets = RxList<Ticket>([]);
  RxList<Ticket> waitingTickets = RxList<Ticket>([]);

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tickets = widget.tickets;

    for (Ticket ticket in tickets) {
      if (ticket.status == TicketStatus.Waiting) {
        waitingTickets.add(ticket);
      } else {
        archivedTickets.add(ticket);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: tabController,
          labelColor: CustomTheme.colorTheme,
          indicatorColor: CustomTheme.colorTheme,
          tabs: [
            Tab(
              text: "Demandes en cours",
            ),
            Tab(
              text: "Demandes terminées",
            )
          ],
        ),
        Obx(
          () => Container(
            height: MediaQuery.of(context).size.height,
            child: TabBarView(controller: tabController, children: [
              DataTable(
                  columns: [
                    DataColumn(label: Text("ID")),
                    DataColumn(label: Text("Créateur")),
                    DataColumn(label: Text("Description")),
                    DataColumn(label: Text("Status")),
                    DataColumn(label: Text("Archiver")),
                  ],
                  rows: waitingTickets
                      .map(
                        (element) => DataRow(
                          cells: [
                            DataCell(Text(element.id)),
                            DataCell(Text(element.creator)),
                            DataCell(Text(element.description)),
                            DataCell(Text(element.status.name)),
                            DataCell(
                              ElevatedButton(
                                onPressed: () async {
                                  try {
                                    await Network().editTicket(
                                        TicketStatus.Closed, element.id);
                                    waitingTickets.remove(element);
                                    archivedTickets.add(element);
                                  } catch (e) {
                                    return;
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    primary: CustomTheme.colorTheme),
                                child: Text("Archiver"),
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList()),
              DataTable(
                  columns: [
                    DataColumn(label: Text("ID")),
                    DataColumn(label: Text("Créateur")),
                    DataColumn(label: Text("Description")),
                    DataColumn(label: Text("Status")),
                    DataColumn(label: Text("Ne plus archiver")),
                  ],
                  rows: archivedTickets
                      .map(
                        (element) => DataRow(
                          cells: [
                            DataCell(Text(element.id)),
                            DataCell(Text(element.creator)),
                            DataCell(Text(element.description)),
                            DataCell(Text(element.status.name)),
                            DataCell(
                              ElevatedButton(
                                onPressed: () async {},
                                style: ElevatedButton.styleFrom(
                                    primary: CustomTheme.colorTheme),
                                child: Text("Ne plus archiver"),
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList())
            ]),
          ),
        )
      ],
    );
  }
}
