class ArrayOfBooks {
    private Books[] array;
    private int capacity;
    private int size;
    private int empty;

    public ArrayOfBooks(int capacity){
        array = new Books[capacity];
        this.capacity = capacity;
        size = 0;
        empty = capacity;
    }

    public void checkout(int id) throws RuntimeException{
        if(id >= capacity){
            throw new RuntimeException("Invalid ID");
        }

        if(array[id].isFlag() == false){
            System.out.println("Book out on rent");
        }
        else {
            array[id].setFlag(false);
            size--;
        }
    }

    public void checkin(int id) throws RuntimeException{
        if(id >= capacity){
            throw new RuntimeException("Invalid ID");
        }

        array[id].setFlag(true);
        size++;
    }

    public void status(int id) throws RuntimeException{
        if(id >= capacity){
            throw new RuntimeException("Invalid ID");
        }

        if(array[id].isFlag() == true){
            System.out.println("In stock.");
        }
        else{
            System.out.println("Out on rent.");
        }
    }

    public void details(int id) throws RuntimeException{
        if(id >= capacity){
            throw new RuntimeException("Invalid ID");
        }

        if(array[id] == null){
            System.out.println("Book does not exist");
        }
        else {
            System.out.println("Book: " + array[id].getName());
            System.out.println("Author: " + array[id].getAuthor());
        }
    }

    public void removeOld(int id) throws RuntimeException{
        if(id >= capacity){
            throw new RuntimeException("Invalid ID");
        }

        Books temp = array[id];
        array[id] = null;
        empty++;
        size--;
    }

    public void addNew(Books newBook){
        for(int i=0; i<array.length; i++){
            if(array[i] == null){
                array[i] = newBook;
                array[i].setId(i);
                size++;
                empty--;
                System.out.println("Book ID: " + array[i].getId());
                return;
            }
        }
        System.out.println("No empty space");
    }
    public void swap(int oldID, Books newBook) throws RuntimeException{
        if(oldID >= capacity){
            throw new RuntimeException("Invalid ID");
        }

        Books temp = array[oldID];
        array[oldID] = newBook;
        array[oldID].setId(oldID);
        System.out.println("Book ID: " + array[oldID].getId());
    }

    public int booksOwned(){
        return capacity-empty;
    }

    public int inStock(){
        return size;
    }

    public int outForRent(){
        return capacity-empty-size;
    }
}
