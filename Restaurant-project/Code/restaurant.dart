enum MenuItem {
  Pizza,
  Burger,
  Pasta,
  FrenchFries,
  Salad,
  Drink
}
class Customer {
  String customerID;
  String name;
  String contactDetails;

  Customer(this.customerID, this.name, this.contactDetails);

  void placeOrder(Order order) {
    // Implementation for placing an order
  }

  void reserveTable(TableReservation reservation) {
    // Implementation for reserving a table
  }
}

class Menu {
  List<MenuItem> items = [];

  void addItem(MenuItem item) {
    items.add(item);
  }

  void removeItem(MenuItem item) {
    items.remove(item);
  }

  MenuItem getItem(int index) {
    return items[index];
  }
}

class Order {
  String orderID;
  Customer customer;
  List<MenuItem> items = [];
  double totalPrice = 0.0;
  String orderStatus;
  String paymentStatus;

  Order(this.orderID, this.customer, this.orderStatus, this.paymentStatus);

  void addItem(MenuItem item) {
    items.add(item);
    calculateTotal();
  }

  void removeItem(MenuItem item) {
    items.remove(item);
    calculateTotal();
  }

  void calculateTotal() {
    // Assuming each item has a fixed price for simplicity
    totalPrice = items.length * 10.0; // Example price calculation
  }
}

class TableReservation {
  String reservationID;
  Customer customer;
  int tableNumber;
  DateTime reservationTime;
  bool isReserved;

  TableReservation(this.reservationID, this.customer, this.tableNumber, this.reservationTime, this.isReserved);

  void reserveTable() {
    isReserved = true;
  }

  void cancelReservation() {
    isReserved = false;
  }

  String getReservationDetails() {
    return 'Reservation ID: $reservationID, Customer: ${customer.name}, Table Number: $tableNumber, Reservation Time: $reservationTime';
  }
}

void main() {
  // Example usage
  Customer customer = Customer('C001', 'Pen Sithol', '070-458-409');
  Menu menu = Menu();
  menu.addItem(MenuItem.Burger);
  menu.addItem(MenuItem.Drink);

  Order order = Order('O001', customer, 'Pending', 'Unpaid');
  order.addItem(MenuItem.Burger);
  order.calculateTotal();

  TableReservation reservation = TableReservation('R001', customer, 5, DateTime.now(), false);
  reservation.reserveTable();

  print('Order Total Price: ${order.totalPrice}');
  print('Reservation Details: ${reservation.getReservationDetails()}');
}