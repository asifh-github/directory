class Item {
    protected long num;
    protected Item next;

    public Item(long input){
        num = input;
        next = null;
    }
}


class ListOfOrders {
    private Item head;
    private Item tail;
    private int size;

    public ListOfOrders(){
        head = null;
        tail = null;
        size = 0;
    }

    public int size(){
        return size;
    }

    public void addItem(long n){
        Item item = new Item(n);
        if(head == null){
            head = item;
        }
        else{
            tail.next = item;
        }
        tail = item;
        size++;
    }

    public void addItemPriority(long n){
        Item item = new Item(n);
        if(head == null){
            tail = item;
        }
        else{
            item.next = head;
        }
        head = item;
        size++;
    }

    public long removeItem() throws RuntimeException{
        if(size == 0){
            throw new RuntimeException("No orders in the list");
        }
        long result = head.num;
        head = head.next;
        size--;
        if(size == 0){
            tail = null;
        }
        return result;
    }

    public void printListOfOrders(){
        if(size == 0){
            System.out.println("List is empty");
        }
        Item temp = head;
        while(temp != null){
            System.out.println(temp.num);
            temp = temp.next;
        }
    }
}
