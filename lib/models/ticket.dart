// ignore_for_file: constant_identifier_names

class Ticket {
  final String creator;
  final String description;
  final String id;
  final TicketStatus status;

  Ticket(
      {required this.creator,
      required this.description,
      required this.id,
      required this.status});

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
        creator: json["creator"],
        description: json["description"],
        id: json["_id"],
        status: TicketStatus.values.byName(json["status"]));
  }
}

enum TicketStatus { Waiting, Closed }
