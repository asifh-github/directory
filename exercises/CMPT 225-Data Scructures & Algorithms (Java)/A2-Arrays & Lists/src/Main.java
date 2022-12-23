import java.util.concurrent.Callable;

class Main {
    public static void main(String args[]){
        //problem 2.1
        System.out.println(" ");
        System.out.println("---Problem 2.1---");

        //create books
        Books b1 = new Books();
        Books b2 = new Books();
        Books b3 = new Books();
        Books b4 = new Books();
        Books b5 = new Books();

        //set books' details
        b1.setName("Physics");
        b1.setAuthor("Matt");
        b1.setFlag(true);

        b2.setName("Maths");
        b2.setAuthor("Scott");
        b2.setFlag(true);

        b3.setName("Chemistry");
        b3.setAuthor("Derek");
        b3.setFlag(true);

        b4.setName("Computer");
        b4.setAuthor("Tim");
        b4.setFlag(true);

        b5.setName("Psychology");
        b5.setAuthor("Anna");
        b5.setFlag(true);

        //add new books
        System.out.println(" ");
        System.out.println("***Adding new books***");
        ArrayOfBooks arr =  new ArrayOfBooks(10);
        arr.addNew(b1);
        arr.addNew(b2);
        arr.addNew(b3);
        arr.addNew(b4);
        arr.addNew(b5);
        System.out.println(" ");
        System.out.println("***After adding five new books***");
        System.out.println("Total books owned: " + arr.booksOwned());

        //check-out books
        System.out.println(" ");
        arr.checkout(2);
        arr.checkout(0);
        //number of books is stock
        //number of books out on rent
        System.out.println("***After two books are checked out***");
        System.out.println("Total books in stock: " + arr.inStock());
        System.out.println("Total books out on rent: " + arr.outForRent());
        System.out.println(" ");
        System.out.println("***Checking out the book that is out on rent***");
        arr.checkout(0);

        //status of books && details (name && id)
        System.out.println(" ");
        System.out.println("***Status of book that has been checked out with book details***");
        arr.details(2);
        arr.status(2);


        //check-in books && status && details (name && id)
        System.out.println(" ");
        arr.checkin(2);
        System.out.println("***After one book is checked in***");
        System.out.println("Total books in stock: " + arr.inStock());
        System.out.println("Total books out on rent: " + arr.outForRent());
        System.out.println(" ");
        System.out.println("***Status of book that has been checked in with book details***");
        arr.details(2);
        arr.status(2);

        //remove a book and status
        System.out.println(" ");
        arr.removeOld(3);
        System.out.println("***After one book is removed***");
        System.out.println("Total books owned: " + arr.booksOwned());
        System.out.println("Total books in stock: " + arr.inStock());
        System.out.println("Total books out on rent: " + arr.outForRent());

        //add a new book
        System.out.println(" ");
        Books b6 = new Books();
        b6.setName("Computer 2");
        b6.setAuthor("Rachel");
        b6.setFlag(true);
        System.out.println("***Adding a new book***");
        arr.addNew(b6);
        arr.details(3);
        System.out.println("Total books owned: " + arr.booksOwned());

        //swap a new book with old
        System.out.println(" ");
        Books b7 = new Books();
        b7.setName("Computer 3");
        b7.setAuthor("Richard");
        b7.setFlag(true);
        System.out.println("***Swapping a old book with new***");
        arr.swap(3, b7);
        arr.details(3);
        System.out.println("Total books owned: " + arr.booksOwned());


        //problem 2.2
        System.out.println(" ");
        System.out.println(" ");
        System.out.println(" ");
        System.out.println("---Problem 2.2---");

        //create my queue
        MyQueue q = new MyQueue();

        //enqueue and dequeue operation
        System.out.println(" ");
        System.out.println("***Enqueuing three strings***");
        q.enqueue("The Lonely Club");
        q.enqueue("The Adventures of Galio");
        q.enqueue("The Ninja Academy");
        System.out.println(" ");
        System.out.println("***Dequeuing three string***");
        System.out.println(q.dequeue());
        System.out.println(q.dequeue());
        System.out.println(q.dequeue());


        System.out.println(" ");
        System.out.println("***Enqueuing more two strings***");
        q.enqueue("Villains Across The Street");
        q.enqueue("The Pirate King's First Mate");
        System.out.println(" ");
        System.out.println("***Dequeuing all five string***");
        System.out.println(q.dequeue());
        System.out.println(q.dequeue());
        System.out.println(q.dequeue());
        System.out.println(q.dequeue());
        System.out.println(q.dequeue());

        System.out.println(" ");
        System.out.println("***Enqueuing one last string***");
        q.enqueue("The One Eyed Demon");
        System.out.println(" ");
        System.out.println("***Dequeuing all strings***");
        System.out.println(q.dequeue());
        System.out.println(q.dequeue());
        System.out.println(q.dequeue());
        System.out.println(q.dequeue());
        System.out.println(q.dequeue());
        System.out.println(q.dequeue());


        //problem 2.3
        System.out.println(" ");
        System.out.println(" ");
        System.out.println(" ");
        System.out.println("---Problem 2.3---");

        //create list of strings
        //use add first and remove first method
        System.out.println(" ");
        System.out.println("***Creating a string of strings***");
        SLinkedList list1 = new SLinkedList();
        list1.addFirst("This");
        list1.addFirst("is");
        list1.addFirst("Norway...");
        list1.addFirst("Hail");
        list1.addFirst("Ragnar");
        list1.addFirst("Lothbrok!");
        list1.addFirst("!");
        list1.removeFirst();
        list1.addFirst("The");
        list1.addFirst("Viking");
        list1.addFirst("Legend.");
        list1.addFirst("!");
        list1.removeFirst();

        //print
        System.out.println(" ");
        System.out.println("***The corrupted string***");
        list1.printList();

        //iterative
        Reverse.iterative(list1);
        System.out.println(" ");
        System.out.println("(Iterative:)");
        System.out.println("***The reserved string***");
        list1.printList();

        //recursive
        Reverse.recursive(list1);
        System.out.println(" ");
        System.out.println("(Recursive:)");
        System.out.println("***The reserved string***");
        list1.printList();

        //problem 2.4
        System.out.println(" ");
        System.out.println(" ");
        System.out.println(" ");
        System.out.println("---Problem 2.4---");

        //create list of orders
        ListOfOrders orders = new ListOfOrders();

        //add items
        orders.addItem(200);
        System.out.println(" ");
        System.out.println("***After adding one item***");
        orders.printListOfOrders();

        orders.addItem(203);
        orders.addItem(250);
        orders.addItem(605);
        System.out.println(" ");
        System.out.println("***After adding three items***");
        orders.printListOfOrders();

        //add priority items
        orders.addItemPriority(101);
        orders.addItemPriority(007);
        System.out.println(" ");
        System.out.println("***After adding two priority items***");
        orders.printListOfOrders();

        //remove items
        orders.removeItem();
        System.out.println(" ");
        System.out.println("***After removing one item***");
        orders.printListOfOrders();

        orders.removeItem();
        orders.removeItem();
        orders.removeItem();
        System.out.println(" ");
        System.out.println("***After removing four items***");
        orders.printListOfOrders();

        orders.removeItem();
        orders.removeItem();
        System.out.println(" ");
        System.out.println("***After removing all items***");
        orders.printListOfOrders();


        //end
        System.out.println(" ");
        System.out.println(" ");
        System.out.println("---The End---");
    }
}
