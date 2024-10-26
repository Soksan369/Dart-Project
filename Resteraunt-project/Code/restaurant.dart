import 'dart:io';

class MenuItem {
  String name;
  double price;

  MenuItem(this.name, this.price);
}

class Menu {
  List<MenuItem> items = [];

  void addItem(MenuItem item) {
    items.add(item);
  }

  void removeItem(MenuItem item) {
    items.remove(item);
  }

  List<MenuItem> getItems() {
    return items;
  }
}

class Order {
  int orderId;
  Customer customer;
  List<MenuItem> items = [];
  double totalPrice = 0.0;
  String orderStatus;
  String paymentStatus;

  Order(this.orderId, this.customer, this.orderStatus, this.paymentStatus);

  void addItem(MenuItem item) {
    items.add(item);
    calculateTotal();
  }

  void removeItem(MenuItem item) {
    items.remove(item);
    calculateTotal();
  }

  void calculateTotal() {
    totalPrice = items.fold(0, (sum, item) => sum + item.price);
  }

  void updateOrderStatus(String status) {
    orderStatus = status;
  }

  void updatePaymentStatus(String status) {
    paymentStatus = status;
  }

  Map<String, dynamic> getOrderDetails() {
    return {
      'orderId': orderId,
      'customer': customer.name,
      'items': items.map((item) => item.name).toList(),
      'totalPrice': totalPrice,
      'orderStatus': orderStatus,
      'paymentStatus': paymentStatus
    };
  }
}

class TableReservation {
  int reservationId;
  Customer customer;
  int? tableNumber;
  DateTime? reservationTime;

  TableReservation(this.reservationId, this.customer, this.tableNumber, this.reservationTime);

  void reserveTable(int tableNumber, DateTime time) {
    this.tableNumber = tableNumber;
    this.reservationTime = time;
  }

  void cancelReservation() {
    this.tableNumber = null;
    this.reservationTime = null;
  }

  Map<String, dynamic> getReservationDetails() {
    return {
      'reservationId': reservationId,
      'customer': customer.name,
      'tableNumber': tableNumber,
      'reservationTime': reservationTime
    };
  }
}

class Customer {
  int customerId;
  String name;
  String contactDetails;

  Customer(this.customerId, this.name, this.contactDetails);

  Order placeOrder(int orderId, List<MenuItem> items) {
    Order order = Order(orderId, this, 'Pending', 'Unpaid');
    for (var item in items) {
      order.addItem(item);
    }
    return order;
  }

  TableReservation reserveTable(int reservationId, int tableNumber, DateTime time) {
    return TableReservation(reservationId, this, tableNumber, time);
  }
}

void saveOrderToFile(Order order) {
  File file = File('orders.txt');
  file.writeAsStringSync('${order.getOrderDetails()}\n', mode: FileMode.append);
}

void saveReservationToFile(TableReservation reservation) {
  File file = File('reservations.txt');
  file.writeAsStringSync('${reservation.getReservationDetails()}\n', mode: FileMode.append);
}

void main() {
  Menu menu = Menu();
  menu.addItem(MenuItem('Pizza', 10.0));
  menu.addItem(MenuItem('Burger', 5.0));

  Customer customer = Customer(1, 'John Doe', '123-456-7890');

  while (true) {
    print('Select an option:');
    print('1. Place Order');
    print('2. Reserve Table');
    print('3. Exit');

    String choice = stdin.readLineSync() ?? '';

    switch (choice) {
      case '1':
        Order order = customer.placeOrder(1, menu.getItems());
        order.updateOrderStatus('Completed');
        order.updatePaymentStatus('Paid');
        print('Order Total: \$${order.totalPrice}');
        saveOrderToFile(order);
        break;
      case '2':
        print('Enter table number:');
        int tableNumber = int.parse(stdin.readLineSync() ?? '0');
        TableReservation reservation = customer.reserveTable(1, tableNumber, DateTime.now());
        reservation.reserveTable(tableNumber, DateTime.now().add(Duration(days: 1)));
        print('Reservation Details: ${reservation.getReservationDetails()}');
        saveReservationToFile(reservation);
        break;
      case '3':
        exit(0);
      default:
        print('Invalid choice. Please try again.');
    }
  }
}