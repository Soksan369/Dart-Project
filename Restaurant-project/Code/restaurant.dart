class MenuItem {
  String name;
  double price;

  MenuItem(this.name, this.price);
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
    totalPrice = items.fold(0.0, (sum, item) => sum + item.price);
  }
  String getRecipe() {
    return 'Order ID: $orderID, Customer: ${customer.name}, Total Price: $totalPrice';
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
  menu.addItem(MenuItem('Burger', 5.0));
  menu.addItem(MenuItem('Drink', 2.0));

  Order order = Order('O001', customer, 'Pending', 'Unpaid');
  order.addItem(MenuItem('Burger', 5.0));
  order.addItem(MenuItem('Drink', 2.0));
  order.calculateTotal();

  TableReservation reservation = TableReservation('R001', customer, 5, DateTime.now(), false);
  reservation.reserveTable();

  print('Reciepe: ${order.getRecipe()}');
  print('Reservation Details: ${reservation.getReservationDetails()}');
}